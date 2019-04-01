#include <stdio.h>

int fflush(struct _file * file){
    if(file->buf_mode & __BUF_OUT){
        _file_buf_flush(file);
    } else {
        return -1;
    }
}