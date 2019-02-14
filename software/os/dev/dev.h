#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "dev_gen.h"

/**
 * Device driver interface (probably will be used in os, now just for testing
 * dev is the device name - this is just an example of prototype, not real prototypes -
 * should that be made clear somehow? */

/** open a device with the given minor number, returning 0 on success and 1 on failure
  * driver has to handle alloc'ing any data structures it needs (drivers will probably just have a small static array and a limited number of devices, use malloc, or only support one device) */

/*  int _dev_open(int minor); */

/** close the device with the given minor number,
 * return 0 on success, 1 on failure (should always succed) */

/*  int _dev_close(int minor);  */

/** read from the device, returning the number of bytes read. If the returned value doesn't equal the requested number of bytes, set eof to explain why. If eof is true, end of file has been reached. If eof is false, then something is just blocking (waiting on keyboard, etc). Eof doesn't matter if number of bytes written equals number requested */

/*  int _dev_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof); */

/** write memory to the device, returning the number of bytes written. Set eof to if the end of file had been reached or not (not really useful for write, more for read. eof only matters if the retunr value doesn't match the number of bytes asked to be written) */

/*  int _dev_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof); */

/* Device table entry */
struct dev_entry {
    int (*_open)(int minor);
    int (*_close)(int minor);
    int (*_read)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
    int (*_write)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
    int (*_ioctl)(int minor, int req_code, int arg);
};
/* ---------------- Non-TTY device read and write generation ---------------- */

/** return codes for the gen_ dev methods
 * DEV_BLOCKING - stop and clear eof
 * DEV_EOF      - stop and set eof */

#define DEV_BLOCKING 256
#define DEV_EOF 257

/** macro to generate write method given a putc - putc should return 0 on success, or DEV_BLOCKING/DEV_EOF */
#define gen_write_from_putc(write_func_name, putc)                              \
    int write_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){  \
        return _dev_gen_write(minor, buf, bytes, eof, &putc);                          \
    }

/** macro to generate read method given a getc, which returns DEV_BLOCKING/DEV_EOF, otherwise it should return the read byte */
#define gen_read_from_getc(read_func_name, getc)                               \
    int read_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){  \
        return _dev_gen_read(minor, buf, bytes, eof, &getc);                          \
    }


/** TTY Functions **/

/* ---------------- Non-TTY device read and write generation ---------------- */

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
    uint16_t flags;
    /* buffer */
    uint8_t buf[256];
    /* current writing index in buffer */
    uint8_t write_ind;
    /* current reading index in buffer
     * if this is less than write_ind and data_left_in buf,
     * it means that we have leftover data from last read to return */
    uint8_t read_ind;
    uint8_t data_left_in_buf;

} termios_t;

#define TERMIOS_ECHO    0b00000001
#define TERMIOS_CANON   0b00000010

/** return codes for the gen_ dev methods
 * DEV_BLOCKING - stop and clear eof
 * DEV_EOF      - stop and set eof */

/** TTY's should use gen_write_from_putc for writing */


/** macro to generate tty read method given a getc, which returns DEV_BLOCKING/DEV_EOF, otherwise it should return the read byte
 * Also needs a way to access the termios_t entry for the instance
 * termios_access should be the termios_t field, which could use the minor argument
 * Creates a 256 byte buffer for input for use with the CANON mode
 * putc is needed for echo
*/

/* Basic Algorithm Description (CANON):
 * Return any left over that we marked
 * Read a byte. If blocking or eof, return that
 * Write that byte using _dev_tty_write_into_buf
 * Return what we got, and, if we have more than asked for, mark it to be returned on next call
 */



#define gen_tty_read_from_getc(read_func_name, getc, putc, termios_access)              \
    int read_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){           \
        _dev_tty_gen_read(minor, buf, bytes, eof, &(getc), &(putc), &(termios_access)); \
    }