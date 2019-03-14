#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "include/panic.h"
#include "kernel/panic.h"

#include "syscall/files.h"

/* change the brk of a proccess by a set amount, and return the old brk */
uint16_t _sbrk(uint16_t change, uint16_t a1, uint16_t a2, uint16_t a3){
    uint16_t old_brk = (uint16_t)proc_current_proc->mem_struct.brk;

    if(proc_set_brk(proc_current_proc, (uint8_t *)(old_brk+change))){
        return -1;
    }

    return old_brk;
}

/* set the brk of a process */
uint16_t _brk(uint16_t brk, uint16_t a1, uint16_t a2, uint16_t a3){
    return proc_set_brk(proc_current_proc, (uint8_t *)(brk)) == 0 ? 0 : -1;
}
