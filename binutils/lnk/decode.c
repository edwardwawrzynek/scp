#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"
#include "symbols.h"

/* read in a piece of data from the i'th file and seg'th segment in in_objs, and output it
   return 1 if end of segment reached, 0 otherwise */
int bin_decode_data(int i, uint8_t seg){
    uint16_t data;
    uint8_t flags, is_word;
    /* read in data */
    if(obj_read_data(&in_objs[i], &data, &flags, &is_word) == -1){
        return 1;
    }
    /* handle single bytes */
    if(!is_word){
        if(flags & OBJ_IS_SYMBOL){
            error("single byte addresses aren't allowed");
        }
        write_byte(data & 0xff);
    }
    /* handle constant words */
    else if(!(flags & OBJ_IS_SYMBOL)){
        write_word(data);

    }
    /* handle symbols */
    else {
        /* handle extern symbols */
        if(flags & OBJ_IS_EXTERN){
            uint8_t is_pc_relative = (flags & OBJ_IS_PC_RELATIVE);

            uint16_t real_addr = extern_get_addr(i, data);
            /* adjust for pc relative offsets */
            if(is_pc_relative){
                real_addr -= seg_pos[cur_seg] + seg_start[cur_seg];
            }
            write_word(real_addr);
        }
        /* symbol is in current file */
        else {
            uint8_t seg_num = (flags & OBJ_SEG_NUM) >> 4;
            uint8_t is_pc_relative = (flags & OBJ_IS_PC_RELATIVE);

            uint16_t real_addr = data + in_segs_start[i][seg_num];
            /* check that real_addr is actually in seg */
            if(!( real_addr >= seg_start[seg_num] && real_addr <= seg_start[seg_num] + seg_size[seg_num])){
                /* allow symbols out of seg, because we may be taking their addr then adding to to something */
                //error("symbol resolves to address outside of declared segment");
            }
            /* adjust for pc relative offsets */
            if(is_pc_relative){
                real_addr -= seg_pos[cur_seg] + seg_start[cur_seg];
            }
            write_word(real_addr);
        }
    }
    return 0;
}

/* run the main pass of the linker */
void bin_main_pass(){
    /* read through each file */
    for(int i = 0; in_objs[i].file; i++){
        if(!in_objs_do_lnk[i]){
            continue;
        }
        /* Go through each seg */
        for(int s = 0; s < 4; s++){
            /* set seg */
            obj_set_seg(&in_objs[i], s);
            bin_set_seg(s);
            while(!bin_decode_data(i, s));
        }

    }
}

/* handle a piece of data from the input files, and do obj output on it */
int obj_out_decode_data(int i, uint8_t seg){
    uint16_t data;
    uint8_t flags, is_word;
    /* read in data */
    if(obj_read_data(&in_objs[i], &data, &flags, &is_word) == -1){
        return 1;
    }
    /* handle single bytes */
    if(!is_word){
        if(flags & OBJ_IS_SYMBOL){
            error("single byte addresses aren't allowed");
        }
        obj_write_const_byte(&out_obj, data&0xff);
    }
    /* handle constant words */
    else if(!(flags & OBJ_IS_SYMBOL)){
        obj_write_const_word(&out_obj, data);

    }
    /* handle symbols */
    else {
        /* handle extern symbols */
        if(flags & OBJ_IS_EXTERN){
            uint8_t is_pc_relative = (flags & OBJ_IS_PC_RELATIVE);

            int file;
            /* see if we can resolve the symbol with a symbol defined in this table */
            struct obj_symbol_entry *match = find_extern(i, data, &file);
            struct obj_symbol_entry *entry = &(extern_tables[i][data]);
            if(match == NULL){
                /* just write out index in table - wasn't defined in thsi table */
                obj_write_extern_offset(&out_obj, data + extern_start[i], is_pc_relative);
            } else {
                obj_write_offset(&out_obj, match->offset + entry->offset + in_segs_start[file][match->seg], match->seg, is_pc_relative);
            }

        }
        /* symbol is in current file */
        else {
            uint8_t seg_num = (flags & OBJ_SEG_NUM) >> 4;
            uint8_t is_pc_relative = (flags & OBJ_IS_PC_RELATIVE);

            obj_write_offset(&out_obj, data + in_segs_start[i][seg_num], seg_num, is_pc_relative);

        }
    }
    return 0;
}

/* run the main pass of the linker for obj output */
void obj_out_main_pass(){
    /* read through each file */
    for(int i = 0; in_objs[i].file; i++){
        if(!in_objs_do_lnk[i]){
            continue;
        }
        /* Go through each seg */
        for(int s = 0; s < 4; s++){
            /* set seg */
            obj_set_seg(&in_objs[i], s);
            obj_set_seg(&out_obj, s);
            while(!obj_out_decode_data(i, s));
        }

    }
}

/* clear in_obj_do_lnk in preparation for static linking dependency removal */
void in_objs_clear_do_lnk(){
    for(int i = 0; in_objs[i].file; i++){
        in_objs_do_lnk[i] = 0;
    }
}

/* recursivley add object dependencies (mark do_lnk as true) for a symbol */
void add_symbol_deps(char * symbol, int do_debug){
    /* find symbol */
    int file_index = find_defined_symbol_file(symbol);
    if(do_debug)
        printf(BIN_NAME ": dependency added on symbol: %s\n", symbol);
    if(file_index == -1){
        /* no symbol found - error */
        printf(BIN_NAME ": error:\nundefined reference to '%s'\n", symbol);
        exit(1);
    }
    /* if we already found this file as dep, don't do it again */
    if(in_objs_do_lnk[file_index]){
        return;
    }
    /* found file, so make as needed and find deps of all symbols in extern table of file */
    in_objs_do_lnk[file_index] = 1;
    for(int n = 0; n < extern_size[file_index]; n++){
        if(extern_tables[file_index][n].seg == 0xff){
            if(do_debug)
                printf(BIN_NAME ": symbol %s adds dependency for %s\n", symbol, extern_tables[file_index][n].name);
            add_symbol_deps(extern_tables[file_index][n].name, do_debug);
        }
    }

}