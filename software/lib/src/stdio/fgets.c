#include <stdio.h>
#include <syscall.h>

/* read to newline, at most size bytes into buffer */
uint8_t *fgets(uint8_t *buf, uint16_t size, struct _file * file){
    uint8_t *res = buf;
    while(size > 1){
        int16_t c = fgetc(file);
        if(c==EOF){
            break;
        }
        *(buf++) = c;
        if(c == '\n'){
            break;
        }
        size--;
    }
    *buf = '\0';
    if(res == buf) return NULL;

    return res;
}

uint8_t * gets(uint8_t * buf){
    uint8_t *res = buf;
    int16_t c;
    while(1) {
        c = getchar();
        if(c == EOF || c == '\n'){
            break;
        }
        *(buf++) = c;

    };
    *buf = '\0';

    return res;
}