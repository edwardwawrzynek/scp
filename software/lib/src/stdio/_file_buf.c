#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

/* TODO: replace with assert */
int stdio_fail(int code){
    test_syscall("stdio fail %u\n", code, 0, 0);
}

/* flush the buffer of an output file
 * return -1 if the file isn't currently in output buffer mode, or other error */
int _file_buf_flush(struct _file * file){
    if(file->buf_mode & __BUF_OUT){
        if(file->buf_mode & _IONBF){
            return 0;
        }
        if(file->buf_index == 0){
            return 0;
        }
        if(write(file->fd, file->buf, file->buf_index) == -1){
            return -1;
        }
    } else {
        return -1;
    }

    file->buf_index = 0;
    return 0;
}

/* read in a buffer from file */
int _file_buf_read(struct _file * file){
    if(file->buf_mode & __BUF_IN){
        if((file->buf_mode & _IONBF) || (file->buf_mode & _IOLBF)){
            return 0;
        }
        /* line buffered is treated as not buffered at all */
        /* if fully buffered, read buf size worth */
        else if(file->buf_mode & _IOFBF){
            uint16_t bytes = read(file->fd, file->buf, BUFSIZ);
            if(bytes == -1){
                return -1;
            }
            /* mark eof if buffer isn't full */
            if(bytes != BUFSIZ){
                file->buf_eof = bytes;
            } else {
                file->buf_eof = -1;
            }
        }

    } else {
        return -1;
    }

    file->buf_index = 0;
    file->has_in_data = 1;
    return 0;
}

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
            stdio_fail(0);
            return EOF;
        }
        file->buf[file->buf_index++] = data;
        /* if line buffered, flush if we need to */
        if(data == '\n'){
            if(_file_buf_flush(file)){
                return EOF;
            }
        }
    }

    return data;
}

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
            return EOF;
        }

        return file->buf[file->buf_index++];
    }
}