#include <stdio.h>
#include <syscall.h>

/* write to a file */
int16_t fputc(int16_t c, struct _file * file){
    /* this needs to check if we are in input mode and return EOF */
    _file_assert_magic(file);

    if(file->rw_mode != WRITEONLY && file->rw_mode != READWRITE) return EOF;

    uint8_t data = c;

    if(file->buf_mode == NOBUF) {
        if(write(file->fd, &data, 1) != 1){
            file->eof_flag = 1;
            return EOF;
        } else {
            return data;
        }
    } else {
        if(file->cur_mode == READING || file->cur_mode == NONE) {
            fseek(file, 0, SEEK_CUR);
        }

        file->cur_mode = WRITING;
        file->out_buf->buf[file->out_buf->pos++] = c;
        if((file->buf_mode == LNBUF && c == '\n') || file->out_buf->pos >= BUFSIZE) {
            if(fflush(file)) return EOF;
            return c;
        }
    }
    
}

int16_t putchar(int16_t c){
    return fputc(c, stdout);
}