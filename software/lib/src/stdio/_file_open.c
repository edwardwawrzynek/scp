#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

/* return the kernel flags for a given stdio file mode string */
int16_t fmode_to_flags(uint8_t *mode){
	int16_t flags;
	if (strchr(mode, '+')) flags = O_RDWR;
	else if (*mode == 'r') flags = O_RDONLY;
	else flags = O_WRONLY;
	if (*mode != 'r') flags |= O_CREAT;
	if (*mode == 'w') flags |= O_TRUNC;
	if (*mode == 'a') flags |= O_APPEND;
	return flags;
}

/* open a file from a file descriptor */
int _file_des_open(struct _file *file, uint16_t fd, uint8_t *buf, uint8_t buf_mode, uint16_t flags){
    file->fd = fd;
    file->buf = buf;
    file->flags = flags;
    file->buf_mode = buf_mode;
    if(buf == NULL){
        file->buf_mode = _IONBF;
    }

    if((file->flags & O_RDONLY) && !(file->flags & O_CREAT)){
        file->buf_mode |= __BUF_IN;
    } else if (file->flags & O_WRONLY){
        file->buf_mode |= __BUF_OUT;
    }

    file->buf_index = 0;
    file->buf_eof = -1;

    file->has_in_data = 0;
    file->buf_was_setbuf = 0;

    return 0;
}

/* open a file from a path, buffer, and buffer mode (not including __BUF_IN or __BUF_OUT)
 * return 1 on failure, 0 on success */
int _file_open(struct _file * file, uint8_t * path,  uint8_t *mode, uint8_t *buf, uint8_t buf_mode){
    uint16_t flags = fmode_to_flags(mode);
    uint16_t fd = open(path, flags);
    if(fd == -1){
        return -1;
    }

    return _file_des_open(file, fd, buf, buf_mode, flags);
}