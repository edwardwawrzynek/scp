#include "asm.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "io.h"
#include "decode.h"

void usage(){
  printf("Usage: scpasm [options] files\
        \nOptions:\
        \n-o\tout.o\t\t:set output binary\
        \n-d\tdebug.txt\t:output debugging info in debug.txt\n");
}

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
    in_files[i++] = fopen(argv[optind], "r");
    if(!in_files[i-1]){
      printf("scpasm: error: no such file %s\n", argv[optind]);
      exit(1);
    }
  }
  /* open output file */
  out_file = fopen(outfile, "w");
  /* open debug file */
  if(do_debug){
    debug_file = fopen(debugfile, "w");
  }
  /* make sure we have at least one file */
  if(i == 0){
    usage();
    exit(1);
  }

  /* run asm */
  while(!read_good_line()){
    line_into_instr(&in);
    check_instr(&in);
    printf("Name: %s, Opcode: %i, is_label: %u, is_dir: %u\n", in.name, in.opcode, in.is_label, in.is_dir);
    int a = 0;
    while(in.args[a].in_use){
      printf("\tArg: %s, Val: %u, Offset: %u, is_reg: %u reg: %u, is_alu: %u alu: %u, is_cond: %u cond: %u\n", in.args[a].str, in.args[a].val, in.args[a].offset, in.args[a].is_reg, in.args[a].reg,  in.args[a].is_alu, in.args[a].alu_op, in.args[a].is_cond, in.args[a].cond_code);
      a++;
    }
  }

  fclose(out_file);
}
