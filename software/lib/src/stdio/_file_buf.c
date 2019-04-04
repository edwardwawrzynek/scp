#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

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
