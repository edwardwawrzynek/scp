#include <stdio.h>
#include <syscall.h>

/* read from a file */
int16_t fgetc(struct _file * file){
    /* needs to flush data if we are in output mode */
    _file_assert_magic(file);

    if(file->rw_mode != READWRITE && file->rw_mode != READWRITE) return EOF;

    if(file->buf_mode == NOBUF) {
        uint8_t data = 0;
        if(read(file->fd, &data, 1) != 1){
            file->eof_flag = 1;
            return EOF;
        } else {
            return data;
        }
    } else {
        if(file->cur_mode != READING) {
            fflush(file);
        }
        file->cur_mode = READING;
        /* read in file if needed */
        if(file->in_buf->eof_pos == -2 || file->in_buf->pos >= BUFSIZE) {
            _file_read_buf_in(file);
        }
        /* check eof */
        if(file->in_buf->eof_pos != -1 && file->in_buf->pos >= file->in_buf->eof_pos) {
            file->eof_flag = 1;
            return EOF;
        }
        return file->in_buf->buf[file->in_buf->pos++];
    }
}

int16_t getchar(){
    return fgetc(stdin);
}