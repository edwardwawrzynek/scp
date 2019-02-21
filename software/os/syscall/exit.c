#include "include/defs.h"
#include "kernel/proc.h"

#include "include/panic.h"
#include "kernel/panic.h"

/* Exit from the current process */
uint16_t _exit(uint16_t a0, uint16_t a1, uint16_t a2, uint16_t a3){
    /* Go through all of the proc's children
     * if they are zombies, kill them completely
     * if they are not, just reparent them to proc 1 (init) */

    /* Check if parent is still alive. If it is, become a zombie. Otherwise, die
     * If the parent is 1 (init), we know the parent died while this proc was running,
     * so we can just kill this proc (not need to make init wait) */
    /* TODO: awaken wait'ing processes here */
    struct proc * parent = proc_get(proc_current_proc->parent);
    if(parent && (parent != 1)){
        /* become zombie */
        proc_release_resources(proc_current_proc);
        /* set state */
        proc_current_proc->state = PROC_STATE_ZOMBIE;
    } else {
        /* Completely die */
        proc_put(proc_current_proc);
    }
}
