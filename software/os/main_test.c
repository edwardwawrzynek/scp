#include <lib/kstdio_layer.h>
#include <lib/kmalloc.h>

#include "include/defs.h"

#include "fs/superblock.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include "fs/fs.h"
#include "fs/file.h"
#include "fs/dir.h"
#include "kernel/proc.h"

#include "kernel/mmu.h"
#include "kernel/kernel.h"

#include "kernel/shed.h"

#include "include/tty.h"

#include <lib/util.h>

char buf[256];
char *arg;
char *arg2;
char *arg3;

#define DIGARR "0123456789abcdef"
void hexdump(unsigned char * mem, unsigned int n){
    unsigned char * dig;
    unsigned int i, j;
    unsigned char is_end;
    dig = DIGARR;
    for(i = 0; i < n; ++i){
        putchar(dig[(*mem)>>4]);
        putchar(dig[(*(mem++))&0x0f]);
        is_end = (i%10) == 9;
        putchar(is_end ? '|' : ' ');
        if(is_end){
            //print out ascii representation
            mem = mem - 10;
            for(j = 0; j < 10; ++j){
                if(*mem != '\n' && *mem != '\t' && *mem != 8){
                    putchar(*mem);
                } else {
                    putchar(219);
                }
                mem++;
            }
        }
    }
}

void list_dir(struct file_entry * dir){
    uint16_t i;
    uint8_t name[14];
    file_seek(dir, 0, SEEK_SET);
    i = dir_next_entry(dir, name);
    while(i){
        printf("%u: %s\n", i, name);
        i = dir_next_entry(dir, name);
    }
}


void debug(){
    __asm("\tnop.n.n\n");
    __asm("\t.dc.w 16\n");
}

//switch back to user mode in kernel to allow ints (just for testing/debug)
void switch_to_user(){

}

//switch to system mode in kernel (just for testing/debug)
void switch_to_sys(){

}



//print the contents of a file
void file_print(uint16_t cwd, char * file){
    struct file_entry * f;
    uint16_t i;
    uint8_t ind;
    uint16_t p;
    i = fs_path_to_inum(file, cwd, 2);
    if(i == 0){
        printf("no such file: %s\n", file);
        return;
    }
    f = file_get(i, FILE_MODE_READ);
    while(file_read(f, (uint8_t *)&p, 1) == 1){
        putchar(p);
    }
    file_put(f);
}


void serial_recv(uint16_t cwd, char * path){
    struct file_entry * f;
    uint16_t i;
    //buffer of bytes - bytes[0] is most recently recv'd
    unsigned char buf[4];
    unsigned char recv;
    unsigned int loop_num;

    struct termios tio;
    struct termios old_tio;

    tio.flags &= (~TERMIOS_CANON);
    tio.flags &= (~TERMIOS_ECHO);
    tio.flags &= (~TERMIOS_CTRL);

    kstdio_set_output_dev(2);
    kstdio_ioctl(TCGETA, (uint16_t)&old_tio);
    kstdio_ioctl(TCSETA, (uint16_t)&tio);
    loop_num = 0;
    //create file
    i = dir_make_file(cwd, path, 0, 0, 0);
    if(!i){
        printf("Failure making file\n");
    }
    //open file
    f = file_get(i, FILE_MODE_TRUNCATE | FILE_MODE_WRITE);
    if(!f){
        printf("Failure openning file\n");
    }
    //recv write loop
    while(1){
        recv = getchar();
        //write back byte
        putchar(recv);
        //write buf[3] to file
        if(loop_num > 3){
            file_write(f, &buf[3], 1);
            buf[3] = buf[3] + 5;
        }
        //advance bytes in buffer
        buf[3] = buf[2];
        buf[2] = buf[1];
        buf[1] = buf[0];
        //write in new buf to buffer
        buf[0] = recv;
        //check for end condition
        if(buf[0] == 0x00 && buf[1] == 0xff && buf[2] == 0x0f && buf[3] == 0xf0){
            kstdio_set_output_dev(2);
            kstdio_ioctl(TCSETA, (uint16_t)&old_tio);
            kstdio_set_output_dev(1);
            file_put(f);
            printf("File Recovered\n");
            return;
        }
        loop_num++;

    }
}

int main(){
    struct file_entry * fin;

    uint16_t inum;
    uint16_t cwd;

    struct file_entry * pfile;


    uint16_t pinum, pinum2;
    char *i;


    kernel_init();
    printf("Kernel Inited\nPress enter for serial loader autoboot\n:");
    if(getchar() == 0xa){
        kernel_start_init("/serial");
    }
    cwd = 2;
    fin = file_get(cwd, FILE_MODE_READ);
    arg = buf+2;
    while(1){
        printf("\nCWD: %u\n", cwd);
        printf("$ ");
        gets(buf);

        i = arg;

        putchar('\n');
        switch(buf[0]){
        case 'e':
            fs_close();
            printf("Saved file system\n");
            return 255;

            break;
        case 'l':
            list_dir(fin);
            break;
        case 'm':
            printf("%u\n", dir_make_file(cwd, arg, 0, 0, 0));
            break;
        case 't':
            printf("%u\n", dir_make_file(cwd, "tty0", 1, 0, 0));
            printf("%u\n", dir_make_file(cwd, "serial0", 2, 0, 0));
            printf("%u\n", dir_make_file(cwd, "null", 4, 0, 0));
            printf("%u\n", dir_make_file(cwd, "zero", 5, 0, 0));
            printf("%u\n", dir_make_file(cwd, "random", 6, 0, 0));
            break;
        case 'z':;
            struct file_entry * f = file_get(fs_path_to_inum(arg, cwd, 2), FILE_MODE_WRITE);
            if(!f){
                printf("Failure");
            }
            file_write(f, "helloworldaa\0\0a", 16);
            break;
        case 'r':
            if(dir_delete_file(cwd, arg)){
                printf("No such file: %s\n", arg);
            }
            break;
        case 'i':
            printf("%u\n", dir_name_inum(cwd, arg));
            break;
        case 'd':
            if(!dir_make_dir(cwd, arg)){
                printf("Failure");
            }
            break;
        case 'c':
            inum = fs_path_to_inum(arg, cwd, 2);
            if(inum == 0){
                printf("No such dir\n");
                break;
            } else {
                cwd = inum;
                file_put(fin);
                fin = file_get(cwd, FILE_MODE_READ);
            }
            break;
        case 's':
            serial_recv(cwd, arg);
            break;
        case 'p':
            file_print(cwd, arg);
            break;

        case 'n':;
            /* Simulate behavior of init */
            proc_current_pid_alloc = 2;
            int pinum = fs_path_to_inum(arg, cwd, 2);
            if(!pinum){
                printf("No such file: %s\n", arg);
                break;
            }
            struct proc * pproc = proc_create_new(pinum, 0, cwd, 2);
            if(!pproc){
                printf("Error creating proc\n");
            }
            shed_shedule();
            break;

        case 'x':
            debug();
            break;


        default:
            printf("No such command: %c\n", buf[0]);
            break;
        }
    }
}
int _isdigit(c) char c;{
        if (c >= '0' & c <= '9')      return(1);
        else                            return(0);
        }
#define EOL 10
int atoi(s) char s[];{
        int i,n,sign;
        for (i=0; (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t'); ++i);
        sign = 1;
        if(s[i]=='-'){
        	sign = -1;
            ++i;
	    }
        for(n = 0;_isdigit(s[i]);
                ++i)
                n = 10 * n + s[i] - '0';
        return (sign * n);

}
