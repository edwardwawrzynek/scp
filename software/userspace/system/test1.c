#include <stdio.h>
#include <string.h>
#include <syscall.h>
#include <stdint.h>

int main (int argc, char ** argv) {
   for(int i = 0; i < argc; i++){
      printf("%s ", argv[i]);
   }
   printf("\n");
   int c;
   while((c = getopt(argc, argv, "c:l")) != -1){
      switch(c){
         case 'c':
            printf("c flag passed, arg: %s\n", optarg);
            break;
         case 'l':
            printf("l flag passed\n");
            break;

         case '?':
            printf("flag error\n");
            break;
      }
   }
   for(;optind<argc;optind++){
      printf("arg: %s\n", argv[optind]);
   }

   return(0);
}