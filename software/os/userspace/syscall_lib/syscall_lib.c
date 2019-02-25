#include "include/defs.h"
#include "syscall.h"


/* System Call Wrappers
 * The actual syscalls are implemented in asm, but wrappers for ones that need to block are implemented here */

/* blocking wrappers for non blocking read and write
 * TODO: yield cpu time when waiting */

uint16_t read(uint16_t fd, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_out = 0;
    do {
        uint16_t read = read_nb(fd, buffer, bytes, &eof);
        buffer += read;
        bytes_out += read;
        bytes -= read;
    } while ((!eof) && bytes);

    return bytes_out;
}

uint16_t write(uint16_t fd, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_in = 0;
    do {
        uint16_t read = write_nb(fd, buffer, bytes, &eof);
        buffer += read;
        bytes_in += read;
        bytes -= read;
    } while ((!eof) && bytes);

    return bytes_in;
}