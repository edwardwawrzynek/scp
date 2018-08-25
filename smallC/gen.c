/*      File gen.c: 2.1 (83/03/20,16:02:06) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/* asm buffer's for rearanging or delaying output (right to left function calls, etc) */
/* buffers */

struct asm_buffer {
    char buf[ASM_BUFFER_SIZE];
    unsigned int pos;
};

struct asm_buffer asm_buffers[NUMBER_OF_ASM_BUFFERS];
/* current buffer (-1 is file output) */
int asm_buffer = -1;

/**
 * return next available internal label number
 */
getlabel() {
    return (nxtlab++);
}

/**
 * print specified number as label
 * @param label
 */
print_label(int label) {
    output_label_prefix ();
    output_decimal (label);
}

/**
 * glabel - generate label
 * not used ?
 * @param lab label number
 */
glabel(char *lab) {
    output_string (lab);
    output_label_terminator ();
    newline ();
}

/**
 * gnlabel - generate numeric label
 * @param nlab label number
 * @return 
 */
generate_label(int nlab) {
    print_label (nlab);
    output_label_terminator ();
    newline ();
}

/**
 * outputs one byte
 * @param c
 * @return 
 */
output_byte(char c) {
    if (c == 0){
        return (0);
    }
#ifndef USE_ASM_BUFFERS
    fputc (c, output);
#endif
#ifdef USE_ASM_BUFFERS
    if(asm_buffer == -1){
        fputc(c, output);
    } else {
        if(asm_buffers[asm_buffer].pos >= ASM_BUFFER_SIZE){
            printf("Error: assembly buffer overflow - Increase size of ASM_BUFFERS_SIZE\n");
            exit (1);
        } else {
            asm_buffers[asm_buffer].buf[(asm_buffers[asm_buffer].pos)++] = c;
        }
    }
#endif
    return (c);
}

/** dump the contents of a asm buffer to the output file, clearing the buffer */

dump_asm_buffer(int buf){
    unsigned int i;
    if(buf==-1){
        return;
    }
#ifdef USE_ASM_BUFFERS
    fputs(asm_buffers[buf].buf, output);
    for(i = 0; i < ASM_BUFFER_SIZE; ++i){
        asm_buffers[buf].buf[i] = 0;
    }
#endif
    return;
}

set_asm_buffer(int level){
#ifdef USE_ASM_BUFFERS
    asm_buffer = level;
#endif
}

/**
 * outputs a string
 * @param ptr the string
 * @return 
 */
output_string(char ptr[]) {
    int k;
    k = 0;
    while (output_byte (ptr[k++]));
}

/**
 * outputs a tab
 * @return 
 */
print_tab() {
    output_byte ('\t');
}

/**
 * output line
 * @param ptr
 * @return 
 */
output_line(char ptr[])
{
    output_with_tab (ptr);
    newline ();
}

/**
 * tabbed output
 * @param ptr
 * @return 
 */
output_with_tab(char ptr[]) {
    print_tab ();
    output_string (ptr);
}

/**
 * output decimal number
 * @param number
 * @return 
 */
output_decimal(int number) {
#ifndef USE_ASM_BUFFERS
    fprintf(output, "%d", number);
#endif
#ifdef USE_ASM_BUFFERS
    if(asm_buffer == -1){
        fprintf(output, "%d", number);  
    } else {
        asm_buffers[asm_buffer].pos += sprintf(asm_buffers[asm_buffer].buf+asm_buffers[asm_buffer].pos, "%d", number);
    }
#endif
}

/**
 * stores values into memory
 * @param lval
 * @return 
 */
store(LVALUE *lval) {
    if (lval->indirect == 0)
        gen_put_memory (lval->symbol);
    else
        gen_put_indirect (lval->indirect);
}

rvalue(LVALUE *lval, int reg) {
    if ((lval->symbol != 0) & (lval->indirect == 0))
        gen_get_memory (lval->symbol);
    else
        gen_get_indirect (lval->indirect, reg);
    return HL_REG;
}

/**
 * parses test part "(expression)" input and generates assembly for jump
 * @param label
 * @param ft : false - test jz, true test jnz
 * @return 
 */
test(int label, int ft) {
    needbrack ("(");
    expression (YES);
    needbrack (")");
    gen_test_jump (label, ft);
}

/**
 * scale constant depending on type
 * @param type
 * @param otag
 * @param size
 * @return 
 */
scale_const(int type, int otag, int *size) {
    switch (type) {
        case CINT:
        case UINT:
            *size += *size;
            break;
        case STRUCT:
            *size *= tag_table[otag].size;
            break;
        default:
            break;
    }
}
