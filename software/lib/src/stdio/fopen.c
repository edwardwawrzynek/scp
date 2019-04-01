#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>

struct _file * fopen(uint8_t * path, uint8_t *mode){
    /* malloc file struct */
    struct _file * file = malloc(sizeof(struct _file));
    /* malloc buffer */
    uint8_t * buf = malloc(BUFSIZ);

    if(_file_open(file, path,  mode, buf, _IOFBF)){
        free(file);
        free(buf);
        return NULL;
    }

    return file;
}

int16_t fclose(struct _file * file){
    if(file == NULL){
        return EOF;
    }
    /* flush file */
    if(file->buf_mode & __BUF_OUT){
        _file_buf_flush(file);
    }

    /* don't free buffers that were setbuf */
    if(file->buf != NULL && (!file->buf_was_setbuf)){
        free(file->buf);
    }
    if(close(file->fd) == -1){
        return EOF;
    }

    free(file);

    return 0;
}