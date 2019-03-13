/**
 * Device driver for the vga text output and ps2 keyboard input
 * together, they make up the main teletype terminal
 * Edward Wawrzynek
 */

#include "dev.h"

#include <lib/inout.h>
#include <stdint.h>

/* tty device structure */
struct _tty_dev {
    /* x position */
    uint8_t pos_x;
    /* y position */
    uint8_t pos_y;
    /* if shift key was pressed */
    uint8_t tty_shifted;
    /* if the ctrl key was pressed */
    uint8_t ctrl;
    /* tty_dev support for CANON mode */
    tty_dev_t tty_dev;
};

/* only one tty is supported right now - other ttys will probably need different drivers */
static struct _tty_dev tty;

/* scroll the text on the screen */
static void tty_scroll(){
    int i, val;
    /* move text up */
    for(i = 0; i < 1920; i++){
        outp(5, i+80);
        val = inp(_text_data_port);
        outp(_text_addr_port, i);
        outp(_text_data_port, val);
    }
    /* clear last line */
    for(i = 1920; i < 2000; i++){
        outp(_text_addr_port, i);
        outp(_text_data_port, '\0');
    }
}

/* write out a char */
static int tty_putc(char c){

    if(tty.pos_x >= 80){
        tty.pos_x = 0;
        tty.pos_y++;
    }
    if(tty.pos_y >= 25){
        tty_scroll();
        tty.pos_y = 24;
        tty.pos_x = 0;
    }

    if(c == '\n'){
        tty.pos_x = 0;
        tty.pos_y++;

        if(tty.pos_y >= 25){
            tty_scroll();
            tty.pos_y = 24;
            tty.pos_x = 0;
        }
    } else if (c == '\t'){
        if(!(tty.pos_x & 0x7)){tty.pos_x++;}
        while(tty.pos_x & 0x7){
            tty.pos_x++;
        }
    } else if (c == 0x8){
        tty.pos_x--;
        outp(_text_addr_port, (tty.pos_y * 80) + tty.pos_x);
        outp(_text_data_port, '\0');
    }
    else {
        outp(_text_addr_port, (tty.pos_y * 80) + tty.pos_x);
        outp(_text_data_port, c);

        tty.pos_x++;
    }
    return 0;
}

/* read in a plain char from the txt input */
static int tty_getc_plain(){
    int inWaiting = inp(_key_in_waiting_port);
    if(inWaiting){
        uint16_t res = inp(_key_data_in_port);
        outp(_key_data_in_port, 1);
        /* return releases */
        return res;
    }

    /* not eof, just blocking */
    return DEV_BLOCKING;
}


/* the shifted charset, starting with space (ascii 32) */
static char * shifted_charset = " !\"#$%&\"()*+<_>?)!@#$%^&*(::<+>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}^_~ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~\\";

/* process raw keypresses into ascii chars - don't handle backspace */
/* TODO: handle arrow key escapes and things like that */
static int tty_getc(){
    int c;
    while(1){
        c = tty_getc_plain();
        /* handle blocking and eof */
        if(c == DEV_EOF){
            return DEV_EOF;
        } else if(c == DEV_BLOCKING){
            return DEV_BLOCKING;
        }
        /* handle shift and shift releases */
        if(c == 16){
            tty.tty_shifted = 1;
            continue;
        }
        else if (c == (0x100 + 16)){
            tty.tty_shifted = 0;
            continue;
        } else if (c == 17){
            tty.ctrl = 1;
            continue;
        } else if (c == (0x100 + 17)){
            tty.ctrl = 0;
            continue;
        }
        /* normal keys */
        else {
            /* don't return on key releases */
            if(c & 0x100){
                continue;
            }
            /* shift */
            if(tty.tty_shifted){
                return shifted_charset[c-32];
            /* ctrl */
            } else if (tty.ctrl){
                /* ctrl+a is 0x1, ctrl+c 0x3, ctrl+d 0x4, and so on */
                return c - 96;
            } else {
                return c;
            }
        }
    }
}

/* open a tty - only allow openning a single tty */
int _tty_open(int minor, struct inode *f){
    if(minor)
        return -1;

    tty.tty_dev.termios.flags |= (TERMIOS_CANON | TERMIOS_ECHO | TERMIOS_CTRL);
    return 0;
}

/* close the tty */
int _tty_close(int minor, struct inode *f){
    return 0;
}


/* generate read and write methods */
gen_write_from_putc(_tty_write, tty_putc)

//gen_read_from_getc(_tty_read, tty_getc)
gen_tty_read_from_getc(_tty_read, tty_getc, tty_putc, tty.tty_dev)

gen_tty_ioctl_from_tty_dev(_tty_ioctl, tty.tty_dev)