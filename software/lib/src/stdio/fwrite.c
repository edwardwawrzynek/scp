#include <stdio.h>
#include <syscall.h>

uint16_t fwrite(void *ptr, uint16_t size, uint16_t nmemb, struct _file *file){
    uint16_t bytes = size * nmemb;

    uint8_t *buf = (uint8_t *)ptr;

    for(uint16_t i = 0; i < bytes; i++){
        if(fputc(*(buf++), file) == EOF){
            return i/size;
        }
    }

    return nmemb;
}