/* A very simple stdio interface layer for the kernal, providing putchar and getchar (along with puts, etc) for use in ther kernel. Simply uses the device table and allows the device to be set */

#include "dev/dev.h"
#include "dev/devices.h"

#include "kernel/panic.h"
#include "include/panic.h"

#include <stdarg.h>
#include "include/lib/inout.h"

#define EOF -1

/* the current output device */
static uint8_t cur_out_dev = DEV_NUM_TTY;
static uint8_t kstdio_up_f = 0;

/* Init kstdio layer */
void kstdio_layer_init(int dev_index){
    cur_out_dev = dev_index;
    kstdio_up_f = 1;
    if(devices[dev_index]._open(0, NULL)){
        panic(PANIC_KSTDIO_LAYER_INIT_FAILED);
    }
}

/* return true if kstdio layer is up */
int kstdio_up() {
    return kstdio_up_f;
}

/* set the output device */
void kstdio_set_output_dev(int dev_index){
    if(devices[cur_out_dev]._close(0, NULL)){
        panic(PANIC_KSTDIO_LAYER_INIT_FAILED);
    }
    cur_out_dev = dev_index;
    if(devices[cur_out_dev]._open(0, NULL)){
        panic(PANIC_KSTDIO_LAYER_INIT_FAILED);
    }
}

int kstdio_ioctl(int req_code, uint16_t arg){
    return devices[cur_out_dev]._ioctl(0, req_code, (uint8_t *)arg, NULL);
}

/* putchar and getchar - just call function* in table */
int putchar(int c){
    uint8_t eof = 0;
    int written;
    do {
        written = devices[cur_out_dev]._write(0, (uint8_t *)(&c), 1, &eof, NULL);
    } while((written != 1) && (!eof));

    return eof ? EOF : c;
}

int getchar(void){
    uint8_t eof = 0;
    int c = 0;
    int written;
    do {
        written = devices[cur_out_dev]._read(0, (uint8_t*)&c, 1, &eof, NULL);
    } while((written != 1) && (!eof));

    return eof ? EOF : c;
}

static int print_string(char *str){
    while((*str)) {
        if(putchar(*(str++)) == EOF){
            return EOF;
        }
    }

    return 1;
}

int puts(char *str){
    if(print_string(str)){
        return EOF;
    }

    /* newline */
    return putchar('\n') == EOF ? EOF : 1;
}

char *gets(char *buf){
    char c;
    char *res = buf;
    while(1){
        c = getchar();
        if(c == EOF){
            return NULL;
        }
        if(c == '\n'){
            *(buf++) = '\0';
            return res;
        }
        *(buf++) = c;
    }
}

/* print a number in any radish */
#define DIGARR "0123456789abcdef"
void _sprintn(int number, int radix){
        int i;
        char *digitreps;
        if (number < 0){
                putchar('-');
                number = -number;
                }
        if ((i = number / radix) != 0)
                _sprintn(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
}

void _uprintn(unsigned int number, unsigned int radix){
        unsigned int i;
        char *digitreps;
        if ((i = number / radix) != 0)
                _uprintn(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
}


/* only support basic % specifiers, no zero padding, floats, etc */
void vprintf(char *format, va_list args){
    char c;
    while((c = *(format++)) != 0){
        if(c == '%'){
            c = *(format++);
            switch(c){
                case 'i':
                case 'd':
                    _sprintn(va_arg(args, int), 10);
                    break;
                case 'u':
                    _uprintn(va_arg(args, int), 10);
                    break;
                case 'x':
                    _uprintn(va_arg(args, int), 16);
                    break;
                case 'c':
                    putchar(va_arg(args, int));
                    break;
                case 's':
                    print_string(va_arg(args, char*));
                    break;
            }
        } else {
            putchar(c);
        }
    }
}

void printf(char *format, ...){
    va_list args;

    va_start(args, format);

    vprintf(format, args);

    va_end(args);
}