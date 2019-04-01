#include <stdio.h>
#include <syscall.h>

/* seek to a place in a file
 * whence is the same as lseek
 * just adjust for the data in the buffer, then call lseek
 * inefficient to dump all of buffer when we migh not have to, but it works */

int fseek(struct _file * file, uint16_t location, uint16_t whence){
    /* flush buffers */
    if(file->buf_mode & __BUF_OUT){
        _file_buf_flush(file);
    }
    /* adjust for any data we have read into the input buffer but not consumed
     * we always read a full BUFSIZE of input (unless eof), so just sub index from that */
    if(file->buf_mode & __BUF_IN){
        uint16_t backtrack = file->buf_index - (file->buf_eof != -1 ? file->buf_eof : BUFSIZ);
        if(lseek(file->fd, backtrack, SEEK_CUR) == -1){
            return -1;
        }
    }

    /* do actual seek */
    if(lseek(file->fd, location, whence) == -1){
        return -1;
    }

    /* set to be in output mode, as fputc has to work after seek */
    file->buf_mode |= __BUF_OUT;
    file->buf_mode &= ~(__BUF_IN);

    file->has_in_data = 0;

    file->buf_index = 0;

    return 0;
}