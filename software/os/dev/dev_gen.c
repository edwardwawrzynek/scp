#include <lib/string.h>

#include "dev.h"
#include "syscall/exec.h"
#include "errno.h"
#include <lib/ctype.h>


/* Generic Reading and Writing Routines From getc and putc - wrappers in dev.h */
int _dev_gen_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, int (*putc)(char)){
    int result;
    size_t written = 0;
    while(written != bytes && (result = putc(*buf)) < DEV_BLOCKING){
        buf++;
        written++;
    }
    *eof = result == DEV_EOF;
    return written;
}

int _dev_gen_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, int (*getc)()){
    int result;
    size_t read = 0;
    while(read != bytes && (result = getc()) < DEV_BLOCKING){
        *buf = result;
        buf++;
        read++;
    }
    *eof = result == DEV_EOF;
    return read;
}

/** TTY reading and writing functions (handle c_iflag and c_oflag options) */

/* getc and putc wrappers */
int _tty_putc(tty_dev_t * tty_dev, int (*putc)(char),  char c) {
    if(!(tty_dev->termios.c_oflag & OPOST)) return putc(c);
    if(tty_dev->termios.c_oflag & ONLCR && c == '\n') {
        int res = putc(13);
        if(res >= DEV_BLOCKING) return res;
        return putc(10);
    } else {
        return putc(c);
    }
}

int _tty_getc(tty_dev_t * tty_dev, int (*getc)()) {
    int res = getc();
    /* DEV_BLOCKING and DEV_EOF won't be triggered by this, no check needed */
    if(tty_dev->termios.c_iflag & ICRNL && res == 13) return 10;

    return res;
}

/**
 * The tty line disciple
 * write a char into the given buffer, and handle backspace, tab, etc
 * if the char is a newline, return the number of bytes in the buffer
 * to flush. Return 0 otherwise
 * buf - buffer to write into
 * c - char to write
 * ind - current index (starting at 0, not buffer addr) in buffer
 * also handle echoing */
uint8_t _dev_tty_write_into_buf(uint8_t *buf, uint8_t c, uint8_t* ind, uint8_t echo, int (*putc)(char), uint8_t last_write_end, tty_dev_t * tty_dev){
    /* handle backspace */
    if(c == 0x7f){
        buf[*ind] = '\0';
        if(*ind > last_write_end){
            (*ind)--;
            if(echo) {
                _tty_putc(tty_dev, putc, 0x8);
                _tty_putc(tty_dev, putc, ' ');
                _tty_putc(tty_dev, putc, 0x8);
            }
        }
    }
    else {
        buf[(*ind)++] = c;
        if(echo && (isprint(c) || isspace(c)))
            _tty_putc(tty_dev, putc, c);
        else {
            _tty_putc(tty_dev, putc, '?');
        }
    }

    /* we want newlines in returned output */
    if(c == '\n'){
        return (*ind)-last_write_end;
    }

    return 0;
}

int _dev_tty_gen_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, int (*getc)(), int (*putc)(char), tty_dev_t * termios){
    int read = 0;

    /* Read remaining data in buffer */
    if(termios->read_ind < termios->write_ind && termios->data_left_in_buf){
        while(bytes && (termios->read_ind != termios->write_ind)){
            *(buf++) = termios->buf[termios->read_ind++];
            bytes--;
            read++;
        }
        /* if we didn't read all the bytes requested, it is just because we are blocking */
        *eof = 0;
        return read;
    }

    /* Only handle canonical mode */
    if(termios->termios.c_lflag & ICANON){
        int c = _tty_getc(termios, getc);
        /* Handle blocking or eof (eof shouldn't really happen with tty devs */
        if(c >= DEV_BLOCKING){
            *eof = (c == DEV_EOF);
            return 0;
        }

        /* Handle ctrl chars */
        if(termios->termios.c_lflag & ISIG){
            /* ctrl+d generates eof */
            if(c == 0x4){
                *eof = 1;
                return 0;
            }
            /* TODO: ctrl+c handling, ctrl + \, etc */
        }
        /* Write into termios buffer */
        termios->data_left_in_buf = 0;
        /* dev_tty_write_into_buf handles ECHO */
        int good_bytes = _dev_tty_write_into_buf(termios->buf, c, &(termios->write_ind), termios->termios.c_lflag & ECHO, putc, termios->last_write_end, termios);
        /* if we got a newline, return what we have (up to bytes req'd) */
        if(good_bytes){
            termios->last_write_end = termios->write_ind;
            int bytes_to_return = good_bytes;
            /* only return as many bytes as requested */
            if(bytes < bytes_to_return){
                bytes_to_return = bytes;
                termios->data_left_in_buf = 1;
                *eof = 0;
            }

            while(bytes_to_return){
                *(buf++) = termios->buf[termios->read_ind++];
                bytes_to_return--;
                read++;
            }
            return read;
        }

        /* return blocking */
        *eof = 0;
        return 0;

    } else {
        int result;
        size_t read = 0;
        while(read != bytes && (result = _tty_getc(termios, getc)) < DEV_BLOCKING){
            *buf = result;
            if(termios->termios.c_lflag & ECHO){
                _tty_putc(termios, putc, result);
            }
            buf++;
            read++;
        }
        *eof = result == DEV_EOF;
        return read;
    }
}

/* handle tty write */
int _dev_tty_gen_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, int (*putc)(char), tty_dev_t * termios) {
    int result;
    size_t written = 0;
    while(written != bytes && (result = _tty_putc(termios, putc, *buf)) < DEV_BLOCKING){
        buf++;
        written++;
    }
    *eof = result == DEV_EOF;
    return written;
}

/* handle tty ioctls */
int _dev_tty_gen_ioctl(int minor,int req_code,uint8_t *arg,tty_dev_t *tty_dev_access){
    switch(req_code){
        case TCGETA:
            /* read termio into arg */
            memcpy((struct termios *)arg, &(tty_dev_access->termios), sizeof(struct termios));
            break;
        case TCSETA:
            memcpy(&(tty_dev_access->termios), (struct termios *)arg, sizeof(struct termios));
            break;
        default:
            set_errno(ENOTTY);
            return -1;
    }
    return 0;
}

/* null methods for devs (open and close succced, read and write set eof, and ioctl returns -1) */
int no_open(int minor, struct inode *file){
    return 0;
}
int no_close(int minor, struct inode*file){
    return 0;
}
int no_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file){
    *eof = 1;
    return 0;
}
int no_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file){
    *eof = 1;
    return 0;
}
int no_ioctl(int minor, int req_code, uint8_t * arg, struct inode *file){
    set_errno(ENOTTY);
    return -1;
}