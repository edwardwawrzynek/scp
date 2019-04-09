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
#include "kernel/palloc.h"
#include "include/lib/kmalloc.h"

uint8_t path_buf[256];


/* Execv system call (TODO: implement env variables, execve) */
uint16_t _execv(uint16_t name, uint16_t argv_p, uint16_t a2, uint16_t a4){
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
    if(!(file->ind->flags & INODE_FLAG_EXEC)){
        file_put(file);
        return -1;
    }

    /* read argv from old memory, and copy to kernel space */
    uint8_t **kargv;
    uint16_t argv_i;
    if(argv_p != NULL){
        uint8_t ** sargv = kernel_map_in_mem((uint8_t *)argv_p, proc_current_proc);
        for(argv_i = 0;;argv_i++){
            if(sargv[argv_i] == NULL){
                break;
            }
        }
        kargv = kmalloc(argv_i*sizeof(uint8_t **));
        memcpy(kargv, sargv, argv_i*sizeof(uint8_t **));

        /* copy strings pointed to by argv into kernel memory */
        for(uint16_t n=0;n<argv_i;n++){
            uint8_t * sargv_i = kernel_map_in_mem((uint8_t *)kargv[n], proc_current_proc);
            uint8_t * kargv_i = kmalloc(strlen(sargv_i)+1);
            memcpy(kargv_i, sargv_i, strlen(sargv_i)+1);

            kargv[n] = kargv_i;
        }

    }

    /* release memory */
    proc_put_memory(proc_current_proc);
    /* reset cpu state */
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

    /* copy argv to new mem map */
    proc_current_proc->cpu_state.regs[15]=0;
    if(argv_p != NULL){
        for(uint16_t n=0;n<argv_i;n++){
            uint8_t *new_kargv_i = proc_add_to_stack(proc_current_proc, kargv[n], strlen(kargv[n])+1);
            kfree(kargv[n]);
            kargv[n] = new_kargv_i;
        }
        uint8_t **new_kargv = (uint8_t **)proc_add_to_stack(proc_current_proc, kargv, argv_i*sizeof(uint8_t **));
        kfree(kargv);
        kargv = new_kargv;
        proc_add_to_stack(proc_current_proc, &kargv, 2);
        proc_add_to_stack(proc_current_proc, &argv_i, 2);
    } else {
        uint16_t data = 0;
        /* argc 0, argv NULL */
        proc_add_to_stack(proc_current_proc, &data, 2);
        proc_add_to_stack(proc_current_proc, &data, 2);
    }


    //set in runnable state
    proc_current_proc->state = PROC_STATE_RUNNABLE;

    //release bin file
    file_put(file);

    //shedule
    shed_shedule();
}