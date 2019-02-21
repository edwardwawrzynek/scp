#include "include/defs.h"
#include "kernel/proc.h"

#include "include/panic.h"
#include "kernel/panic.h"

/* Create a fork of the current running process
 * its execution starts at the same place, but fork returns 0 for it instead of the child pid */
uint16_t _fork(){
    /* Create new proc */
    struct proc * child = proc_new_entry(proc_current_proc->pid, proc_current_proc->cwd, proc_current_proc->croot);

    /* copy resources, including memory */
    proc_fork_resources(proc_current_proc, child);

    /* set return value for child (parent return is return value of this function) */
    child->cpu_state.regs[0xe] = 0;

    /* set child up to execute */
    child->state = PROC_STATE_RUNNABLE;

    /* return child's pid */
    return child->pid;
}