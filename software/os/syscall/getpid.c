#include "include/defs.h"
#include "kernel/proc.h"

#include "include/panic.h"
#include "kernel/panic.h"

/* Get the current process id */
uint16_t _getpid(uint16_t a0, uint16_t a1, uint16_t a2, uint16_t a3){
    return proc_current_proc->pid;
}

/* Get the current process parent's id
 * if parent has finished executing, process is reparented to pid 1 (init) - procs should be reparented when parent calls exit, not here */

uint16_t _getppid(uint16_t a0, uint16_t a1, uint16_t a2, uint16_t a3){
    struct proc * parent = proc_get(proc_current_proc->parent);
    if(parent){
        return proc_current_proc->parent;
    } else {
        panic(PANIC_PROC_HAS_DEAD_PARENT);
        return 1;
    }
}
