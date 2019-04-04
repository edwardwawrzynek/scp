#include <stdio.h>

int fputs(uint8_t *str, struct _file * file){
    while(*str){
        if(fputc(*(str++),file) == EOF){
            return EOF;
        }
    }
    return 0;
}

int puts(uint8_t *str){
    if(fputs(str, stdout)){
        return EOF;
    }
    if(fputc('\n', stdout)){
        return EOF;
    }

    return 0;
}