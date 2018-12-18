#include "include/defs.h"
#include "fs/incl.h"
//Main testing file for os
extern unsigned char * brk;
extern unsigned char * _MEM_END;

char buf[256];
char *arg;

#define DIGARR "0123456789abcdef"
hexdump(unsigned char * mem, unsigned int n){
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

list_dir(struct file_entry * dir){
    uint16_t i;
    uint8_t name[14];
    i = dir_next_entry(dir, name);
    while(i){
        printf("%u: %s\n", i, name);
        i = dir_next_entry(dir, name);
    }
}

main(){
    struct file_entry * fin;
    uint16_t inum;
    uint16_t cwd;
	brk = &_MEM_END;
    fs_init();
    printf("%u\n", brk);
    cwd = 2;
    fin = file_get(cwd, FILE_MODE_READ);
    arg = buf+2;
    while(1){
        printf("\nCWD: %u\n", cwd);
        printf("$ ");
        gets(buf);
        file_put(fin);
        fin = file_get(cwd, FILE_MODE_READ);
        file_seek(fin, 0, SEEK_SET);
        putchar('\n');
        switch(buf[0]){
        case 'e':
            fs_close();
            return 0;
        case 'l':
            list_dir(fin);
            break;
        case 'm':
            dir_make_file(cwd, arg, 0, 0);
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
            printf("Inum: %u\n", fs_path_to_inum(arg, cwd));
            break;
        }
    }
}
