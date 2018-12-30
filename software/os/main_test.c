#include "include/defs.h"
#include "fs/incl.h"
#include "kernel/incl.h"
#include "lib/incl.h"

//Main testing file for os
extern int brk;
extern unsigned char * _MEM_END;

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
    i = dir_next_entry(dir, name);
    while(i){
        printf("%u: %s\n", i, name);
        i = dir_next_entry(dir, name);
    }
}


void debug(){
    _asm("\n\
        .db #254\n\
        .db #1\n\
    ");
}

//switch back to user mode in kernel to allow ints (just for testing/debug)
void switch_to_user(){
    _asm("\n\
        lbia    #0\n\
        aptb\n\
        prvu\n\
    ");
}

//switch to system mode in kernel (just for testing/debug)
void switch_to_sys(){
    _asm("\n\
        lbia    #0\n\
        aptb\n\
        prvs\n\
    ");
}

//load a file from the serial port
void serial_load(uint16_t cwd, char * file){
    struct file_entry * f;
    uint16_t i;
    //buffer of bytes - bytes[0] is most recently recv'd
    unsigned int buf[4];
    unsigned char recv;
    unsigned int loop_num;

    loop_num = 0;
    //create file
    i = dir_make_file(cwd, arg, 0, 0);
    //open file
    f = file_get(i, FILE_MODE_TRUNCATE | FILE_MODE_WRITE);
    //recv write loop
    while(1){
        recv = serial_read();
        //write back byte
        serial_write(recv);
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
            file_put(f);
            return;
        }
        loop_num++;

    }
}

//print the contents of a file
void file_print(uint16_t cwd, char * file){
    struct file_entry * f;
    uint16_t i;
    uint8_t ind;
    uint16_t p;
    i = fs_path_to_inum(file, cwd);
    if(i == 0){
        printf("no such file: %s\n", file);
        return;
    }
    f = file_get(i, FILE_MODE_READ);
    while(file_read(f, &p, 1) == 1){
        putchar(p);
    }
}

int main(){
    struct file_entry * fin;
    struct proc * pproc;
    struct proc * pproc2;
    uint16_t inum;
    uint16_t cwd;

    struct file_entry * pfile;

    struct proc_mem proc_mem_s;
    uint16_t pinum, pinum2;
    char *i;

    switch_to_sys();

	brk = &_MEM_END;
    printf("Initing Kernel\n");
    kernel_init();
    printf("Kernel Inited\n");

    switch_to_user();

    cwd = 2;
    fin = file_get(cwd, FILE_MODE_READ);
    arg = buf+2;
    while(1){
        printf("\nCWD: %u\n", cwd);
        printf("$ ");
        gets(buf);

        i = arg;
        while( (*(i++)) != ' ');
        arg2 = i;
        if(i < buf+256 && i >= buf){
            *(i-1) = 0;
        }

        file_put(fin);
        fin = file_get(cwd, FILE_MODE_READ);
        file_seek(fin, 0, SEEK_SET);
        putchar('\n');
        switch(buf[0]){
        case 'e':
            fs_close();
            _asm("\n\
                .db #255\n\
                ");
            break;
        case 'l':
            list_dir(fin);
            break;
        case 'm':
            printf("%u\n", dir_make_file(cwd, arg, 0, 0));
            break;
        case 'r':
            dir_delete_file(cwd, arg);
            break;
        case 'i':
            printf("%u\n", dir_name_inum(cwd, arg));
            break;
        case 'd':
            dir_make_dir(cwd, arg);
            break;
        case 'c':
            inum = fs_path_to_inum(arg, cwd);
            if(inum == 0){
                printf("No such dir\n");
                break;
            }
            cwd = inum;
            file_put(fin);
            fin = file_get(cwd, FILE_MODE_READ);
            break;
        case 's':
            serial_load(cwd, arg);
            break;
        case 'p':
            file_print(cwd, arg);
            break;
        case 'x':
            debug();
            break;
        case 'n':
            switch_to_sys();
            pinum = fs_path_to_inum(arg, cwd);
            pproc = proc_create_new(100, pinum);
            pinum2 = fs_path_to_inum(arg2, cwd);
            pproc2 = proc_create_new(101, pinum2);
            if(pproc && pproc2){
                shed_shedule();
            } else {
                printf("Failure\n");
            }
            switch_to_user();
            break;

        default:
            printf("No such command: %c\n", buf[0]);
            break;
        }
    }
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
int _isdigit(c) char c;{
        if (c >= '0' & c <= '9')      return(1);
        else                            return(0);
        }