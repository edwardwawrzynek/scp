#include <stdio.h>

int test_int(__reg("ra") int a, __reg("rb") int b, __reg("rc") int c, __reg("rd") int d){
	__asm("\tld.r.i re 0\n");
	__asm("\tint.i.n r7\n");
}

int main(){
	puts("Starting");
	for(int i = 1; i; i++){
		for(int j=0; j < 100; j++){}
	}
	puts("Doing Int\n");
	print_number(test_int(1,2,3,4), 10);
	puts("Done");
	while(1);
}
