#include "include/defs.h"
#include "kernel/proc.h"

/* Get the current process id */
uint16_t _getpid(uint16_t a0, uint16_t a1, uint16_t a2, uint16_t a3){
    return proc_current_proc->pid;
}

/* Get the current process parent's id
 * if parent has finished executing, process is reparented to pid 1 (init) */

uint16_t _getppid(uint16_t a0, uint16_t a1, uint16_t a2, uint16_t a3){
    if(proc_table[proc_current_proc->parent].in_use){
        return proc_current_proc->parent;
    } else {
        return 1;
    }
}