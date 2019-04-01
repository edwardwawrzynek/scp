#include <stdio.h>
#include <syscall.h>

/* return current pos in file */

uint16_t ftell(struct _file * file){
    /* get pos we have read to, and adjust for data in buffer */
    uint16_t pos = lseek(file->fd, 0, SEEK_CUR);

    if((file->buf_mode & __BUF_IN) && file->has_in_data){
        pos += file->buf_index - (file->buf_eof != -1 ? file->buf_eof : BUFSIZ);
    } else if (file->buf_mode & __BUF_OUT){
        pos += file->buf_index;
    }

    return pos;
}