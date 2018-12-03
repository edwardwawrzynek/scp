#include "asm.h"

/* Functions to figure out size of commands, and get their output */

/* get the size of a struct instr known to be a directive */
uint16_t get_dir_size(struct instr *i){
    return 1;
}