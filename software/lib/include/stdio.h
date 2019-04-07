#include <stdint.h>
#include <stdarg.h>
#include <stddef.h>

#ifndef __STDIO_INCL
#define __STDIO_INCL 1

#define FILENAME_MAX 14
#define FOPEN_MAX 8
#define EOF -1


#ifndef SEEK_SET
#define SEEK_SET 1
#endif

#ifndef SEEK_CUR
#define SEEK_CUR 2
#endif

#ifndef SEEK_END
#define SEEK_END 3
#endif

/* buffer default size */
#define BUFSIZ 512

/* unbuffered mode */
#define _IONBF 1
/* line buffered mode */
#define _IOLBF 2
/* fully buffered mode */
#define _IOFBF 4

#define __BUF_IN 8
#define __BUF_OUT 16

#ifndef NULL
#define NULL 0
#endif

typedef struct _file {
    /* os file descriptor (-1 when not open) */
    uint16_t fd;
    /* file mode (using kernel open modes (O_RDONLY), etc */
    uint8_t flags;
    /* buffering mode (_IONBF, _IOLBF, _IOFBF) or'd with __BUF_IN or __BUF_OUT */
    uint8_t buf_mode;
    /* if input has been read into buffer */
    uint8_t has_in_data;
    /* index in buffer */
    uint16_t buf_index;
    /* index of eof in buffer, or -1 if eof not in buffer */
    uint16_t buf_eof;
    /* buffer (malloc'd by default, or set by setbuf) */
    uint8_t * buf;
    /* if the buffer was set by setbuf and shouldn't be freed on close */
    uint8_t buf_was_setbuf;
    /* eof indicator */
    uint8_t is_eof;
} FILE;

typedef uint16_t fpos_t;

int _file_buf_read(struct _file *file);
int _file_buf_flush(struct _file *file);

int16_t fgetc(struct _file *file);
int16_t getchar();
int16_t fputc(int16_t c, struct _file *file);
int16_t putchar(int16_t c);


int _file_open(struct _file *file,uint8_t *path,uint8_t *mode,uint8_t *buf,uint8_t buf_mode);
int _file_des_open(struct _file *file, uint16_t fd, uint8_t *buf, uint8_t buf_mode, uint16_t flags);
int16_t fmode_to_flags(uint8_t *mode);

int _add_open_file(struct _file * file);
int _remove_open_file(struct _file * file);

struct _file * fopen(uint8_t * path, uint8_t *mode);
struct _file * fdopen(uint16_t fd, uint8_t *mode);
struct _file* freopen(char* path, char* mode, struct _file * file);
int16_t fclose(struct _file * file);

int fseek(struct _file * file, uint16_t location, uint16_t whence);
uint16_t ftell(struct _file * file);
void rewind(struct _file * file);
uint16_t fgetpos(struct _file * file, fpos_t *pos);
uint16_t fsetpos(struct _file * file, fpos_t *pos);

void clearerr(struct _file *file);
uint16_t feof(struct _file *file);

uint16_t fileno(struct _file * file);
int fflush(struct _file * file);

int setvbuf(struct _file *file, uint8_t *buf, uint8_t mode, uint16_t size);
void setbuf(struct _file * file, uint8_t * buf);

int fputs(uint8_t *str, struct _file * file);
int puts(uint8_t *str);

uint8_t *fgets(uint8_t *buf, uint16_t size, struct _file * file);
uint8_t * gets(uint8_t * buf);

uint16_t fwrite(void *ptr, uint16_t size, uint16_t nmemb, struct _file *file);
uint16_t fread(void *ptr, uint16_t size, uint16_t nmemb, struct _file *file);

int16_t rename(char* oldname, char* newname);
int16_t remove(char* filename);

extern struct _file * stdin;
extern struct _file * stdout;
extern struct _file * stderr;

extern struct _file * _open_files[FOPEN_MAX];

/* printf and similar implementation is modified version (fprintf suport) of (https://github.com/mpaland/printf), MIT Licence */
int printf(const char* format, ...);
int fprintf(FILE *file, const char* format, ...);
int vfprintf(FILE *file, const char* format, va_list va);
int snprintf(char* buffer, size_t count, const char* format, ...);
int vsnprintf(char* buffer, size_t count, const char* format, va_list va);
int sprintf(char* buffer, const char* format, ...);
int vprintf(const char* format, va_list va);

/* modified version of mirror.fsf.org/pmon2000/2.x/src/lib/libc/scanf.c */
int sscanf(const char *buf,const char *fmt,...);
int fscanf(FILE *fp,const char *fmt,...);
int scanf(const char *fmt,...);
int vsscanf(const char *buf,const char *s,va_list ap);
int vfscanf(FILE *fp,const char *fmt,va_list ap);

#endif
