#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "include/panic.h"
#include "kernel/panic.h"

#include "syscall/files.h"

#include "syscall/exec.h"
#include "errno.h"

/* Change current working directory of proc */
uint16_t _chdir(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    char * path = kernel_map_in_mem((uint8_t *) name, proc_current_proc);
    if(!path){
        set_errno(EUMEM);
        return -1;
    }
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        set_errno(ENOENT);
        return -1;
    }

    proc_current_proc->cwd = inum;

    return 0;
}

uint16_t _fchdir(uint16_t fd, uint16_t a1, uint16_t a2, uint16_t a3){
    if(proc_current_proc->files[fd] == NULL){
        set_errno(EBADF);
        return -1;
    }
    uint16_t inum = proc_current_proc->files[fd]->ind->inum;
    if(!inum){
        set_errno(ENOENT);
        return -1;
    }

    proc_current_proc->cwd = inum;

    return 0;
}

/* Change current working root directory of proc */
uint16_t _chroot(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    char * path = kernel_map_in_mem((uint8_t *) name, proc_current_proc);
    if(!path){
        set_errno(EUMEM);
        return -1;
    }
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        set_errno(ENOENT);
        return -1;
    }

    proc_current_proc->croot = inum;

    return 0;
}