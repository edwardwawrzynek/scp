#include <stdio.h>
#include <syscall.h>

int16_t remove(char* filename){
    return unlink(filename);
}