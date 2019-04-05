#include <stdio.h>
#include <syscall.h>

uint16_t fread(void *ptr, uint16_t size, uint16_t nmemb, struct _file *file){
    uint16_t bytes = size * nmemb;

    uint8_t *buf = (uint8_t *)ptr;

    for(uint16_t i = 0; i < bytes; i++){
        uint16_t c = fgetc(file);
        if(c == EOF){
            return i/size;
        }
        *(buf++) = c;
    }

    return nmemb;
}