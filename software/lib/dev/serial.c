/**
 * Device driver for serial interface
 * can be used as a tty
 * Edward Wawrzynek
 */

#include "dev.h"

#include <inout.h>
#include <stdint.h>

/* serial device structure */
struct _serial_dev {
    /* nothing needed */
};

/* only one serial interface is supported now - may change if we add multiple uarts */
struct _serial_dev serial;

/* write out a char */
static int serial_putc(char c){
    /* we can wait for uart to finish sending - it is pretty fast - we could return and just not set eof */
    while(inp(_serial_tx_busy_port));
    outp(3, c);
    return 0;
}

/* read in a char from the serial input */
int serial_getc(){
    char res;
    if(!inp(_serial_in_waiting_port)){
        /* not eof, just blocking */
        return -2;
    }
    res = inp(_serial_data_in_port);
    outp(1, 1);
    return res;
}

/* open a serial - only allow openning a single serial port */
int _serial_open(int minor){
    if(minor)
        return 1;

    return 0;
}

/* close the serial*/
int _serial_close(int minor){
    return 0;
}

/* write - just call serial_putc */
gen_write_from_putc(_serial_write, serial_putc)

gen_read_from_getc(_serial_read, serial_getc)

/* write wrapper */
void write(int (*func)(int, uint8_t *, size_t, uint8_t *), char *msg, size_t bytes){
    uint8_t eof;
    func(0, msg, bytes, &eof);
}

/* read wrapper */
void read(int (*func)(int, uint8_t *, size_t, uint8_t *), char *msg, size_t bytes){
    uint8_t eof;
    int size;

    do{
        size = func(0, msg, bytes, &eof);
        msg += size;
        bytes -= size;
    } while(eof);
}

char *msg = "hello, world!";

char buf[200];

int main(){
    uint8_t b;
    uint8_t eof = 65;
    uint8_t a;
    /*_tty_write(0, msg, 13, &eof);*/
    write(_serial_write, "hello, world! This is a test", 28);
    while(1){
        read(_serial_read, buf, 1);
        write(_serial_write, buf, 1);
    }
}
