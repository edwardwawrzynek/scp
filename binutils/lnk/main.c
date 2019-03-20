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

/* don't link unneeded object files */
int do_dep_opt = 1;

int main(int argc, char *argv[]){
  char * outfile = "out.bin";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:rpl:L:OS")) != -1) {
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
      case 'D':
        do_sym_debug = 1;
        sym_debug_out = optarg;
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

  /* open all source files */
  int i = 0;
  for(; optind < argc; optind++){
    /* init obj */
    obj_init(&in_objs[i]);
    in_objs[i].file = fopen(argv[optind], "r");
    in_objs_do_lnk[i] = 1;
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
    int opened = 0;
    for(int d=0; d < lib_search_dirs_index; d++){
      /* try lib_.o variant */
      sprintf(lib_buf, "%slib%s.o", lib_search_dirs[d], lib_path[l]);
      /* try to open it */
      f = fopen(lib_buf, "r");
      if(f != NULL){
        opened = 1;
        obj_init(&in_objs[i]);
        in_objs[i].file = f;
        in_objs_do_lnk[i] = 1;
        i++;
        break;
      } else {
        /* try lib_ directory containing object files */
        sprintf(lib_buf, "%slib%s", lib_search_dirs[d], lib_path[l]);
        DIR * dir = opendir(lib_buf);
        if(dir != NULL){
          opened = 1;
          struct dirent * ent;
          /* add all files in dir */
          while((ent = readdir(dir)) != NULL){
            if(strcmp(ent->d_name, ".") && strcmp(ent->d_name, "..")){
              sprintf(lib_buf, "%slib%s/%s", lib_search_dirs[d], lib_path[l], ent->d_name);
              f = fopen(lib_buf, "r");
              if(f == NULL){
                printf("failed to open: %s\n", lib_buf);
                exit(1);
              }
              obj_init(&in_objs[i]);
              in_objs[i].file = f;
              in_objs_do_lnk[i] = 1;
              i++;
            }
          }
          break;
        }
      }
    }
    if(!opened){
      printf("scplnk: error: no such library found: %s\n", lib_path[l]);
      exit(1);
    }
  }

  /* make sure we have at least one file */
  if(i == 0){
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

/* run the linker */
void run_lnk(){
  if(do_out_obj){
    run_lnk_obj();
  }
  else {
    run_lnk_bin();
  }
}