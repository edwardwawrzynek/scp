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
#define _IONBF 1
/* line buffered mode */
#define _IOLBF 2
/* fully buffered mode */
#define _IOFBF 4

#define __BUF_IN 8
#define __BUF_OUT 16

typedef struct _file {
    /* os file descriptor (-1 when not open) */
    uint16_t fd;
    /* file mode (using kernel open modes (O_RDONLY), etc */
    uint8_t flags;
    /* buffering mode (_IONBF, _IOLBF, _IOFBF) or'd with __BUF_IN or __BUF_OUT */
    uint8_t buf_mode;
    /* index in buffer */
    uint16_t buf_index;
    /* index of eof in buffer, or -1 if eof not in buffer */
    uint16_t buf_eof;
    /* buffer (malloc'd by default, or set by setbuf) */
    uint8_t * buf;
} FILE;

int _file_buf_read(struct _file *file);
int _file_buf_flush(struct _file *file);

int16_t fgetc(struct _file *file);
int16_t fputc(int16_t c, struct _file *file);

int _file_open(struct _file *file,uint8_t *path,uint8_t *mode,uint8_t *buf,uint8_t buf_mode);
int16_t fmode_to_flags(uint8_t *mode);

struct _file * fopen(uint8_t * path, uint8_t *mode);
int16_t fclose(struct _file * file);

#endif