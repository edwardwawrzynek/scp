#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "include/tty.h"
#include "include/defs.h"

/**
 * Device driver interface  */

/** open a device with the given minor number, returning 0 on success and 1 on failure
  * driver has to handle alloc'ing any data structures it needs (drivers will probably just have a small static array and a limited number of devices, use malloc, or only support one device)
  * this is only called on an opening of a new minor number - if the device is opened by a process
  * while another process already has it open, _dev_open is not called */

/*  int _dev_open(int minor); */

/** close the device with the given minor number,
 * probably just free data structures
 * return 0 on success, 1 on failure (should always succed) */

/*  int _dev_close(int minor);  */

/** read from the device, returning the number of bytes read. If the returned value doesn't equal the requested number of bytes, set eof to explain why. If eof is true, end of file has been reached. If eof is false, then something is just blocking (waiting on keyboard, etc). Eof doesn't matter if number of bytes written equals number requested */

/*  int _dev_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof); */

/** write memory to the device, returning the number of bytes written. Set eof to if the end of file had been reached or not (not really useful for write, more for read. eof only matters if the retunr value doesn't match the number of bytes asked to be written) */

/*  int _dev_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof); */

/* Device table entry (Note: inodes's are passed to allow things like pipes to use the dev interface
 * real device files won't use them */
struct dev_entry {
    int (*_open)(int minor, struct inode *file);
    int (*_close)(int minor, struct inode*file);
    int (*_read)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file);
    int (*_write)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *file);
    int (*_ioctl)(int minor, int req_code, uint8_t * arg, struct inode *file);
};


/**
 * Supported tty ioctl flags:
 *
 * ECHO - echo typed characters
 * CANON - enable canonical/raw mode
 *
 * Raw Mode
 * characters are returned as soon as they are returned, and line editting
 * is not allowed. This is independent of ECHO
 * Canonical Mode
 * characters are buffered and line editting is allowed. They are returned
 * once newline is pressed. Independent of ECHO
 */

typedef struct {
    /* flags (ECHO and CANON) */
    struct termios termios;
    /* buffer */
    uint8_t buf[256];
    /* current writing index in buffer */
    uint8_t write_ind;
    /* current reading index in buffer
     * if this is less than write_ind and data_left_in buf,
     * it means that we have leftover data from last read to return */
    uint8_t read_ind;
    uint8_t data_left_in_buf;
    /* Last starting place in buf after reading into it - used so the line
     * disciple knows how far to delete */
    uint8_t last_write_end;

} tty_dev_t;

/** return codes for the gen_ dev methods
 * DEV_BLOCKING - stop and clear eof
 * DEV_EOF      - stop and set eof */

/** TTY's should use gen_write_from_putc for writing */
#include "dev_gen.h"

/* ---------------- TTY device read and write generation ---------------- */

/** macro to generate tty read method given a getc, which returns DEV_BLOCKING/DEV_EOF, otherwise it should return the read byte
 * Also needs a way to access the tty_dev_t entry for the instance
 * tty_dev_access should be the tty_dev_t field, which could use the minor argument
 * Creates a 256 byte buffer for input for use with the CANON mode
 * putc is needed for echo
*/

/* Basic Algorithm Description (CANON):
 * Return any left over that we marked
 * Read a byte. If blocking or eof, return that
 * Write that byte using _dev_tty_write_into_buf
 * Return what we got, and, if we have more than asked for, mark it to be returned on next call
 */



#define gen_tty_read_from_getc(read_func_name, getc, putc, tty_dev_access)              	        \
    int read_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *f){ \
        return _dev_tty_gen_read(minor, buf, bytes, eof, &(getc), &(putc), &(tty_dev_access)); 	    \
    }


#define gen_tty_write_from_putc(write_func_name, putc, tty_dev_access)              	        \
    int write_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *f){ \
        return _dev_tty_gen_write(minor, buf, bytes, eof, &(putc), &(tty_dev_access)); 	    \
    }

/** macro to generate ioctl for a tty device
 * handles TCGETA and TCSETA calls to set termios structure */

#define gen_tty_ioctl_from_tty_dev(ioctl_func_name, tty_dev_access)                     \
    int ioctl_func_name(int minor, int req_code, uint8_t *arg, struct inode *f){   \
        return _dev_tty_gen_ioctl(minor, req_code, arg, &(tty_dev_access));             \
    }

/* ---------------- Non-TTY device read and write generation ---------------- */

/** return codes for the gen_ dev methods
 * DEV_BLOCKING - stop and clear eof
 * DEV_EOF      - stop and set eof */

#define DEV_BLOCKING 256
#define DEV_EOF 257

/** macro to generate write method given a putc - putc should return 0 on success, or DEV_BLOCKING/DEV_EOF */
#define gen_write_from_putc(write_func_name, putc)                                                      \
    int write_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *f){    \
        return _dev_gen_write(minor, buf, bytes, eof, &putc);                                           \
    }

/** macro to generate read method given a getc, which returns DEV_BLOCKING/DEV_EOF, otherwise it should return the read byte */
#define gen_read_from_getc(read_func_name, getc)                                                    \
    int read_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *f){ \
        return _dev_gen_read(minor, buf, bytes, eof, &getc);                                        \
    }

/* Specific device indexes */
#define DEV_NUM_REG 0

#define DEV_NUM_SPECIAL 1
#define DEV_MINOR_NULL 0
#define DEV_MINOR_ZERO 1
#define DEV_MINOR_RANDOM 2
#define DEV_MINOR_SHUTDOWN 3

#define DEV_NUM_FIFO 2

#define DEV_NUM_TTY 3

#define DEV_NUM_SERIAL 4

#define DEV_NUM_PS 5