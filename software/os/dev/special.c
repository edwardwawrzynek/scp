/**
 * special os file device drivers (major number 1)
 * minor number assignments:
 * 0 - /dev/null
 * 1 - /dev/zero
 * 2 - /dev/random
 * 3 - /sys/shutdown
 */

#include "dev.h"

#include <lib/inout.h>
#include <stdint.h>
#include "errno.h"
#include "kernel/kernel.h"


/* /dev/random - highly insecure */
static uint16_t rand_val = 25746;
static uint16_t rand_a = 8003;
static uint16_t rand_c = 17177;
static uint16_t rand_m = 61794;

static int random_getc(){
    rand_val = (rand_a * rand_val + rand_c) % rand_m;
    return (rand_val>>2)&0xff;
}

int _special_write(int minor, uint8_t * buf, size_t bytes, uint8_t *eof, struct inode *file) {
    *eof = 0;
    if(minor == DEV_MINOR_SHUTDOWN) {
        /* any non zero write to /sys/shutdown triggers shutdown */
        uint16_t b = bytes;
        while(b--) {
            if(*(buf++)) kernel_shutdown();
        }
        return bytes;
    } 

    /* default - thrown written stuff away */
    return bytes;
}

int _special_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file){
    *eof = 0;
    if(minor == DEV_MINOR_ZERO) {
        memset(buf, 0, bytes);
        return bytes;
    } else if(minor == DEV_MINOR_RANDOM) {
        uint16_t b = bytes;
        while(b--) {
            *(buf++) = random_getc();
        }
        return bytes;
    } else {
        *eof = 1;
        return 0;
    }
}

int _special_open(int minor, struct inode *file){
    return 0;
}
int _special_close(int minor, struct inode*file){
    
    return 0;
}
int _special_ioctl(int minor, int req_code, uint8_t * arg, struct inode *file){
    set_errno(ENOTTY);
    return -1;
}
