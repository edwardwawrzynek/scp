/**
 * Device driver for the vga text output and ps2 keyboard input
 * together, they make up the main teletype terminal
 * Edward Wawrzynek
 */

#include "dev.h"

#include <inout.h>
#include <stdint.h>

/* tty device structure */
struct _tty_dev {
    /* x position */
    uint8_t pos_x;
    /* y position */
    uint8_t pos_y;
};

/* only one tty is supported right now - other ttys will probably need different drivers */
struct _tty_dev tty;

/* scroll the text on the screen */
static void tty_scroll(){
    int i, val;
    /* move text up */
    for(i = 0; i < 1920; i++){
        outp(5, i+80);
        val = inp(6);
        outp(5, i);
        outp(6, val);
    }
    /* clear last line */
    for(i = 1920; i < 2000; i++){
        outp(5, i);
        outp(6, '\0');
    }
}

/* write out a char */
static int tty_putchar(char c){

    if(c == '\n'){
        if(tty.pos_x){
            tty.pos_x = 0;
            tty.pos_y++;
        }
    } else if (c == '\t'){
        if(!(tty.pos_x & 0x7)){tty.pos_x++;}
        while(tty.pos_x & 0x7){
            tty.pos_x++;
        }
    }
    else {
        if(tty.pos_x >= 80){
            tty.pos_x = 0;
            tty.pos_y++;
        }
        if(tty.pos_y >= 25){
            tty_scroll();
            tty.pos_y = 24;
            tty.pos_x = 0;
        }
        outp(5, (tty.pos_y * 80) + tty.pos_x);
        outp(6, c);

        tty.pos_x++;
    }
    return 0;
}

/* open a tty - only allow openning a single tty */
int _tty_open(int minor){
    if(minor)
        return 1;

    tty.pos_x = 0;
    tty.pos_y = 0;
    return 0;
}

/* close the tty */
int _tty_close(int minor){
    return 0;
}

/* write - just call tty_putchar */
//gen_write_from_putc(_tty_write, tty_putchar)

char *msg = "hello, world!";

int _tty_write (int minor, uint8_t *buf, size_t bytes, uint16_t *eof){
    int result;
    size_t written = 0;
    while(written != bytes && (result = tty_putchar(*buf)) != -1){
        buf++; written++;
    }
    *eof = result != -1;
    return written;
}

int main(){
    uint16_t eof = 8;
    _tty_write(0, msg, 13, &eof);
    while(1){};
}
