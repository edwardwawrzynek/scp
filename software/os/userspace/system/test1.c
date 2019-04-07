#include <stdio.h>
#include <string.h>

int main (int argc, char ** argv) {
   printf("test1\n");
   for(int i = 0; i < argc; i++){
      printf("%s ", argv[i]);
   }
   printf("\n");


   return(0);
}