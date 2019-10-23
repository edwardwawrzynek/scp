#include "asm.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "io.h"
#include "decode.h"

#include "object.h"
#include "obj.h"
#include "cmds.h"
#include "labels.h"

void usage(){
  printf("Usage: scpasm [options] files\
        \nOptions:\
        \n-o\tout.o\t:set output binary\
        \n-d\tdebug\t:output debugging info in debug\n");
}

void run_asm(void);

struct instr in;

int main(int argc, char *argv[]){
  char * outfile = "a.out";
  char * debugfile = NULL;
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:d:")) != -1) {
    switch(opt){
      case 'o':
        outfile = optarg;
        break;
      case 'd':
        debugfile = optarg;
        do_debug = 1;
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
	  printf("opening file: %s\n", argv[optind]);
    in_files[i++] = fopen(argv[optind], "r");
    if(!in_files[i-1]){
      printf("scpasm: error: no such file %s\n", argv[optind]);
      exit(1);
    }
  }
  /* init output object */
  obj_init(&out);
  /* open output file */
  printf("opening file: %s\n", outfile);
  out.file = fopen(outfile, "w");

  /* open debug file */
  if(do_debug){
	  printf("opening file: %s\n", debugfile);
    debug_file = fopen(debugfile, "w");
  }
  /* make sure we have at least one file */
  if(i == 0){
    usage();
    exit(1);
  }

  run_asm();

  fclose(out.file);
}

/* run all the things required for assembly */
void run_asm(){
  /* first pass */
  while(!read_good_line()){
    line_into_instr(&in);
    check_instr(&in);
    first_pass(&in);
  }
  first_pass_align();
  /* remove externs defined for labels that exist */
  remove_defined_externs();
  /* create the header */
  uint16_t external = 0;
  uint16_t defined = 0;
  labels_get_num(&defined, &external);
  obj_create_header(&out, seg_pos[0], seg_pos[1], seg_pos[2], seg_pos[3], defined, external);
  obj_write_header(&out);

  /* write out labels */
  labels_write_out(&out);

  /* reset for second pass */
  reset_segs_and_module();
  reset_file();
  /* second pass */
  while(!read_good_line()){
    line_into_instr(&in);
    check_instr(&in);
    second_pass(&in);
  }
}
