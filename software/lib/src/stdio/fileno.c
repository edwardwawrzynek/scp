#include <stdio.h>

uint16_t fileno(struct _file * file){
    return file->fd;
}