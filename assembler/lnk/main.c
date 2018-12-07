#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"


void usage(){
  printf("Usage: scplnk [options] files\
        \nOptions:\
        \n-o\tout.o\t\t:set output binary\n");
}


int main(int argc, char *argv[]){
  char * outfile = "out.bin";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:")) != -1) {
    switch(opt){
      case 'o':
        outfile = optarg;
        break;
      case '?':
        usage();
        exit(1);
      default:
        exit(1);
    }
  }
  /* open all source files */
  int i = 0;
  for(; optind < argc; optind++){
    /* init obj */
    obj_init(&in_objs[i]);
    in_objs[i].file = fopen(argv[optind], "r");
    if(!in_objs[i].file){
      printf("scplnk: error: no such file %s\n", argv[optind]);
      exit(1);
    }
    i++;
  }

  /* make sure we have at least one file */
  if(i == 0){
    usage();
    exit(1);
  }

  /* open output file */
  out_file = fopen(outfile, "w");

}
