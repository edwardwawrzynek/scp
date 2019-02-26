#include "include/defs.h"
#include "syscall.h"


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