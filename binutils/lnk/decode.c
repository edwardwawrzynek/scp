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
                error("symbol resolves to address outside of declared segment");
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

            /* just write out index in table - will be looked up anyway when linked to executable */
            obj_write_extern_offset(&out_obj, data + extern_start[i], is_pc_relative);
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
        /* Go through each seg */
        for(int s = 0; s < 4; s++){
            /* set seg */
            obj_set_seg(&in_objs[i], s);
            obj_set_seg(&out_obj, s);
            while(!obj_out_decode_data(i, s));
        }

    }
}