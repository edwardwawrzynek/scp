#include <stdio.h>
#include <syscall.h>

/* read from a file */
int16_t fgetc(struct _file * file){
    /* needs to flush data if we are in output mode */
    _file_assert_magic(file);

    if(file->buf_mode == NOBUF) {
        uint8_t data = 0;
        if(read(file->fd, &data, 1) != 1){
            file->eof_flag = 1;
            return EOF;
        } else {
            return data;
        }
    } else {
        /* TODO */
    }
}

int16_t getchar(){
    return fgetc(stdin);
}