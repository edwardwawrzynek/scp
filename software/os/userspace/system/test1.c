#include <stdio.h>
#include <string.h>

int main (char **argv, int argc) {
   printf("test1\n");
   for(int i =0; i < argc; i++){
      printf("arg %u: %s\n", i, argv[i]);
   }

   return(0);
}