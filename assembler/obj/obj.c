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
4   | Size of segment 0 in file
4   | Offset of segment 1 in file
4   | Size of segment 1 in file
4   | Offset of segment 2 in file
4   | Size of segment 2 in file
4   | Offset of segment 3 in file
4   | Size of segment 3 in file
4   | Offset of defined symbol table
4   | Size of defined symbol table
4   | Offset of external symbol table
4   | Size of external symbol table

NOTE: all offsets are from the start of the file, including the 32 byte header


*** Table Formats ***
Both tables use the same format (in external table, additional entries beyond the name are blank)
Size            |Description
_OBJ_SYMBOL_SIZE|The symbol's name, including null
1               |Which segment the symbol is in (defined symbol table only)
2               |The symbol's offset in its segment (defined symbol table only)
*/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

/* Magic Number (a uint32_t - Really SOF followed by null in ascii (stored little endian)) */
#define _OBJ_MAGIC_NUMBER (uint32_t)('S' + ('O' << 8) + ('F' << 16))

/* Size, including nulls, of symbol names (defined and external) - all symbol names will take up this much space
* Note: if we change this, all object files will have to be regenerated */
#define _OBJ_SYMBOL_SIZE 64
/* Symbol table entries */
struct obj_symbol_entry {
  char name[_OBJ_SYMBOL_SIZE];
  uint8_t seg;
  uint16_t offset;
};

/* Header size in bytes (this is fixed unless we change header format) */
#define _OBJ_HEADER_SIZE 56

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
    _obj_write_val(obj->file, obj->segs.segs[i].size, 4);
  }
  /* write out symbol definitions */
  _obj_write_val(obj->file, obj->segs.defined_table.offset, 4);
  _obj_write_val(obj->file, obj->segs.defined_table.size, 4);
  _obj_write_val(obj->file, obj->segs.extern_table.offset, 4);
  _obj_write_val(obj->file, obj->segs.extern_table.size, 4);
  /* make sure we wrote the right size header */
  if(ftell(obj->file) != _OBJ_HEADER_SIZE){
    _obj_error("Internal Error: expected header size doesn't match written header's size");
  }
}

/**
 * init an obj_segs object by reading in the header of the obj_file */
void obj_read_header(struct obj_file *obj){
  /* seek to header start */
  fseek(obj->file, 0, SEEK_SET);
  /* read magic number, and make sure it is right */
  if(_obj_read_val(obj->file, 4) != _OBJ_MAGIC_NUMBER){
    _obj_error("Expected Magic Number to start file");
  }
  /* read blank */
  _obj_read_val(obj->file, 4);
  /* read in segs */
  uint32_t offset = 0;
  uint32_t tmp;
  for(int i = 0; i < 4; i++){
    /* TODO: check that the offsets and sizes are valid when we init the obj_segs struct */
    tmp = _obj_read_val(obj->file, 4);
    /* check that the segment is in the right place */
    if(offset != tmp){
      _obj_error("segment misaligned");
    }
    obj->segs.segs[i].offset = tmp;
    tmp = _obj_read_val(obj->file, 4);
    /* inc offset */
    offset += tmp;
    obj->segs.segs[i].size = tmp;
  }
  /* read in symbol definitions */
  tmp = _obj_read_val(obj->file, 4);
  if(offset != tmp){
      _obj_error("symbol segment misaligned");
  }
  obj->segs.defined_table.offset = tmp;
  tmp = _obj_read_val(obj->file, 4);
  offset += tmp;
  obj->segs.defined_table.size = tmp;


  tmp = _obj_read_val(obj->file, 4);
  if(offset != tmp){
      _obj_error("extern symbol segment misaligned");
  }
  obj->segs.extern_table.offset = tmp;
  tmp = _obj_read_val(obj->file, 4);
  offset += tmp;
  obj->segs.extern_table.size = tmp;
  /* make sure we read in the right size header */
  if(ftell(obj->file) != _OBJ_HEADER_SIZE){
    _obj_error("Internal Error: expected header size doesn't match read header's size");
  }
}

/**
 * create the header in an obj_segs object given the sizes of eahc segment and number of defined and extern symbols
 * symbols are the number of symbols, NOT the size of the tables
 * segments sizes are in bytes (including the meta-bytes) */
void obj_create_header(struct obj_file *obj, uint32_t seg0, uint32_t seg1, uint32_t seg2, uint32_t seg3, uint32_t defined_symbols, uint32_t extern_symbols){
  uint32_t offset = 0;

  for(int i = 0; i < 4; i++){
    obj->segs.segs[i].offset = offset;
    switch(i){
      case 0: obj->segs.segs[i].size = seg0; offset += seg0; break;
      case 1: obj->segs.segs[i].size = seg1; offset += seg1; break;
      case 2: obj->segs.segs[i].size = seg2; offset += seg2; break;
      case 3: obj->segs.segs[i].size = seg3; offset += seg3; break;
      default: break;
    }
  }
  obj->segs.defined_table.offset = offset;
  obj->segs.defined_table.size = defined_symbols * sizeof(struct obj_symbol_entry);
  offset += defined_symbols * sizeof(struct obj_symbol_entry);

  obj->segs.extern_table.offset = offset;
  obj->segs.extern_table.size = extern_symbols * sizeof(struct obj_symbol_entry);
  offset += extern_symbols * sizeof(struct obj_symbol_entry);
}

void write(){
  struct obj_file o;
  o.file = fopen("out.txt", "w");
  obj_create_header(&o, 10, 20, 30, 40, 5, 6);

  obj_write_header(&o);
}

void read(){
  struct obj_file o;
  o.file = fopen("out.txt", "r");
  obj_read_header(&o);
}

int main(int argc, char **argv){
  if(argc > 1){
    write();
  } else {
    read();
  }
}