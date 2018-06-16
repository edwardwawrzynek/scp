#include <stdio.h>
/* print a number in any radish */
#define DIGARR "0123456789abcdef"
_sprintn(number, radix)
int number, radix;{
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

_uprintn(number, radix)
unsigned int number, radix;{
        unsigned int i;
        char *digitreps;
        if ((i = number / radix) != 0)
                _uprintn(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
}
