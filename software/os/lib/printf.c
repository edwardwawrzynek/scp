#include <stdio.h>

//puts, but without newline
_print(char *str){
	while (*str) putchar(*str++);
}

//print at a specific location
_print_at(char *str,int pos){
	while(*(str)){
		outp(5, pos++);
		outp(6, *(str++));
	}						
}

printf(char *string /* variable amount */){
	unsigned int *arg;
	//set to first arg
	arg = &string + 2;
	//go through string
	while(*string){
		if(*string == '%'){
			string++;
			switch(*string){
				case 'c':
					putchar(*arg);
					break;
				case 'i':
				case 'd':
					_sprintn(*arg,10);
					break;
				case 'u':
					_uprintn(*arg,10);
					break;
				case 'x':
					_uprintn(*arg,16);
					break;
				case 's':
					_print(*arg);
					break;
				default:
					break;
			}
			++arg;
		} else{
			putchar(*string);
		}
		++string;
	}
}