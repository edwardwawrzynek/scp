#include "include/defs.h"
#include "lib/incl.h"
#include "kernel/incl.h"

static uint16_t int_handler_reg_a;
static uint16_t int_handler_reg_b;
static uint16_t int_handler_reg_sp;
static uint16_t int_handler_reg_pc;

/* macro to save the state in which the interupt was called, and the variables it uses */
#define _int_save_state() \
    /* save the state when the macro is called */ \
    _asm("\n\
    swma  int_handler_reg_a\n\
    swmb  int_handler_reg_b\n\
    mspa  #0\n\
    swma  int_handler_reg_sp\n\
    cpca\n\
    swma  int_handler_reg_pc\n"); \
    /* now adjust that to reflect what it was when the interupt fired */ \
    /* because the pc is after the last instr PC_INC, deincrement it */ \
    int_handler_reg_pc--

/* macro to set up a state in which the int handler can properly call kernel funcs
 * sets sp to zero so that part of the kernel isn't overwritten by sp from proc */
#define _int_begin_exec() _asm("    lwia    #0\n    masp\n")

void _int0_handler(){
  _int_save_state();
  _int_begin_exec();
  proc_set_cpu_state(proc_current_proc, int_handler_reg_a, int_handler_reg_b, int_handler_reg_pc, int_handler_reg_sp);
  shed_shedule();
  printf("Something went wrong\n");
}
void _int1_handler(){
  _int_save_state();
  _int_begin_exec();
  proc_set_cpu_state(proc_current_proc, int_handler_reg_a, int_handler_reg_b, int_handler_reg_pc, int_handler_reg_sp);
  shed_shedule();
  printf("Something went wrong\n");
}

void _int2_handler(){
  _int_save_state();
  _int_begin_exec();
  proc_set_cpu_state(proc_current_proc, int_handler_reg_a, int_handler_reg_b, int_handler_reg_pc, int_handler_reg_sp);
  shed_shedule();
  printf("Something went wrong\n");
}
void _int3_handler(){
    printf("Int 3 triggered\n");
    switch_to_user();
    while(1){}
}
void _int4_handler(){
    printf("Int 4 triggered\n");
    switch_to_user();
    while(1){}
}
void _int5_handler(){
    printf("Int 5 triggered\n");
    switch_to_user();
    while(1){}
}

void _int_reset_timer(uint16_t n){
    outp(255, n);
}