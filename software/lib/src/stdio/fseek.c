#include <stdio.h>
#include <syscall.h>

/* seek to a place in a file
 * whence is the same as lseek
 * just adjust for the data in the buffer, then call lseek
 * inefficient to dump all of buffer when we migh not have to, but it works */

/* TODO */

int fseek(struct _file * file, uint16_t location, uint16_t whence){
    _file_assert_magic(file);

    if(file->buf_mode == NOBUF) {
        lseek(file->fd, location, whence);
    } else {
        /* TODO */
    }
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