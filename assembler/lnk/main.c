#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"
#include "symbols.h"

/**
 * scplnk produces a directly loadable binary with or without -r - see segs.c */

void usage(){
  printf("Usage: scplnk [options] files\
        \nOptions:\
        \n-o\tout.o\t\t:set output binary\
        \n-r\t\t\t:don't write out a layout header\
        \n-p\t\t\t:don't arrange the segs on pages boundries\
        \n");
}

void run_lnk(void);

uint8_t do_head = 1;
uint8_t do_pages = 1;

int main(int argc, char *argv[]){
  char * outfile = "out.bin";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:rp")) != -1) {
    switch(opt){
      case 'o':
        outfile = optarg;
        break;
      case 'r':
        do_head = 0;
        break;
      case 'p':
        do_pages = 0;
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

  run_lnk();

}

void run_lnk(){
  read_in_headers();
  read_seg_size();
  create_segs(do_head, do_pages);

  symbol_read_in_tables();

  obj_set_seg(&in_objs[0], 0);
  uint16_t data;
  uint8_t is_byte, flags;
  if(obj_read_data(&in_objs[0], &data, &flags, &is_byte) == -1){
    printf("Overflow\n");
  }
  printf("Data: %u, Flags: %u, Is_word: %u\n", data, flags, is_byte);
  if(obj_read_data(&in_objs[0], &data, &flags, &is_byte) == -1){
    printf("Overflow\n");
  }
  printf("Data: %u, Flags: %u, Is_word: %u\n", data, flags, is_byte);
}