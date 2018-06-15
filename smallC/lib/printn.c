#include <stdio.h>
/* print a number in any radish */
#define DIGARRU "0123456789ABCDEF"
#define DIGARRL "0123456789abcdef"
printn(number, radix)
int number, radix;{
  Xprintn(number, radix, 0, radix == 10);
}

Xprintn(int number, int radix, int upper_set, int do_signed){
	int i;
	char *digitreps;
  if (number < 0 & radix == 10){
      putchar('-');
      number = -number;
  }
  if ((i = number / radix) != 0){
  	printn(i, radix, upper_set, do_signed);
	}
	if(upper_set){
		digitreps=DIGARRU;
	}
	else{
		digitreps=DIGARRL;
	}
	putchar(digitreps[number % radix]);
}
