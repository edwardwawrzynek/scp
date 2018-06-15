#include <stdio.h>

//Printf implements specifiers c, i (and d), s, u, and x

printf(char *string/*more passed*/){
	//All other variables go ahead of these three
	char * str;
	unsigned int *arg_start;
	unsigned int num_args;
	//Load B into num_args(sp+0)
#asm
	mspa	#0
	swpb	
#endasm
	printn(num_args, 10);	
}
