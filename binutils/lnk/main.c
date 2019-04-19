#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <dirent.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"
#include "symbols.h"
#include "decode.h"
#include "ar.h"

/**
 * scplnk produces a directly loadable binary with or without -r - see segs.c */

void usage(){
  printf("Usage: scplnk [options] files\
        \nOptions:\
        \n-o\tout.o\t:set output binary\
        \n-r\t\t:don't write out a layout header\
        \n-p\t\t:don't arrange the segs on pages boundries\
        \n-l\tname\t:link with a file libname.o in the dirs specified by -L\
        \n-L\tdir\t:set dir to be part of the search path used by -l\
        \n-O\t\t:force the output to be an obj file, no matter output extension\
        \n-A\t\t:force the output to be an archive, no matter output extension\
        \n-D\tsym_db\t:output symbol debugging info in sym_db (binary file output only)\
        \n-S\t\t:don't do static dependency optomization\
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

int do_sym_debug = 0;
char * sym_debug_out;
FILE * sym_debug_file;

/* don't link unneeded object files */
int do_dep_opt = 1;

/* output an archive (combination of object files) */
int do_out_ar = 0;

int in_objs_index = 0;

/* add a obj to in_objs from arg */
uint8_t add_obj(char * name){
  FILE * file = fopen(name, "r");
  if(file == NULL){
    return 1;
  }
  obj_init(&in_objs[in_objs_index]);
  in_objs[in_objs_index].file = file;
  in_objs_do_lnk[in_objs_index] = 1;
  handle_ar_obj(&in_objs[in_objs_index], &in_objs_index);

  in_objs_index++;

  return 0;
}


int main(int argc, char *argv[]){
  char * outfile = "out.bin";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:rpl:L:OASD:")) != -1) {
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
      case 'O':
        do_out_obj = 1;
        break;
      case 'A':
        do_out_ar = 1;
        break;
      case 'D':
        do_sym_debug = 1;
        sym_debug_out = optarg;
        sym_debug_file = fopen(sym_debug_out, "w");
        if(sym_debug_file == NULL){
          error("error creating debugging file\n");
        }
        break;
      case 'S':
        do_dep_opt = 0;
        break;
      case '?':
        usage();
        exit(1);
      default:
        exit(1);
    }
  }
  /* decide if we need to output an object file based on output file suffix */
  char * outend = outfile + strlen(outfile);
  if(outend[-2] == '.' && outend[-1] == 'o'){
    do_out_obj = 1;
  }
  else if(outend[-2] == '.' && outend[-1] == 'a'){
    do_out_ar = 1;
  }

  /* open all source files */
  for(; optind < argc; optind++){
    /* init obj */
    if(add_obj(argv[optind])){
      printf("scplnk: error: no such file: %s\n", argv[optind]);
    }
  }

  /* open all libraries specified with -l */
  for(int l = 0; l < lib_path_index; l++){
    /* go through each -L path */
    for(int d=0; d < lib_search_dirs_index; d++){
      /* try lib_.o variant */
      if(
        sprintf(lib_buf, "%slib%s.o", lib_search_dirs[d], lib_path[l]),
        !add_obj(lib_buf)
      ){

      } else if (
        sprintf(lib_buf, "%slib%s.a", lib_search_dirs[d], lib_path[l]),
        !add_obj(lib_buf)
      ){

      } else {
        printf("scplnk: error: no such library found: %s\n", lib_path[l]);
      }
    }
  }

  /* make sure we have at least one file */
  if(in_objs_index == 0){
    usage();
    exit(1);
  }

  /* init out obj if we need it, otherwise bin file */
  if(do_out_obj){
    obj_init(&out_obj);
    out_obj.file = fopen(outfile, "w");
  } else {
    out_file = fopen(outfile, "w");
  }

  run_lnk();

}

/* output a binary file */
void run_lnk_bin(){
  read_in_headers();
  symbol_read_in_tables();

  if(do_dep_opt){
    in_objs_clear_do_lnk();
    add_symbol_deps("_START");
  }

  bin_create_segs(do_head, do_pages);

  bin_main_pass();
}

/* output an obj file - a bit simpler */
void run_lnk_obj(){
  /* don't do dep opt - we don't know what might be used from resulting object file */
  read_in_headers();

  obj_out_create_segs();

  symbol_read_in_tables();

  obj_out_main_pass();

  obj_out_write_symbols();
}

void run_sym_debug_out(){
  sym_out_write_symbols(sym_debug_file);
}

/* run the linker */
void run_lnk(){
  if(do_out_obj){
    run_lnk_obj();
  } else if(do_out_ar){
    run_lnk_ar();
  } else {
    run_lnk_bin();
    if(sym_debug_out){
      run_sym_debug_out();
    }
  }
}