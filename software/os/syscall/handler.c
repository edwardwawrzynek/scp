#include "include/defs.h"

#include "kernel/proc.h"
#include "kernel/context_vars.h"
#include "kernel/shed.h"

#include "syscall/test.h"

/* syscall table (all syscalls take four args, regardless of if they use them or not *) */
uint16_t (*syscalls[])(uint16_t, uint16_t, uint16_t, uint16_t) = {
    test_syscall,   /* sum args */

};

/* Passed Args and syscall number */
static uint16_t arg0, arg1, arg2, arg3;
static uint16_t syscall_num;

void syscall_handler_run(){
    /* save cpu status */
    proc_set_cpu_state(proc_current_proc, context_switch_regs, context_switch_pc_reg, context_switch_cond_reg);
    /* set syscall args */
    arg0 = context_switch_regs[0xa];
    arg1 = context_switch_regs[0xb];
    arg2 = context_switch_regs[0xc];
    arg3 = context_switch_regs[0xd];
    syscall_num = context_switch_regs[0xe];

    /* call syscall */
    uint16_t result = syscalls[syscall_num](arg0, arg1, arg2, arg3);

    /* set return reg in proc */
    context_switch_regs[0xe] = result;
    proc_set_cpu_state(proc_current_proc, context_switch_regs, context_switch_pc_reg, context_switch_cond_reg);

    /* shedule */
    shed_shedule();
}