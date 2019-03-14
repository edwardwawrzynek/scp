#include <lib/string.h>

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
 * ind - current index (starting at 0, not buffer addr) in buffer
 * also handle echoing */
uint8_t _dev_tty_write_into_buf(uint8_t *buf, uint8_t c, uint8_t* ind, uint8_t echo, int (*putc)(char), uint8_t last_write_end){
    /* handle backspace */
    if(c == 0x8){
        buf[*ind] = '\0';
        if(*ind > last_write_end){
            (*ind)--;
            putc(0x8);
            putc(' ');
            putc(0x8);
        }
    }
    /* just convert tabs to eight spaces, disregarding current pos */
    else if (c == '\t'){
        for(int t = 0; t < 8; t++){
            buf[(*ind)++] = ' ';
            putc(' ');
        }
    }
    else {
        buf[(*ind)++] = c;
        putc(c);
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
    if(termios->termios.flags & TERMIOS_CANON){
        int c = getc();
        /* Handle blocking or eof (eof shouldn't really happen with tty devs */
        if(c >= DEV_BLOCKING){
            *eof = (c == DEV_EOF);
            return 0;
        }

        /* Handle ctrl chars */
        if(termios->termios.flags & TERMIOS_CTRL){
            /* ctrl+d generates eof */
            if(c == 0x4){
                *eof = 1;
                return 0;
            }
            /* TODO: ctrl+c handling */
        }
        /* Write into termios buffer */
        termios->data_left_in_buf = 0;
        /* dev_tty_write_into_buf handles ECHO */
        int good_bytes = _dev_tty_write_into_buf(termios->buf, c, &(termios->write_ind), termios->termios.flags & TERMIOS_ECHO, putc, termios->last_write_end);
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
        while(read != bytes && (result = getc()) < DEV_BLOCKING){
            *buf = result;
            if(termios->termios.flags & TERMIOS_ECHO){
                putc(result);
            }
            buf++;
            read++;
        }
        *eof = result == DEV_EOF;
        return read;
    }
}

/* handle tty ioctls */
int _dev_tty_gen_ioctl(int minor,int req_code,uint8_t *arg,tty_dev_t *tty_dev_access){
    switch(req_code){
        case TCGETA:
            /* read termio into arg */
            memcpy((struct termio*)arg, &(tty_dev_access->termios), sizeof(struct termios));
            break;
        case TCSETA:
            memcpy(&(tty_dev_access->termios), (struct termio*)arg, sizeof(struct termios));
            break;
        default:
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
    return -1;
}