#include <stddef.h>
#include <stdint.h>
#include <lib/string.h>
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