#include <stdio.h>
#include <syscall.h>

/* write to a file */
int16_t fputc(int16_t c, struct _file * file){
    /* this needs to check if we are in input mode and return EOF */
    _file_assert_magic(file);

    uint8_t data = c;

    if(file->buf_mode == NOBUF) {
        if(write(file->fd, &data, 1) != 1){
            file->eof_flag = 1;
            return EOF;
        } else {
            return data;
        }
    } else {
        /* TODO */
    }
    
}

int16_t putchar(int16_t c){
    return fputc(c, stdout);
}