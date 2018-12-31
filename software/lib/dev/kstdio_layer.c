/* A very simple stdio interface layer for the kernal, providing putchar and getchar (along with puts, etc) for use in ther kernel. Simply uses a device tables and allows the device to be set */

#include "dev.h"
#include "devices.h"

#define EOF -1

/* the current output device */
static uint8_t cur_out_dev = 0;

/* set the output device */
void kstdio_set_output_dev(int dev_index){
    cur_out_dev = dev_index;
}

/* putchar and getchar - just call function* in table */
int putchar(int c){
    uint8_t eof = 0;
    int written;
    do {
        written = devices[cur_out_dev]._write(0, (uint8_t *)(&c), 1, &eof);
    } while((written != 1) && (!eof));

    return eof ? EOF : c;
}

int getchar(void){
    uint8_t eof = 0;
    int c = 0;
    int written;
    do {
        written = devices[cur_out_dev]._read(0, &c, 1, &eof);
    } while((written != 1) && (!eof));

    return eof ? EOF : c;
}

int puts(char *str){
    while((*str)) {
        if(putchar(*(str++)) == EOF){
            return EOF;
        }
    }

    /* newline */
    return putchar('\n') == EOF ? EOF : 1;
}
