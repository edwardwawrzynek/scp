#include "include/defs.h"
#include "fs/incl.h"
//Main testing file for os
extern unsigned char * brk;
extern unsigned char * _MEM_END;

char buf[512];
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

main(){
    uint16_t i;
	brk = &_MEM_END;
    fs_init();

    //Fill up block
    for(i = 0; i < 64; ++i){
        buf[i] = 5+(i>>2);
    }
    //write to disk
    disk_write(234, buf);

    memset(buf, 0, 512);
    //Fill up block
    for(i = 0; i < 64; ++i){
        buf[i] = 34+(i>>2);
    }
    //write to disk
    disk_write(254, buf);
    putchar('\n');
    memset(buf, 0, 512);
    disk_read(254, buf);
    hexdump(buf, 64);
    putchar('\n');
    memset(buf, 0, 512);
    disk_read(234, buf);
    hexdump(buf, 64);
    
}
