#include "asm.h"
#include <stdlib.h>
#include <stdio.h>
#include "object.h"

/* currently read in line */
char line[LINE_SIZE];
int lptr;

/* input files */
FILE * in_files[MAX_FILES];
/* current input file */
int cur_in_file = 0;
/* output file */
struct obj_file out;

/* debug file */
FILE * debug_file;
uint8_t do_debug = 0;

/**
 * Raise an error */
void error(char * msg){
  printf("\nscpasm: error:\n%s\nAt:\n%s\n", msg, line);

  exit(1);
}

/**
 * read a byte from input, or return EOF if none are left */
int read_byte(){
  int c;

  while(1){
      /* make sure we haven't run out of files */
      if(!in_files[cur_in_file]){
        return EOF;
      }
    /* read */
    c = fgetc(in_files[cur_in_file]);
    if(feof(in_files[cur_in_file])){
      cur_in_file++;
    } else{
      break;
    }
  };

  return c;
}

/**
 * reset the position in the input files */
void reset_file(){
  int i = 0;
  while(in_files[i]){
    printf("resetting file\n");
    fseek(in_files[i], 0, SEEK_SET);
    i++;
  }
  cur_in_file = 0;
}
