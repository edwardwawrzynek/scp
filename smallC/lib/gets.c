#include <stdio.h>
#define EOL     10
#define BKSP    8

//gets, but end on any char
_gets(char * s, char end){
	char c,*ts;
  ts = s;
  while ((c = getchar()) != end && (c != EOF)) {
  	if (c == BKSP) {
    	if (ts > s) {
      	--ts;
        //scp putchar already earases
      }
  	}
    else{
			(*ts++) = c;
    }
	}
  if ((c == EOF) && (ts == s)) return NULL;
  (*ts) = NULL;
  return s;
}

gets(s) char *s; {
	return _gets(s, EOL);
}

