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
4   | Magic Number-SCPO(SCP Object) in ascii
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
2               |The symbol's offset in its segment (defined symbol table only)
1               |Which segment the symbol is in (defined symbol table only)
*/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/* Magic Number (a uint32_t - Really SCPO in ascii (stored little endian)) */
#define _OBJ_MAGIC_NUMBER (uint32_t)('S' + ('C' << 8) + ('P' << 16) + ('O' << 24))

/* Size, including nulls, of symbol names (defined and external) - all symbol names will take up this much space
* Note: if we change this, all object files will have to be regenerated */
#define _OBJ_SYMBOL_SIZE 64

/* Symbol table entries */
struct obj_symbol_entry {
  char name[_OBJ_SYMBOL_SIZE];
  uint16_t offset;
  uint8_t seg;
};

/* size of the symbol table entry in the file */
#define _OBJ_SYMBOL_ENTRY_SIZE (_OBJ_SYMBOL_SIZE+3)

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
  /* current write pos in defined symbol table */
  uint32_t defined_write_pos;
  /* current write pos in extern symbol table */
  uint32_t extern_write_pos;
  /* current sgment being written (and/or read from?) */
  uint8_t cur_seg;
  /* current position (in byte offset) in each segment */
  uint32_t segs_pos[4];
};

/**
 * object info byte bits */

/* if the byte is part of a word instead of a single word (OBJ_IS_2ND_BYTE will be set on the 2nd byte of the word) */
#define OBJ_IS_WORD 0b1
/* if the byte is the 2nd byte */
#define OBJ_IS_2ND_BYTE 0b10
/* if the word (can only be a word) is a symbol (if OBJ_IS_EXTERN, it is in the external table, otherwise, it is an offset in OBJ_SEG_NUM) instead of constant */
#define OBJ_IS_SYMBOL 0b100
/* if the symbol is an entry in the extern symbol table */
#define OBJ_IS_EXTERN 0b1000
/* the segment number of the symbol (if IS_SYMBOL && !IS_EXTERN) */
#define OBJ_SEG_NUM 0b110000
/* if the entry (if IS_SYMBOL) is a pc-relative address (pc relative to the address of the symbol being written - b/c pc is inc'd to be immediate while instr is executing) */
#define OBJ_IS_PC_RELATIVE 0b1000000