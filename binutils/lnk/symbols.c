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
uint32_t defined_size[MAX_FILES];
uint32_t extern_size[MAX_FILES];

/* read in symbol tables */
void symbol_read_in_tables(){
    for(int i = 0; in_objs[i].file; i++){
        defined_tables[i] = obj_get_defined(&in_objs[i]);
        extern_tables[i] = obj_get_extern(&in_objs[i]);

        defined_size[i] = in_objs[i].segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
        extern_size[i] = in_objs[i].segs.extern_table.size / _OBJ_SYMBOL_ENTRY_SIZE;
    }
}

/* find the entry of an external symbol in the defined symbol tables, and return it if found, NULL otherwise. Looks for the index'th entry of the i'th file's external table
    set file to which file's defined table it was found in */
struct obj_symbol_entry * find_extern(int i, uint32_t index, int *file){
    struct obj_symbol_entry *entry = &(extern_tables[i][index]);
    /* look through all the tables */
    for(int f = 0; in_objs[f].file; f++){
        /* look through all entries */
        for(int n = 0; n < defined_size[f]; n++){
            if(!strcmp(entry->name, defined_tables[f][n].name)){
                struct obj_symbol_entry *match = &defined_tables[f][n];
                *file = f;
                return match;
            }
        }
    }

    *file = -1;
    return NULL;
}

/* find a symbol in all the defined symbol tables, and return the index of the file that had it */
int find_defined_symbol_file(char *name){
    /* look through all the tables */
    for(int f = 0; in_objs[f].file; f++){
        /* look through all entries */
        for(int n = 0; n < defined_size[f]; n++){
            if(!strcmp(name, defined_tables[f][n].name)){
                return f;
            }
        }
    }
    return -1;
}

/* get the real address of a symbol defined in an external table of the i'th file */
uint16_t extern_get_addr(int i, uint32_t index){
    struct obj_symbol_entry *entry = &(extern_tables[i][index]);
    uint16_t addr;
    int file;

    struct obj_symbol_entry *match = find_extern(i, index, &file);

    if(!match){
        /* no symbol found - error */
        printf(BIN_NAME ": error:\nundefined reference to '%s'\n", entry->name);
        exit(1);
    }

    addr = in_segs_start[file][match->seg] + match->offset;
    /* add offset in extern table */
    addr += entry->offset;
    return addr;
}

/* write out the defined and extern symbol tables (only for obj output) */
void obj_out_write_symbols(){
    for(int i = 0; in_objs[i].file; i++){
        for(int d = 0; d < in_objs[i].segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE; d++){
            obj_write_defined(&out_obj, defined_tables[i][d].name, defined_tables[i][d].seg, defined_tables[i][d].offset + in_segs_start[i][defined_tables[i][d].seg]);
        }
        for(int d = 0; d < in_objs[i].segs.extern_table.size / _OBJ_SYMBOL_ENTRY_SIZE; d++){
            obj_write_extern(&out_obj, extern_tables[i][d].name, extern_tables[i][d].offset);
        }
    }
}

void sym_detect_duplicate_entries() {
    /* look through all the tables */
    for(int f = 0; in_objs[f].file; f++){
        /* look through all entries */
        for(int n = 0; n < defined_size[f]; n++){
            struct obj_symbol_entry *entry = &defined_tables[f][n];
            /* look through all the tables */
            for(int f1 = 0; in_objs[f1].file; f1++){
                /* look through all entries */
                for(int n1 = 0; n1 < defined_size[f1]; n1++){
                    if(f1 == f && n1 == n) continue;
                    struct obj_symbol_entry *entry1 = &defined_tables[f1][n1];
                    if(!strcmp(entry->name, entry1->name)) {
                        fprintf(stderr, "\n" BIN_NAME ": error:\nduplicate definition of symbol: %s\n", entry->name);
                        exit(1);
                    }
                }
            }
        }
    }
}

/* write out symbol adresses */
void sym_out_write_symbols(FILE * file){
    for(uint32_t a = 0; a < 65535; a++){
        for(int i = 0; in_objs[i].file; i++){
            if(!in_objs_do_lnk[i]) continue;
            for(int d = 0; d < in_objs[i].segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE; d++){
                struct obj_symbol_entry *entry = &defined_tables[i][d];
                uint16_t addr = in_segs_start[i][entry->seg] + entry->offset;
                if(addr == 0){
                    continue;
                }
                if(addr == a){
                    fprintf(file, "0x%04x: %s\n", addr, defined_tables[i][d].name);
                }
            }
        }
    }
}