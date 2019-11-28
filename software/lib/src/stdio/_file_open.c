#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

/* maintain a list of currently open files so we can close them when we exit */

/* currently open files */
struct _file * _open_files[FOPEN_MAX];

/* add a file to currently open */
static int _add_open_file(struct _file * file){
    _file_assert_magic(file);

    for(int i = 0; i < FOPEN_MAX; i++){
        if(_open_files[i] == NULL){
            _open_files[i] = file;
            return 0;
        }
    }

    return 1;
}

/* remove an open file from list */
static int _remove_open_file(struct _file * file){
    _file_assert_magic(file);

    for(int i = 0; i < FOPEN_MAX; i++){
        if(_open_files[i] == file){
            _open_files[i] = NULL;
            return 0;
        }
    }

    return 1;
}

/* return the kernel flags for a given stdio file mode string */
int16_t _fmode_to_flags(uint8_t *mode){
	int16_t flags;
	if (strchr(mode, '+')) flags = O_RDWR;
	else if (*mode == 'r') flags = O_RDONLY;
	else flags = O_WRONLY;
	if (*mode != 'r') flags |= O_CREAT;
	if (*mode == 'w') flags |= O_TRUNC;
	if (*mode == 'a') flags |= O_APPEND;
	return flags;
}

/* allocate a file buffer */
struct _file_buf * _alloc_file_buf() {
    struct _file_buf * res = malloc(sizeof(struct _file_buf));
    assert(res != NULL);
    res->pos = 0;
    res->eof_pos = -2;
    memset(res->buf, 0, BUFSIZE);
    return res;
}

/* free a _file's _file_bufs */
void _free_file_buf(struct _file * file) {
    _file_assert_magic(file);
    if(file->in_buf != NULL){
        free(file->in_buf);
        file->in_buf = NULL;
    }
    if(file->out_buf != NULL){
        free(file->out_buf);
        file->out_buf = NULL;
    }
}

/* create a new file object */
static struct _file * _file_init(struct _file * res, uint16_t fd, uint16_t flags, enum _file_buf_mode mode) {
    assert(res != NULL);
    #ifdef _FILE_MAGIC
        res->_magic = _FILE_MAGIC;
    #endif
    res->fd = fd;
    res->flags = flags;
    res->buf_mode = mode;
    res->eof_flag = 0;

    res->rw_mode = NONE;
    /* read write mode */
    if(flags & O_RDWR == O_RDWR) {
        res->rw_mode = READWRITE;
    } else if(flags & O_RDONLY) {
        res->rw_mode = READONLY;
    } else if (flags & O_WRONLY) {
        res->rw_mode = WRITEONLY;
    }
    
    /* alloc buffers */
    res->in_buf = NULL;
    res->out_buf = NULL;
    if(res->rw_mode == READONLY && res->buf_mode != NOBUF) {
        res->in_buf = _alloc_file_buf();
        res->out_buf = NULL;
    } else if (res->rw_mode == WRITEONLY && res->buf_mode != NOBUF) {
        res->out_buf = _alloc_file_buf();
        res->in_buf = NULL;
    } else if(res->rw_mode == READWRITE && res->buf_mode != NOBUF){
        res->in_buf = _alloc_file_buf();
        res->out_buf = _alloc_file_buf();
    }

    _add_open_file(res);

    return res;
}

static struct _file * _file_alloc(uint16_t fd, uint16_t flags, enum _file_buf_mode mode) {
    struct _file * res = malloc(sizeof(struct _file));
    return _file_init(res, fd, flags, mode);
}

/* open a file object from file descriptor */
struct _file * fdopen(uint16_t fd, uint8_t *mode){
    return _file_alloc(fd, _fmode_to_flags(mode), _FILE_DEFAULT_BUF_MODE);
}

/* open from path and mode */
struct _file * fopen(uint8_t * path, uint8_t *mode) {
    uint16_t flags = _fmode_to_flags(mode);
    uint16_t fd = open(path, flags);
    if(fd == -1) {
        return NULL;
    } else {
        return _file_alloc(fd, flags, _FILE_DEFAULT_BUF_MODE);
    }
}

/* reopen file */
struct _file * freopen(char* path, char* mode, struct _file * file){
    if(file == NULL) return fopen(path, mode);

    if(fclose(file)) return NULL;

    uint16_t flags = _fmode_to_flags(mode);
    uint16_t fd = open(path, flags);
    if(fd == -1) {
        return NULL;
    } else {
        return _file_init(file, fd, flags, _FILE_DEFAULT_BUF_MODE);
    }
}

/* close file (0 on success) */
int16_t fclose(struct _file * file){
   _file_assert_magic(file);
    _remove_open_file(file);
   int fd = file->fd;
   fflush(file);
   _free_file_buf(file);
   free(file);

   return close(fd);
}