#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"
#include "symbols.h"
#include "decode.h"

/**
 * scplnk produces a directly loadable binary with or without -r - see segs.c */

void usage(){
  printf("Usage: scplnk [options] files\
        \nOptions:\
        \n-o\tout.o\t\t:set output binary\
        \n-r\t\t\t:don't write out a layout header\
        \n-p\t\t\t:don't arrange the segs on pages boundries\
        \n-l\tname\t\t:link with a file libname.o in the dirs specified by -L\
        \n-L\tdir\t\t:set dir to be part of the search path used by -l\
        \n");
}

void run_lnk(void);

uint8_t do_head = 1;
uint8_t do_pages = 1;

/* -L specified dirs */
char *lib_search_dirs[NUM_DIRS];
int lib_search_dirs_index = 0;

/* -l specified libraries */
char *lib_path[NUM_LIBS];
int lib_path_index = 0;

/* buffer for finding libraries */
char lib_buf[256];

int main(int argc, char *argv[]){
  char * outfile = "out.bin";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:rpl:L:")) != -1) {
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
      case 'L':
        lib_search_dirs[lib_search_dirs_index] = optarg;
        lib_search_dirs_index++;
        break;
      case 'l':
        lib_path[lib_path_index] = optarg;
        lib_path_index++;
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

  FILE *f;
  /* open all libraries specified with -l */
  for(int l = 0; l < lib_path_index; l++){
    /* go through each -L path */
    for(int d=0; d < lib_search_dirs_index; d++){
      sprintf(lib_buf, "%slib%s.o", lib_search_dirs[d], lib_path[l]);
      /* try to open it */
      f = fopen(lib_buf, "r");
      if(f != NULL){
        obj_init(&in_objs[i]);
        in_objs[i].file = f;
        i++;
        break;
      }
    }
    if(f == NULL){
      printf("scplnk: error: no such library found: %s\n", lib_path[l]);
      exit(1);
    }
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
  //read_seg_size();
  create_segs(do_head, do_pages);

  symbol_read_in_tables();

  main_pass();
}