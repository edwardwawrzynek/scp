#include "include/defs.h"
#include <lib/kstdio_layer.h>
#include <lib/inout.h>
#include "kernel/proc.h"
#include "kernel/context_switch.h"
#include "kernel/shed.h"

uint16_t int_save_state_regs[16];
uint16_t int_save_state_pc;
uint8_t int_save_state_cond;

/* Macro to save reg state + ipcon entry into int handlers
   Once we have saved regs, we can call functions to get cond_reg - sp and all other regs were already saved*/
#define int_save_reg_state() __asm("\n\
\tst.r.m.w r0 _int_save_state_regs+0\n\
\tst.r.m.w r1 _int_save_state_regs+2\n\
\tst.r.m.w r2 _int_save_state_regs+4\n\
\tst.r.m.w r3 _int_save_state_regs+6\n\
\tst.r.m.w r4 _int_save_state_regs+8\n\
\tst.r.m.w r5 _int_save_state_regs+10\n\
\tst.r.m.w r6 _int_save_state_regs+12\n\
\tst.r.m.w r7 _int_save_state_regs+14\n\
\tst.r.m.w r8 _int_save_state_regs+16\n\
\tst.r.m.w r9 _int_save_state_regs+18\n\
\tst.r.m.w ra _int_save_state_regs+20\n\
\tst.r.m.w rb _int_save_state_regs+22\n\
\tst.r.m.w rc _int_save_state_regs+24\n\
\tst.r.m.w rd _int_save_state_regs+26\n\
\tst.r.m.w re _int_save_state_regs+28\n\
\tst.r.m.w rf _int_save_state_regs+30\n\
\tmov.ipc.r r0\n\
\tst.r.m.w r0 _int_save_state_pc\n\
")

#define int_restore_reg_state() __asm("\n\
\tld.r.m.w r0 _int_save_state_regs+0\n\
\tld.r.m.w r1 _int_save_state_regs+2\n\
\tld.r.m.w r2 _int_save_state_regs+4\n\
\tld.r.m.w r3 _int_save_state_regs+6\n\
\tld.r.m.w r4 _int_save_state_regs+8\n\
\tld.r.m.w r5 _int_save_state_regs+10\n\
\tld.r.m.w r6 _int_save_state_regs+12\n\
\tld.r.m.w r7 _int_save_state_regs+14\n\
\tld.r.m.w r8 _int_save_state_regs+16\n\
\tld.r.m.w r9 _int_save_state_regs+18\n\
\tld.r.m.w ra _int_save_state_regs+20\n\
\tld.r.m.w rb _int_save_state_regs+22\n\
\tld.r.m.w rc _int_save_state_regs+24\n\
\tld.r.m.w rd _int_save_state_regs+26\n\
\tld.r.m.w re _int_save_state_regs+28\n\
\tld.r.m.w rf _int_save_state_regs+30\n\
")

#define int_save_state_set_sp() __asm("\tld.r.i sp 0\n")

/* set the int timer */
void int_reset_timer(uint16_t time){
    outp(_int_timer_port, time);
}

void int_handler_0(){
    printf("Int 0\n");
    while(1){};
}

/**
 * Int handler 1 is clock pulse int (for context switches)
 * It is handled in context_switch.asm */

void int_handler_2(){
    printf("Int 2\n");
    while(1){};
}

void int_handler_3(){
    printf("Int 3\n");
    while(1){};
}

void int_handler_4(){
    printf("Int 4\n");
    while(1){};
}

void int_handler_5(){
    printf("Int 5\n");
    while(1){};
}

void int_handler_6(){
    printf("Int 6\n");
    while(1){};
}

/**
 * Int handler 7 is software syscall int
 * It is handled in handler_asm.asm */
