#include "include/defs.h"
#include "kernel/proc.h"

#include "include/panic.h"
#include "kernel/panic.h"
#include "kernel/shed.h"
#include "kernel/kernel.h"

/* Exiting and waiting functions */

static pid_t children[PROC_TABLE_ENTRIES];

/* Exit from the current process */
uint16_t _exit(uint16_t ret_val, uint16_t a1, uint16_t a2, uint16_t a3){
    /* set return value */
    proc_current_proc->ret_val = ret_val;
    proc_current_proc->has_retd = 1;
    /* Check if parent is still alive. If it is, become a zombie. Otherwise, die
     * If the parent is 1 (init), we know the parent died while this proc was running,
     * so we can just kill this proc (not need to make init wait) */
    if(proc_current_proc->parent != 1){
        /* become zombie */
        proc_release_resources(proc_current_proc);
        /* set state */
        proc_current_proc->state = PROC_STATE_ZOMBIE;
    } else {
        /* Completely die */
        proc_put(proc_current_proc);
    }

    /* Go through all of the proc's children
     * if they are zombies, kill them completely
     * if they are not, just reparent them to proc 1 (init) */
    uint16_t num_children = proc_find_children(proc_current_proc->pid, children);
    for(uint16_t i = 0; i < num_children; i++){
        /* kill dead children */
        if(proc_is_zombie(&proc_table[children[i]])){
            /* completly kill */
            proc_put(&proc_table[children[i]]);
        } else {
            /* just orphan */
            proc_table[children[i]].parent = 1;
        }
    }

    /* shedule - don't try to rerun current proc by mistake */
    shed_shedule();

    return 0;

}

/* wait (needs blocking wrapper)
 * returns -1 on error, 0 on no process done, and the pid of a finished child proc
 * if pid was returned, then the child proc has been removed, and the return value will be
 * put into the passed pointer */
uint16_t _wait_nb(uint16_t ret_pointer, uint16_t a1, uint16_t a2, uint16_t a3){
    uint8_t * ret_val = kernel_map_in_mem((uint8_t *)ret_pointer, proc_current_proc);
    if(!ret_val){
        return -1;
    }

    /* find children */
    uint16_t num_children = proc_find_children(proc_current_proc->pid, children);
    /* error if no children */
    if(!num_children){
        return -1;
    }
    for(uint16_t i = 0; i < num_children; i++){
        /* check if a zombie proc exists */
        if(proc_table[children[i]].state == PROC_STATE_ZOMBIE){
            /* release zombie, get return value, and return pid */
            if(!proc_table[children[i]].has_retd){
                panic(PANIC_PROC_NO_RET_VAL);
            }
            *ret_val = proc_table[children[i]].ret_val;
            pid_t pid = proc_table[children[i]].pid;
            proc_put(&proc_table[children[i]]);
            return pid;
        }
    }

    return 0;
}
