#include "include/defs.h"
#include "syscall.h"
#include <stdint.h>

/* helpful for debugging */

#define DIGARR "0123456789abcdef"
void hexdump(unsigned char * mem, unsigned int n){
    unsigned char * dig;
    unsigned int i, j;
    unsigned char is_end;
    dig = DIGARR;
    for(i = 0; i < n; ++i){
        test_syscall("%c", (uint16_t)dig[(*mem)>>4]);
        test_syscall("%c", (uint16_t)dig[(*(mem++))&0x0f]);
        is_end = (i%20) == 19;
        test_syscall("%c", (uint16_t)is_end ? '|' : ' ');
        if(is_end){
            mem = mem - 20;
            for(j = 0; j < 20; ++j){
                if(*mem != '\n' && *mem != '\t' && *mem != 8){
                    test_syscall("%c", (uint16_t)*mem);
                } else {
                    test_syscall("%c", (uint16_t)219);
                }
                mem++;
            }
        }
    }
    test_syscall("%c", (uint16_t)'\n');
}

/* System Call Wrappers
 * The actual syscalls are implemented in asm, but wrappers for ones that need to block are implemented here */

/* blocking wrappers for non blocking read and write
 * yield's cpu time when waiting */

uint16_t read(uint16_t fd, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_out = 0;
    while(1) {
        uint16_t read = read_nb(fd, buffer, bytes, &eof);
        if(read == -1){
            return -1;
        }
        buffer += read;
        bytes_out += read;
        bytes -= read;
        if(!( (!eof) && bytes )){
            break;
        }
        //yield();
    }

    return bytes_out;
}

uint16_t write(uint16_t fd, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_in = 0;
    while(1) {
        uint16_t read = write_nb(fd, buffer, bytes, &eof);
        if(read == -1){
            return -1;
        }
        buffer += read;
        bytes_in += read;
        bytes -= read;
        if(!( (!eof) && bytes )){
            break;
        }
        yield();
    };

    return bytes_in;
}

/* wrapper for wait_nb syscall */
uint16_t wait(uint8_t *val){
    uint16_t ret;
    while(1) {
        ret = wait_nb(val);
        if(ret){
           break;
        }
        yield();
    };

    return ret;
}

/* readdir syscall on top of read */
uint16_t readdir(uint16_t fd, struct dirent * dirp){
    uint16_t bytes;
    /* read name */
    bytes = read(fd, dirp->name, 14);
    if(bytes == -1){
        return -1;
    }
    if(bytes != 14){
        return 0;
    }
    /* read inum */
    bytes = read(fd, (uint8_t *)(&dirp->inum), 2);
    if(bytes == -1){
        return -1;
    }
    if(bytes != 2){
        return 0;
    }

    return 1;
}