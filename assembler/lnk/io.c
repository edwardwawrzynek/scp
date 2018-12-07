#include <stdio.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"

/* Input object files */
struct obj_file in_objs[MAX_FILES];

/* Output binary */
FILE *out_file;

/* read in all the headers */
void read_in_headers(){
    for(int i = 0; in_objs[i].file; i++){
        obj_read_header(&in_objs[i]);
    }
}

/* Write out to the binary */
void output_byte(uint8_t val){
  fputc(val, out_file);
}

void output_word(uint16_t word){
  fputc(word & 0x00ff, out_file);
  fputc(word >> 8, out_file);
}