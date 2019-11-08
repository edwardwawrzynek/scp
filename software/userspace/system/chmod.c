#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/**
 * SCP chmod utility
 * non-standard conforming, supports (S_IEXEC) */

void print_usage() {
  fprintf(stderr, "usage: chmod mode [files]\n");
  exit(1);
}

int main(int argc, char **argv) {
  

  if(argc < 3){
    fprintf(stderr, "chmod: no mode and files specified\n");
    exit(1);
  }

  /* TODO: if os supports more than one flag, we need to check it before we set */
  uint16_t mode_val = 0;

  char * mode = argv[1];
  if(mode[0] == '+') {
    if(strchr(mode, 'x')) mode_val |= S_IEXEC;
  } else if(mode[0] == '-') {
    mode_val = (~0) & (~S_IEXEC);

  } else {
    mode_val = strtol(mode, NULL, 8);
  }

  for(int i = 2;i<argc;i++){
    int f = open(argv[i], O_RDWR);
    if(f == -1) {
      fprintf(stderr, "chmod: error opening file %s: ", argv[i]);
      perror(NULL);
      exit(1);
    }
    fchmod(f, mode_val);
    close(f);
  }

  return 0;
}