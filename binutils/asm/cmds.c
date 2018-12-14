#include "asm.h"
#include "object.h"
#include "obj.h"
#include "labels.h"
#include "io.h"
#include "decode.h"

void second_pass(struct instr *i);

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
            struct label *l = find_label(i->args[0].str, cur_module, 1);
            if(!l){
                error("No such label\n");
            }
            l->module = -1;
            return 0;
        case external:
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

/* align at the end of first pass */
void first_pass_align(){
    seg_pos[0] += seg_pos[0] & 1;
    seg_pos[1] += seg_pos[1] & 1;
    seg_pos[2] += seg_pos[2] & 1;
    seg_pos[3] += seg_pos[3] & 1;
}

/* run the second pass of a directive - return bytes*/
uint16_t dir_second_pass(struct instr *i){
    switch(i->dir_type){
        case dc_b:
        case dc_bs:
            /* write out byte */
            obj_write_const_byte(&out, i->args[0].val);
            return 1;
        case dc_w:
            obj_write_const_word(&out, i->args[0].val);
            return 2;
        case dc_l:
            obj_write_const_word(&out, i->args[0].val & 0xffff);
            obj_write_const_word(&out, i->args[0].val >> 16);
            return 4;
        case ds:
            for(uint16_t n = 0; n < i->args[0].val; n++){
                obj_write_const_byte(&out, 0);
            }
            return i->args[0].val;
        case align:
            /* if we aren't aligned, we will need to add a byte */
            if(seg_pos[cur_seg] & 1){
                obj_write_const_byte(&out, 0);
                return 1;
            }
            return 0;
        case module:
            cur_module++;
            return 0;
        case global:;
            /* no need to do anything on second pass */
            return 0;
        case external:
            /* no need to do anything on second pass */
            return 0;

        /* all of these go in the read-only segment */
        case text:
        case rodata:
        case robss:
            cur_seg = 0;
            obj_set_seg(&out, cur_seg);
            return 0;
        /* read and write segment */
        case data:
        case bss:
            cur_seg = 1;
            obj_set_seg(&out, cur_seg);
            return 0;

        default:
            break;
    }
    error("Directive not handled in second pass\n");
    return 0;
}

/* output a label immediate */
void write_label_imd(struct arg *arg){
    /* find entry in symbol table */
    struct label *lab = find_label(arg->str, cur_module, 0);
    if(!lab){
        error("No such label\n");
    }
    /* handle defined labels */
    if(lab->seg != -1){
        obj_write_offset(&out, lab->addr + arg->offset, lab->seg, 1);
    }
    /* handle externaly defined labels */
    else {
        /* if there is an offset, we need to add an external symbol table entry */
        if(arg->offset){
            obj_expand_extern(&out, (out.segs.extern_table.size / _OBJ_SYMBOL_ENTRY_SIZE) + 1);
            uint16_t ind = obj_write_extern(&out, lab->name, arg->offset);
            obj_write_extern_offset(&out, ind, 1);
        } else {
            obj_write_extern_offset(&out, lab->extern_index, 1);
        }

    }
}

/* interpret an asm command as type, and return its value (labels return 0) */
uint16_t type_get_value(struct arg *arg, enum arg_type typ){
    switch(typ){
        case reg:
            if(!arg->is_reg){
                error("Arg has to be reg\n");
            }
            return arg->reg;
        case alu:
            if(!arg->is_alu){
                error("Arg has to be alu\n");
            }
            return arg->alu_op;
        case cnst:
            if(!arg->is_val){
                error("Arg has to be a value\n");
            }
            return arg->val;
        case cond:
            if(!arg->is_cond){
                error("Arg has to be cond\n");
            }
            return arg->cond_code;
        default:
            /* labels are handled as immediates */
            return 0;
    }
}

/* run the second pass on an asm instruction */
uint16_t cmd_second_pass(struct instr *i){
    struct instr_encoding *en = i->encoding;
    /* encode instruction */
    /* ultimate result of encoding (not includign immediate */
    uint16_t res = 0;
    /* values for each arg (not including labels) */
    uint16_t values[11];

    /* get opcode */
    values[0] = i->opcode;
    /* go thorugh eahc arg, and gets its value */
    int16_t n = 0;
    while(en->types[n] != end_arg){
        values[n+1] = type_get_value(&(i->args[n]), en->types[n]);
        n++;
    }

    /* actually encode */
    n = strlen(en->encoding)-1;
    while(n >= 0){
        /* get the value index to use */
        uint8_t value_index = hex2int(en->encoding[n]);

        /* OR in the bit, and shift the instr right */
        res >>= 1;
        /* OR in a zero if the bit is set as - */
        if(en->encoding[n] != '-'){
            res |= (values[value_index] & 1) << 15;
        }
        /* shift the value to the next bit */
        values[value_index] >>= 1;

        n--;
    }
    /* write out */
    obj_write_const_word(&out, res);

    /* encode immediate */
    if(en->imd_field){
        /* constant immediate */
        if(en->types[en->imd_field -1] == cnst){
            obj_write_const_word(&out, i->args[en->imd_field -1].val);
        }
        /* label immediate */
        else if(en->types[en->imd_field -1] == label){
            write_label_imd(&(i->args[en->imd_field -1]));
        }
        /* four bytes written */
        return 4;
    }
    return 2;
}

/* run the second pass on a instruction */
void second_pass(struct instr *i){
    if(i->is_label){
        /* nothing to do for a label */
    } else if(i->is_dir){
        seg_pos[cur_seg] += dir_second_pass(i);
    } else if(i->opcode != -1){
        seg_pos[cur_seg] += cmd_second_pass(i);
    } else {
        error("First pass can't handle this command\n");
    }
}