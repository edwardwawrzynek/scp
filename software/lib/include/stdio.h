#include <stdint.h>

#ifndef __STDIO_INCL
#define __STDIO_INCL 1

#define FILENAME_MAX 14
#define FOPEN_MAX 8
#define EOF -1

/* file structure */

/* buffer default size */
#define BUFSIZE 512

/* unbuffered mode */
#define _IONBF 0
/* line buffered mode */
#define _IOLBF 1
/* fully buffered mode */
#define _IOFBF 2

struct _file {
    /* os file descriptor (-1 when not open) */
    uint16_t fd;
    /* file mode (using kernel open modes (O_RDONLY), etc */
    uint8_t mode;
    /* buffering mode */
    uint8_t buf_mode;
    /* index in buffer */
    uint16_t buf_index;
    /* buffer (malloc'd by default, or set by setbuf) */
    uint8_t * buf;
};

typedef struct file FILE;

#endif
