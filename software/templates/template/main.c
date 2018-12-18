#include <stdio.h>
main(){
    char c[256];
    while(1){
	    putchar('$');
	    gets(c);
	    printf("\nYou entered: %s\n", c);
    }
}
