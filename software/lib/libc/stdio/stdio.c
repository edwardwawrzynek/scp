#include <inout.h>

int pos = 0;

void putchar(char c){
	outp(_text_addr_port, pos++);
	outp(_text_data_port, c);
}

#define DIGARR "0123456789abcdef"

void print_number(unsigned int number, unsigned int radix){                                  
        unsigned int i;
        char *digitreps;
        if ((i = number / radix) != 0)
                print_number(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
}

void puts(char *s){
	while(*s){
		putchar(*s);
		s++;
	}
}
