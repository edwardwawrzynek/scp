#include <lib/kstdio_layer.h>
#include <lib/kmalloc.h>

#include "include/defs.h"

#include "fs/superblock.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include "fs/fs.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "kernel/mmu.h"

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
    __asm("\t.dc.w 1\n");
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
    i = fs_path_to_inum(file, cwd);
    if(i == 0){
        printf("no such file: %s\n", file);
        return;
    }
    f = file_get(i, FILE_MODE_READ);
    while(file_read(f, (uint8_t *)&p, 1) == 1){
        putchar(p);
    }
}

int main(){
    struct file_entry * fin;

    uint16_t inum;
    uint16_t cwd;

    struct file_entry * pfile;


    uint16_t pinum, pinum2;
    char *i;

    switch_to_sys();


    printf("Initing Kernel\n");
    fs_init();
    mmu_init_clear_table();
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
            printf("%u\n", dir_make_file(cwd, arg, 0, 0));
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
            inum = fs_path_to_inum(arg, cwd);
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

            break;
        case 'p':
            file_print(cwd, arg);
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
