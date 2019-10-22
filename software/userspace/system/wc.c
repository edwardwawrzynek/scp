#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>

int b, /* bytes */
  w, /* words */
  l, /* lines */
  t, /*this line*/
  L; /* longest line */

void print_usage() {
  fprintf(stderr, "usage: wc [options] [file] \noptions:\n-c\tprint chars\n-l\tprint lines\n-w\tprint words\n-L\tprint longest line length\n-h\tprint helo\n");
  exit(1);
}

int main(int argc, char** argv){
  int i;
  uint8_t cflg = 0, lflg = 0, wflg = 0, Lflg = 0, any_flag = 0;
  while((i = getopt(argc, argv, "clwLh")) != -1) {
      switch(i) {
          case 'c': cflg = 1; any_flag = 1; break;
          case 'l': lflg = 1; any_flag = 1; break;
          case 'w': wflg = 1; any_flag = 1; break;
          case 'L': lflg = 1; any_flag = 1; break;
          case 'h':
          default:
              print_usage();
              break;
      }
  }

  FILE *f;
  if(optind >= argc){
        f = stdin;
    } else {
        f = fopen(argv[optind], "r");
        if(f == NULL){
            fprintf(stderr, "couldn't open file: %s\n", argv[optind]);
            exit(1);
        }
    }
  char c;
  for(;(c=fgetc(f))!=-1;++b){
    t++;
    if(c=='\n') l++, L = t>L ? t : L, t=0;
    else if(c==' '||c=='\t')w++;
  }
  L = t>L ? t : L;
  /* Output format is lines  words chars */
  if(!any_flag) {
    printf("%d %d %d\n",l,w,b);
  }
  if(lflg)
    printf("%d ", l);
  if(Lflg)
    printf("(%d) ", L);
  if(wflg)
    printf("%d ", w);
  if(cflg)
    printf("%d ", b);
  
  printf("\n");
}