#include <stdio.h>
#include <syscall.h>
#include <stdlib.h>

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

    if(_remove_open_file(file)){
        return EOF;
    }

    return 0;
}