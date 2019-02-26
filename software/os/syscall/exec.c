#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "include/panic.h"
#include "kernel/panic.h"
#include "include/lib/string.h"
#include "kernel/shed.h"

uint8_t path_buf[256];

/* Execv system call (TODO: implement env variables, execve) */
uint16_t _execv(uint16_t name, uint16_t argv, uint16_t a2, uint16_t a4){
    /* map in name */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }
    /* check cwd for executable */
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        /* check /bin */
        /* TODO: check PATH */
        memcpy(path_buf, "/bin/", 5);
        strcpy(path_buf+5, path);
        inum = fs_path_to_inum(path_buf, proc_current_proc->cwd, proc_current_proc->croot);
        if(!inum){
            return -1;
        }
    }

    /* open file, and check executable bit TODO: executable bit checking disabled for now, fix later */
    struct file_entry * file = file_get(inum, FILE_MODE_READ);
    /*if(!(file->ind->flags & INODE_FLAG_EXEC)){
        file_put(file);
        return -1;
    }*/

    /* release memory */
    proc_put_memory(proc_current_proc);
    proc_reset_cpu(proc_current_proc);

    /* TODO: handle executables beginning with #! */

    /* load memory */
    if(proc_load_mem(proc_current_proc, file)){
        file_put(file);
        /* TODO: we can't fail b/c proc has no memory, so kill proc
         * unlikely to happen (probably just call exit)*/
        panic(PANIC_ERROR);
        return -1;
    }

    /* TODO: load argv and argc for main */

    //set in runnable state
    proc_current_proc->state = PROC_STATE_RUNNABLE;

    //shedule
    shed_shedule();
}