#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>

struct _file * fdopen(uint16_t fd, uint8_t *mode){
    /* malloc file struct */
    struct _file * file = malloc(sizeof(struct _file));
    /* malloc buffer */
    uint8_t * buf = malloc(BUFSIZ);

    if(_file_des_open(file, fd, buf, _IOFBF, fmode_to_flags(mode))){
        free(file);
        free(buf);
        return NULL;
    }

    if(_add_open_file(file)){
        return NULL;
    }

    return file;
}