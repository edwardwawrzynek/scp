#include <stdio.h>
#include <syscall.h>

/* TODO */

/* return current pos in file */

uint16_t ftell(struct _file * file){
    /* get pos we have read to, and adjust for data in buffer */
    _file_assert_magic(file);

    if(file->buf_mode == NOBUF)
        return lseek(file->fd, 0, SEEK_CUR);
}