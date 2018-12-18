#include <inout.h>

static int pos_x = 0;
static int pos_y = 24;

#define pos_to_addr() ((pos_y * 80) + pos_x)

/* scroll the text on the screen */
void scroll(){
    /* move text up */
    for(int i = 0; i < 1920; i++){
        outp(5, i+80);
        int val = inp(6);
        outp(5, i);
        outp(6, val);
    }
    /* clear last line */
    for(int i = 1920; i < 2000; i++){
        outp(5, i);
        outp(6, '\0');
    }
}


void putchar(char c){

    if(c == '\n'){
        if(pos_x){
            pos_x = 0;
            pos_y++;
        }
    } else if (c == '\t'){
        if(!(pos_x & 0x7)){pos_x++;}
        while(pos_x & 0x7){
            pos_x++;
        }
    }
    else {
        if(pos_x >= 80){
            pos_x = 0;
            pos_y++;
        }
        if(pos_y >= 25){
            scroll();
            pos_y = 24;
            pos_x = 0;
        }
        outp(5, pos_to_addr());
        outp(6, c);

        pos_x++;
    }
}

void puts(char *str){
    while(*str){
        putchar(*(str++));
    }
}

unsigned int __crtudiv(unsigned int, unsigned int);

int main(){
    unsigned int a;

    a = 'f' * 3;

    putchar(a/3);
    putchar('a');

    while(1){};

}
