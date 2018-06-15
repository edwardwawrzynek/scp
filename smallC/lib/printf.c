#include <stdio.h>

//Printf implements specifiers c, i (and d), s, u, and x

printf(char *string/*more passed*/){
	unsigned int *arg_start;
	//Load pointer to top of passed extra arguments into arg_start
	//arg_start is *(sp+0), arguments passed end at *(sp+4) 
#asm
	mspa	#0
	psha	
	mspa	#6
	popb	
	swqa	
#endasm
	Xprintf(arg_start, string);
}

//real printf, passed pointer to additional arguments on stack
//args points to the last argument passed, with the second to last being +2 after that, and so on
Xprintf(unsigned int *args, char *string){
	puts(string);
	printn(args[0], 10);
	printn(args[1], 10);
	printn(args[2], 10);
}
