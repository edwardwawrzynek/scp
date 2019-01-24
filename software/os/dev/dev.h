#include <stdint.h>
#include <stddef.h>

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

/** return codes for the gen_ dev methods
 * DEV_BLOCKING - stop and clear eof
 * DEV_EOF      - stop and set eof */

#define DEV_BLOCKING 256
#define DEV_EOF 257

/** macro to generate write method given a putc - putc should return 0 on success, or DEV_BLOCKING/DEV_EOF */
#define gen_write_from_putc(write_func_name, putc)                              \
    int write_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){  \
        int result;                                                             \
        size_t written = 0;                                                     \
        while(written != bytes && (result = putc(*buf)) < DEV_BLOCKING){        \
            buf++;                                                              \
            written++;                                                          \
        }                                                                       \
        *eof = result == DEV_EOF;                                               \
        return written;                                                         \
    }

/** macro to generate read method given a getc, which returns DEV_BLOCKING/DEV_EOF, otherwise it should return the read byte */
#define gen_read_from_getc(read_func_name, getc)                                \
    int read_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){   \
        int result;                                                             \
        size_t read = 0;                                                        \
        while(read != bytes && (result = getc()) < DEV_BLOCKING){               \
            *buf = result;                                                      \
            buf++;                                                              \
            read++;                                                             \
        }                                                                       \
        *eof = result == DEV_EOF;                                               \
        return read;                                                            \
    }

/* Device table entry */

struct dev_entry {
    int (*_open)(int minor);
    int (*_close)(int minor);
    int (*_read)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
    int (*_write)(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
};

