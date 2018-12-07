#include <stdio.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"

/* Handle symbol resolution */

/* symbol tables malloc'd by obj routines */

struct obj_symbol_entry *defined_tables[MAX_FILES];
struct obj_symbol_entry *extern_tables[MAX_FILES];

/* number of elements in each table */
uint16_t defined_size[MAX_FILES];
uint16_t extern_size[MAX_FILES];

/* read in symbol tables */
void symbol_read_in_tables(){
    for(int i = 0; in_objs[i].file; i++){
        defined_tables[i] = obj_get_defined(&in_objs[i]);
        extern_tables[i] = obj_get_defined(&in_objs[i]);

        defined_size[i] = in_objs[i].segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
        extern_size[i] = in_objs[i].segs.extern_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
    }
}
