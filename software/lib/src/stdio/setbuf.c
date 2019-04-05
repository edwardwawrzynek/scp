#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>

/* set the buffer and buffering mode on a file */
int setvbuf(struct _file *file, uint8_t *buf, uint8_t mode, uint16_t size){
    /* if buffer is null, only change mode */
    file->buf_mode &= ~(0b111);
    file->buf_mode |= mode;
    if(buf == NULL){
        /* alloc buffer if needed */
        if(((mode & _IOLBF) || (mode & _IOFBF)) && file->buf == NULL ){
            file->buf = malloc(BUFSIZ);
        }
    } else {
        /* only allow bufs BUFSIZ or bigger */
        if(size < BUFSIZ){
            return EOF;
        }
        /* free buffer if already alloc'd */
        if(file->buf != NULL){
            free(file->buf);
        }
        file->buf = buf;
        file->buf_was_setbuf = 1;
    }

    return 0;
}

void setbuf(struct _file * file, uint8_t * buf){
    setvbuf(file, buf, buf ? _IOFBF : _IONBF, BUFSIZ);
}