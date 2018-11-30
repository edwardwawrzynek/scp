/* Common code for dealing with scp's object code format */

/* General Notes:
4 segments (only 2 used for now - read only (text+rodata), and data (data+bss))
Two symbol tables per file:
- Table of symbols defined in file
- Table of symbols with external linkage */

/*
Obj Format:
The file follows this layout:
1. Header
2. Segment 0
3. Segment 1
4. Segment 2
5. Segment 3
6. Segment 4
7. Defined Symbol Table
8. External Symbol Table

The segments and tables have to be arranged in this order, as we check if we have reached the end of a section based on the start of the next. The header could potentially specify an inccorect layout

*** Header format: ***
size| Description
4   | Magic Number-SOF (SCP Object File) followed by null
4   | Unused
4   | Offset of segment 0 in file
4   | Offset of segment 1 in file
4   | Offset of segment 2 in file
4   | Offset of segment 3 in file
4   | Offset of defined symbol table
4   | Offset of external symbol table

NOTE: all offsets are from the start of the file, including the 32 byte header

*/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

/* Magic Number (a uint32_t - Really SOF followed by null in ascii (stored little endian)) */
#define _OBJ_MAGIC_NUMBER (uint32_t)('S' + ('O' << 8) + ('F' << 16))

/* Size, including nulls, of symbol names (defined and external) - all symbol names will take up this much space
* Note: if we change this, all object files will have to be regenerated */
#define _OBJ_SYMBOL_SIZE 64

/* Header size in bytes (this is fixed unless we change header format) */
#define _OBJ_HEADER_SIZE 32

/* describes a segment of the file */
struct obj_seg {
  uint32_t offset;
  uint32_t size;
};

/* describes the segments of the obj file */
struct obj_segs {
  /* four code and data segments */
  struct obj_seg segs[4];
  /* symbol tables */
  struct obj_seg defined_table;
  struct obj_seg extern_table;
};

/* an object code file object - passed to obj_ methods */
struct obj_file {
  /* the file being written to */
  FILE *file;
  /* header information */
  struct obj_segs segs;
};

/**
 * error */
static void _obj_error(char *msg){
  printf("scp obj: error:\n%s\n", msg);
  exit(1);
}

/**
 * write a 1, 2, or 4-byte little endian int to file */
static void _obj_write_val(FILE *f, uint32_t val, uint8_t bytes){
  while(bytes--){
    fputc(val&0xff, f);
    val >>= 8;
  }
}

/**
 * read a 1, 2, or 4-byte little endian int to file */
static uint32_t _obj_read_val(FILE *f, uint8_t bytes){
  uint32_t res = 0;
  uint8_t shift = 0;
  while(bytes--){
    res += (fgetc(f) << shift);
    shift += 8;
    if(feof(f)){
      _obj_error("Unexpected EOF\n");
    }
  }
  return res;
}

/**
 * write an obj_file's segments to the file header
 * fseeks to position zero
 * asumes segs and file is init in obj_file */
void obj_write_header(struct obj_file *obj){
  /* seek to header start */
  fseek(obj->file, 0, SEEK_SET);
  /* write out magic number */
  _obj_write_val(obj->file, _OBJ_MAGIC_NUMBER, 4);
  /* write out blank */
  _obj_write_val(obj->file, 0, 4);
  /* write out segs */
  for(int i = 0; i < 4; i++){
    /* TODO: check that the offsets and sizes are valid when we init the obj_segs struct */
    _obj_write_val(obj->file, obj->segs.segs[i].offset, 4);
  }
  /* write out symbol definitions */
  _obj_write_val(obj->file, obj->segs.defined_table.offset, 4);
  _obj_write_val(obj->file, obj->segs.extern_table.offset, 4);
  /* make sure we wrote the right size header */
  if(ftell(obj->file) != _OBJ_HEADER_SIZE){
    _obj_error("Internal Error: expected header size doesn't match written headers size\n");
  }
}