#include <stdio.h>
/* print a number in any radish */
#define DIGARR "0123456789abcdef"
_sprintn(int number, int radix){
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

_uprintn(unsigned int number, unsigned int radix){
        unsigned int i;
        char *digitreps;
        if ((i = number / radix) != 0)
                _uprintn(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
}
