#include <stdio.h>
#include <syscall.h>

/* write to a file */
int16_t fputc(int16_t c, struct _file * file){
    /* if we are in file input mode, return EOF (it is undefined behavior, so technically standard compliant)
     * this has to work right after an fseek, so fseek sets mode to __BUF_OUT (fgetc can handle being in buf out) */
    if(file->buf_mode & __BUF_IN){
        return EOF;
    }
    uint8_t data = c;
    /* check if we need to flush buffer */
    if(file->buf_index >= BUFSIZ){
        if(_file_buf_flush(file)){
            return EOF;
        }
    }
    /* handle no buffering */
    if(file->buf_mode & _IONBF){
        if(write(file->fd, &data, 1) != 1){
            return EOF;
        }
    } else{
        if(file->buf == NULL){
            return EOF;
        }
        file->buf[file->buf_index++] = data;
        /* if line buffered, flush if we need to */
        if(data == '\n' && (file->buf_mode & _IOLBF)){
            if(_file_buf_flush(file)){
                return EOF;
            }
        }
    }
    return data;
}

int16_t putchar(int16_t c){
    return fputc(c, stdout);
}