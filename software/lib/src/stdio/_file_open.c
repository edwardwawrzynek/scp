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

/* open a file from a path, buffer, and buffer mode (not including __BUF_IN or __BUF_OUT)
 * return 1 on failure, 0 on success */
int _file_open(struct _file * file, uint8_t * path,  uint8_t *mode, uint8_t *buf, uint8_t buf_mode){
    file->flags = fmode_to_flags(mode);
    file->fd = open(path, file->flags);
    if(file->fd == -1){
        return -1;
    }

    file->buf = buf;
    file->buf_mode = buf_mode;
    if(buf == NULL){
        file->buf_mode = _IONBF;
    }

    if(file->flags & O_RDONLY){
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