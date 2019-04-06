#include <stdio.h>
#include <syscall.h>
#include <stdlib.h>

struct _file* freopen(char* path, char* mode, struct _file * file){
    if(file != NULL){
        if(!_remove_open_file(file)){
            /* flush file */
            if(file->buf_mode & __BUF_OUT){
                _file_buf_flush(file);
            }

            /* don't free buffers that were setbuf */
            if(file->buf != NULL && (!file->buf_was_setbuf)){
                free(file->buf);
            }
            close(file->fd);
        }
    }

    /* and open */
    /* malloc buffer */
    uint8_t * buf = malloc(BUFSIZ);

    if(_file_open(file, path,  mode, buf, _IOFBF)){
        free(file);
        free(buf);
        return NULL;
    }

    if(_add_open_file(file)){
        return NULL;
    }

    return file;
}