/**
 * Device driver for serial interface
 * can be used as a tty
 * Edward Wawrzynek
 */

#include "dev.h"

#include <lib/inout.h>
#include <stdint.h>

/* TODO: buffer incoming chars in software to allow for more than just 256 bytes in hardware buffer to be stored */

/* serial device structure */
struct _serial_dev {
    /* TODO: buffer serial input */
    uint8_t nothing;
    tty_dev_t tty_dev;
};

/* only one serial interface is supported now - may change if we add multiple uarts */
static struct _serial_dev serial;

/* write out a char */
static int serial_putc(char c){
    /* we can wait for uart to finish sending - it is pretty fast - we could return and just not set eof */
    while(inp(_serial_tx_busy_port));
    outp(_serial_data_out_port, c&0x7f);
    return 0;
}

/* read in a char from the serial input */
static int serial_getc(){
    unsigned int res;
    if(!inp(_serial_in_waiting_port)){
        /* not eof, just blocking */
        return DEV_BLOCKING;
    }
    res = inp(_serial_data_in_port);
    outp(_serial_next_port, 1);


    return res;
}

/* open a serial - only allow openning a single serial port */
int _serial_open(int minor, struct inode *f){
    if(minor)
        return -1;

    serial.tty_dev.termios.c_iflag = _TERMIOS_CIFLAG_DEFAULT;
    serial.tty_dev.termios.c_lflag = _TERMIOS_CLFLAG_DEFAULT;
    serial.tty_dev.termios.c_oflag = _TERMIOS_COFLAG_DEFAULT;
    return 0;
}

/* close the serial*/
int _serial_close(int minor, struct inode *f){
    return 0;
}

/* generate read and write methods */
gen_tty_write_from_putc(_serial_write, serial_putc, serial.tty_dev)

//gen_read_from_getc(_serial_read, serial_getc)
gen_tty_read_from_getc(_serial_read, serial_getc, serial_putc, serial.tty_dev)

gen_tty_ioctl_from_tty_dev(_serial_ioctl, serial.tty_dev)