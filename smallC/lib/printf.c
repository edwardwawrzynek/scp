#include <stdio.h>

//puts, but without newline
Xprint(char *str){
	while (*str) putchar(*str++);
}

//Printf implements specifiers c, i (and d), s, u, and x

printf(char *string/*more passed*/){
	//Due to a variable number of arguments and passing order, string isn't really the string - str is set to that latter
	unsigned int index;
	unsigned char c;
	//All other variables go ahead of these three
	unsigned int str;
	unsigned int arg_start;
	unsigned int num_args;
	//Load B into num_args(sp+0)
#asm
	mspa	#0
	swpb	
#endasm
	//Set str and arg_start as (sp+6+(num_args*2)) and (sp+4+(num_args*2))
	num_args = num_args * 2;
	//Set arg_start to sp
#asm
	mspa	#2
	xswp	
	mspa	#0
	swqa	
#endasm
	str = *(arg_start + 9 + num_args);
	arg_start = arg_start + 7 + num_args;
	//Start iterating through the string
	while(*str){
		c = *str++;
		if(!c){
			break;
		}
		if(c == '%'){
			//Get next char
			c = *str++;
			if(c == 'c'){
				putchar(*(arg_start-index));
			}
			else if(c == 'i' || c == 'd'){
				printn(*(arg_start-index),10);
			}
			else if(c == 'u'){
				uprintn(*(arg_start-index),10);
			}
			else if(c == 's'){
				Xprint(*(arg_start-index));
			}
			else if(c == 'x'){
				uprintn(*(arg_start-index),16);
			}
			index += 2;
		}
		else{
			putchar(c);
		}
	}
}
