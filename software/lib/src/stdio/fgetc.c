#include <stdio.h>
#include <syscall.h>

/* read from a file */
int16_t fgetc(struct _file * file){
    /* if we are in file output mode, flush */
    if(file->buf_mode & __BUF_OUT){
        if(_file_buf_flush(file)){
            return EOF;
        }
        file->buf_mode |= __BUF_IN;
        file->buf_mode &= ~(__BUF_OUT);
        if(_file_buf_read(file)){
            return EOF;
        }
    }

    /* no buffering and line buffered are not buffered */
    if((file->buf_mode & _IONBF) || (file->buf_mode & _IOLBF)){
        uint8_t data;
        if(read(file->fd, &data, 1) != 1){
            file->is_eof = 1;
            return EOF;
        }

        return data;
    } else {
        if(file->buf == NULL){
            return EOF;
        }
        /* if we are past end of buffer, read in */
        if(file->buf_index >= BUFSIZ || (!file->has_in_data)){
            if(_file_buf_read(file)){
                return EOF;
            }
        }
        /* check if we reached eof */
        if(file->buf_index >= file->buf_eof && file->buf_eof != -1){
            file->is_eof = 1;
            return EOF;
        }

        return file->buf[file->buf_index++];
    }
}

int16_t getchar(){
    return fgetc(stdin);
}