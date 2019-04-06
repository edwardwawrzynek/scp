#include <stdio.h>
#include <syscall.h>

int16_t rename(char* oldname, char* newname){
    return link(oldname, newname);
}