#include <stdio.h>
#include <syscall.h>

/* seek to a place in a file
 * whence is the same as lseek
 * just adjust for the data in the buffer, then call lseek
 * inefficient to dump all of buffer when we might not have to, but it works */

/* TODO */

int fseek(struct _file * file, uint16_t location, uint16_t whence){
    _file_assert_magic(file);

    /* flush contents */
    if(file->cur_mode == WRITING && file->out_buf != NULL) {
        /* fflush updates position fully */
        fflush(file);
    }
    if(file->cur_mode == READING && file->in_buf != NULL) {
        /* seek in file to where we actually are */
        if(file->in_buf->eof_pos != -2) {
            lseek(file->fd, file->in_buf->pos - (file->in_buf->eof_pos == -1 ? BUFSIZE: file->in_buf->eof_pos), SEEK_CUR);
        }
        /* invalidate input buffer */
        file->in_buf->eof_pos = -2;
        file->in_buf->pos = 0;
    }

    /* clear eof */
    file->eof_flag = 0;

    return lseek(file->fd, location, whence);
}

void rewind(struct _file * file){
    fseek(file, 0, SEEK_SET);
}

uint16_t fgetpos(struct _file * file, fpos_t *pos){
    *pos = ftell(file);
    return 0;
}

uint16_t fsetpos(struct _file * file, fpos_t *pos){
    return fseek(file, *pos, SEEK_SET);
}

void clearerr(struct _file *file){

}

uint16_t feof(struct _file *file){
    _file_assert_magic(file);
    return file->eof_flag;
}

/* return current pos in file */

uint16_t ftell(struct _file * file){
    /* get pos we have read to, and adjust for data in buffer */
    _file_assert_magic(file);

    return fseek(file, 0, SEEK_CUR);
}