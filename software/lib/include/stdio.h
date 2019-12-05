#include <stdint.h>
#include <stdarg.h>
#include <stddef.h>
#include <assert.h>

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
#define BUFSIZE 64

#ifndef NULL
#define NULL 0
#endif

/* magic number for file objects */
#define _FILE_MAGIC 0xf11e

#ifdef _FILE_MAGIC
    #define _file_assert_magic(file) assert(file->_magic == _FILE_MAGIC);
#endif
#ifndef _FILE_MAGIC
    #define _file_assert_magic(file)
#endif

struct _file_buf {
    /* buffer itself */
    uint8_t buf[BUFSIZE];
    /* read/write position in buffer */
    uint16_t pos;

    /* if input buffer, position of eof in buffer (-1 if no eof in buffer)
    if buffer hasn't been read in yet, eof_pos is -2 */
    uint16_t eof_pos;
};

enum _file_buf_mode {
    NOBUF, /* no buffering */
    LNBUF, /* line buffering */
    FULLBUF /* full buffering */
};

#define _FILE_DEFAULT_BUF_MODE FULLBUF

/* setvbuf args */
#define _IOFBF 1 /* full buffer */
#define _IOLBF 2 /* line buffered */
#define _IONBF 3 /* no buffered */

/* file reading + writing mode */
enum _file_rw_mode {
    READONLY,
    WRITEONLY,
    READWRITE,
};

/* current reading + writing mode */
enum _file_cur_rw_mode {
    NONE,
    READING,
    WRITING
};

typedef struct _file {
    #ifdef _FILE_MAGIC
        uint16_t _magic;
    #endif
    /* os file descriptor (-1 when not open) */
    uint16_t fd;
    /* file read/write mode (using kernel open modes (O_RDONLY), etc */
    uint8_t flags;
    /* buffering mode */
    enum _file_buf_mode buf_mode;
    /* buffers */
    struct _file_buf * in_buf;
    struct _file_buf * out_buf;
    /* read write mode */
    enum _file_rw_mode rw_mode;

    /* current read write mode */
    enum _file_cur_rw_mode cur_mode;

    /* eof flag */
    uint8_t eof_flag;
} FILE;

typedef uint16_t fpos_t;

int16_t fgetc(struct _file *file);
int16_t getchar();
int16_t fputc(int16_t c, struct _file *file);
int16_t putchar(int16_t c);


int16_t _fmode_to_flags(uint8_t *mode);
void _free_file_buf(struct _file * file);
void _file_read_buf_in(struct _file * file);

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

void perror(const char *s);

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
