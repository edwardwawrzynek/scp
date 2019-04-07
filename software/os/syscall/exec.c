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

    /* reset cpu state */
    proc_reset_cpu(proc_current_proc);

    /* copy argv data to existing last stack page, which we later inject into new mem map (hacky but works, and doesn't require a kernel space buffer) */
    uint8_t **argv = (uint8_t **)kernel_map_in_mem2((uint8_t *)argv_p, proc_current_proc);
    if(argv == NULL){
        panic(PANIC_ERROR);
    }
    /* copy argv contents onto stack, then argv, then pointers passed to main */
    if(argv_p != NULL){
        uint16_t i;
        for(i = 0; argv[i] != NULL; i++){
            uint8_t * argv_i = kernel_map_in_mem2(argv[i], proc_current_proc);
            if(argv_i == NULL){
                panic(PANIC_ERROR);
            }
            uint8_t *new_argv_i = proc_add_to_stack(proc_current_proc, argv_i, strlen(argv_i)+1);
            uint8_t **argv = (uint8_t **)kernel_map_in_mem2((uint8_t *)argv_p, proc_current_proc);
            argv[i] = new_argv_i;
        }
        uint8_t *argv_stack = proc_add_to_stack(proc_current_proc, (uint8_t *)argv, i*2);
        proc_add_to_stack(proc_current_proc, (uint8_t *)(&argv_stack), 2);
        proc_add_to_stack(proc_current_proc, (uint8_t *)(&i), 2);
        printf("[0]: %u, [1]: %u\n", argv_stack, i);
    }else {
        uint16_t data;
        data = 0;
        proc_add_to_stack(proc_current_proc, (uint8_t *)(&data), 2);
        data = NULL;
        proc_add_to_stack(proc_current_proc, (uint8_t *)(&data), 2);
    }
    uint16_t old_page = proc_current_proc->mem_map[31];


    /* release memory */
    proc_put_memory(proc_current_proc);

    /* TODO: handle executables beginning with #! */

    /* load memory */
    if(proc_load_mem(proc_current_proc, file)){
        file_put(file);
        /* TODO: we can't fail b/c proc has no memory, so kill proc
         * unlikely to happen (probably just call exit)*/
        panic(PANIC_ERROR);
        return -1;
    }

    /* inject stack page that we previously loaded argv into */
    palloc_free(proc_current_proc->mem_map[31]);
    proc_current_proc->mem_map[31] = palloc_use_page(old_page);
    proc_write_mem_map(proc_current_proc);

    //set in runnable state
    proc_current_proc->state = PROC_STATE_RUNNABLE;

    //release bin file
    file_put(file);

    //shedule
    shed_shedule();
}