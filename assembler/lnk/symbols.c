#include <stdio.h>
#include <string.h>

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
        extern_tables[i] = obj_get_extern(&in_objs[i]);

        defined_size[i] = in_objs[i].segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
        extern_size[i] = in_objs[i].segs.extern_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
    }
}

/* get the real address of a symbol defined in an external table of the i'th file */
uint16_t extern_get_addr(int i, uint16_t index){
    struct obj_symbol_entry *entry = &(extern_tables[i][index]);

    uint16_t addr;

    /* look through all the tables */
    for(int i = 0; in_objs[i].file; i++){
        /* look through all entries */
        for(int n = 0; n < defined_size[i]; n++){
            if(!strcmp(entry->name, defined_tables[i][n].name)){
                struct obj_symbol_entry *match = &defined_tables[i][n];
                addr = in_segs_start[i][match->seg] + match->offset;
                /* add offset in extern table */
                addr += entry->offset;
                return addr;
            }
        }
    }

    /* no symbol found - error */
    printf("scplnk: error:\nundefined reference to '%s'\n", entry->name);
    exit(1);
}
