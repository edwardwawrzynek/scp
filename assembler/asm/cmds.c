#include "asm.h"
#include "object.h"
#include "labels.h"
#include "io.h"

/* Functions to figure out size of commands, and get their output */

/* run the first pass on a directive, adding any labels that need to be added, change module number, and return number of bytes used by the directive */
uint16_t dir_first_pass(struct instr *i){
    switch(i->dir_type){
        case dc_b:
        case dc_bs:
            return 1;
        case dc_w:
            return 2;
        case dc_l:
            return 4;
        case ds:
            return i->args[0].val;
        case align:
            /* if we aren't aligned, we will need to add a byte */
            return seg_pos[cur_seg] & 1;
        case module:
            cur_module++;
            return 0;
        case global:;
            struct label *l = find_label(i->args[0].str, cur_module);
            if(!l){
                error("No such label\n");
            }
            l->module = -1;
            return 0;
        case external:
            /* TODO: should we only be adding the extern in the current module */
            add_label(i->args[0].str, -1, 0, -1);
            return 0;

        /* all of these go in the read-only segment */
        case text:
        case rodata:
        case robss:
            cur_seg = 0;
            return 0;
        /* read and write segment */
        case data:
        case bss:
            cur_seg = 1;
            return 0;

        default:
            break;
    }
    error("Directive not handled in first pass\n");
    return 0;
}

/* run the first pass on an asm command (just return size, not other action needed) */
uint16_t cmd_first_pass(struct instr *i){
    /* four bytes if we have an immediate */
    return i->encoding->imd_field ? 4 : 2;
}

/* run the first pass on a label (add it), and return size (always 0) */
uint16_t label_first_pass(struct instr *i){
    add_label(i->name, cur_module, seg_pos[cur_seg], cur_seg);
    return 0;
}

/* run the first pass on a instruction */
void first_pass(struct instr *i){
    if(i->is_label){
        seg_pos[cur_seg] += label_first_pass(i);
    } else if(i->is_dir){
        seg_pos[cur_seg] += dir_first_pass(i);
    } else if(i->opcode != -1){
        seg_pos[cur_seg] += cmd_first_pass(i);
    } else {
        error("First pass can't handle this command\n");
    }
}

/* run the second pass of a directive */
void dir_second_pass(struct instr *i){

}

/* run the second pass on a instruction */
void second_pass(struct instr *i){
    if(i->is_label){
        //label_second_pass(i);
    } else if(i->is_dir){
        dir_second_pass(i);
    } else if(i->opcode != -1){
        //cmd_second_pass(i);
    } else {
        error("First pass can't handle this command\n");
    }
}