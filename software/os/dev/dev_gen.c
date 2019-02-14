#include <stdint.h>
#include <stddef.h>

#include "dev.h"

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

/**
 * The tty line disciple
 * write a char into the given buffer, and handle backspace, tab, etc
 * if the char is a newline, return the number of bytes in the buffer
 * to flush. Return 0 otherwise
 * buf - buffer to write into
 * c - char to write
 * ind - current index (starting at 0, not buffer addr) in buffer*/
uint8_t _dev_tty_write_into_buf(uint8_t *buf, uint8_t c, uint8_t* ind){
    /* basic handling for now - later handle backspace, tab, etc */
    buf[(*ind)++] = c;

    if(c == '\n'){
        return *ind;
    }

    return 0;
}

int _dev_tty_gen_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, int (*getc)(), int (*putc)(char), termios_t * termios){
    int read = 0;
    /* TODO: let driver set this */
    termios->flags |= TERMIOS_CANON;
    termios->flags |= TERMIOS_ECHO;

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
    if(termios->flags & TERMIOS_CANON){
        int c = getc();
        /* Handle blocking or eof (eof shouldn't really happen with tty devs */
        if(c >= DEV_BLOCKING){
            *eof = (c == DEV_EOF);
            return 0;
        }
        /* Write into termios buffer */
        termios->data_left_in_buf = 0;
        /* handle ECHO */
        if(termios->flags & TERMIOS_ECHO){
            putc(c);
        }
        int good_bytes = _dev_tty_write_into_buf(termios->buf, c, &(termios->write_ind));
        /* if we got a newline, return what we have (up to bytes req'd) */
        if(good_bytes){
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
        /* TODO */
    }
}