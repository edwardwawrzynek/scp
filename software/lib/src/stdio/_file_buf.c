#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

/* if file is buffered, flush buffer out */
int fflush(struct _file * file){
  int ret_val = 0;
  /* write data out */
  if(file->out_buf != NULL) {
    if(write(file->fd, file->out_buf->buf, file->out_buf->pos) != file->out_buf->pos) ret_val = -1;
    file->out_buf->pos = 0;
  }

  return ret_val;
}

/* read in the buffer on an input file */
void _file_read_buf_in(struct _file * file) {
  assert(file->in_buf != NULL);
  /* line buffered should just be single buffered */
  assert(file->buf_mode != NOBUF && file->buf_mode != LNBUF);

  /* read data in */
  uint16_t read_in = read(file->fd, file->in_buf->buf, BUFSIZE);

  file->in_buf->pos = 0;
  if(read_in != BUFSIZE) {
    if(read_in == -1) read_in = 0;
    file->in_buf->eof_pos = read_in;
  } else {
    file->in_buf->eof_pos = -1;
  }
}

/* set the buffer and buffering mode on a file
 * don't actually use the specified buffer, but set buffering mode */
int setvbuf(struct _file *file, uint8_t *buf, uint8_t mode, uint16_t size){
  /* set no buffering */
  if(buf == NULL || size == 0 || mode == _IONBF) {
    file->buf_mode = NOBUF;
    _free_file_buf(file);
  } else {
    if(mode == _IOLBF) file->buf_mode = LNBUF;
    if(mode == _IOFBF) file->buf_mode = FULLBUF;
  }

  return 0;
}

void setbuf(struct _file * file, uint8_t * buf){
  if(buf == NULL) {
    setvbuf(file, buf, _IONBF, 0);
  } else {
    setvbuf(file, buf, _IOFBF, BUFSIZE);
  }
}