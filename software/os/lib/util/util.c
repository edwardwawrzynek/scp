#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <lib/kstdio_layer.h>

/* functions for reading and writing to buffers (little endian) */

uint8_t _read_byte(uint8_t **buf){
    return *((*buf)++);
}

void _read_bytes(uint8_t **buf, uint8_t *dst, size_t bytes){
    memcpy(dst, *buf, bytes);
    (*buf) += bytes;
}

uint16_t _read_word(uint8_t **buf){
    uint16_t res;

    res =  (*((*buf)++));
    res += (*((*buf)++)) << 8;

    return res;
}

void _write_byte(uint8_t **buf, uint8_t byte){
    *((*buf)++) = byte;
}

void _write_word(uint8_t **buf, uint16_t word){
    *((*buf)++) = word &0xff;
    *((*buf)++) = word >> 8;
}

/* helpful for debugging */

#define DIGARR "0123456789abcdef"
void hexdump(unsigned char * mem, unsigned int n){
    unsigned char * dig;
    unsigned int i, j;
    unsigned char is_end;
    dig = DIGARR;
    for(i = 0; i < n; ++i){
        putchar(dig[(*mem)>>4]);
        putchar(dig[(*(mem++))&0x0f]);
        is_end = (i%20) == 19;
        putchar(is_end ? '|' : ' ');
        if(is_end){
            mem = mem - 20;
            for(j = 0; j < 20; ++j){
                if(*mem != '\n' && *mem != '\t' && *mem != 8){
                    putchar(*mem);
                } else {
                    putchar(219);
                }
                mem++;
            }
        }
    }
    putchar('\n');
}