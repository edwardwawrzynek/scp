#include <stdio.h>
/* print a number in any radish */
#define DIGARR "0123456789ABCDEF"
printn(number, radix)
int number, radix;{
        int i;
        char *digitreps;
        if (number < 0 & radix == 10){
                putchar('-');
                number = -number;
                }
        if ((i = number / radix) != 0)
                printn(i, radix);
        digitreps=DIGARR;
        putchar(digitreps[number % radix]);
        }
