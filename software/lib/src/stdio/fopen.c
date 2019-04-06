#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>

struct _file * fopen(uint8_t * path, uint8_t *mode){
    /* malloc file struct */
    struct _file * file = malloc(sizeof(struct _file));
    /* malloc buffer */
    uint8_t * buf = malloc(BUFSIZ);

    if(_file_open(file, path,  mode, buf, _IOFBF)){
        free(file);
        free(buf);
        return NULL;
    }

    if(_add_open_file(file)){
        return NULL;
    }

    return file;
}