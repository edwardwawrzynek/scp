/**
 * /dev/null, /dev/zero, and /dev/random device drivers
 */

#include "dev.h"

#include <lib/inout.h>
#include <stdint.h>

/* /dev/null - discard writes, eof on read */
int _null_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file){
    *eof = 0;
    return bytes;
}

/* /dev/zero - discard reads, 0 on read */
/* uses _null_write */

int _zero_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file){
    memset(buf, 0, bytes);
    return bytes;
}

/* /dev/random - unsecure random number generation */
/* uses _null_write */

uint16_t rand_val = 25746;
uint16_t rand_a = 8003;
uint16_t rand_c = 17177;
uint16_t rand_m = 61794;

static int random_getc(){
    rand_val = (rand_a * rand_val + rand_c)%rand_m;
    return (rand_val>>2)&0xff;
}

/* generate read and write methods */
gen_read_from_getc(_random_read, random_getc)
