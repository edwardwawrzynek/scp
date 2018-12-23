#include <stdint.h>
#include <stddef.h>

/**
 * Device driver interface (probably will be used in os, now just for testing
 * dev is the device name - this is just an example of prototype, not real prototypes -
 * should that be made clear somehow? */

/** open a device with the given minor number, returning 0 on success and 1 on failure
  * driver has to handle alloc'ing any data structures it needs (drivers will probably just have a small static array and a limited number of devices, use malloc, or only support one device) */

int _dev_open(int minor);

/** close the device with the given minor number,
 * return 0 on success, 1 on failure (should always succed) */

int _dev_close(int minor);

/** read from the device, returning the number of bytes read. If the returned value doesn't equal the requested number of bytes, set eof to explain why. If eof is true, end of file has been reached. If eof is false, then something is just blocking (waiting on keyboard, etc). */

int _dev_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);

/** write memory to the device, returning the number of bytes written. Set eof to if the end of file had been reached or not (not really useful for write, more for read. eof only matters if the retunr value doesn't match the number of bytes asked to be written) */

int _dev_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);

/** macro to generate write method given a putc - putc should return -1 if the function should stop and set eof */
#define gen_write_from_putc(write_func_name, putc)                              \
    int write_func_name (int minor, uint8_t *buf, size_t bytes, uint8_t *eof){  \
        int result;                                                             \
        size_t written = 0;                                                     \
        while(written != bytes && (result = putc(*buf)) != -1){                 \
            buf++;                                                              \
            written++;                                                          \
        }                                                                       \
        *eof = result == -1;                                                    \
        return written;                                                         \
    }

/** TODO: allow drivers to just implement putc and getc and have read and write wrappers on top of that. Also ioctl */