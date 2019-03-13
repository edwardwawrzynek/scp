#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "include/panic.h"
#include "kernel/panic.h"

#include "syscall/files.h"
#include "include/lib/string.h"

/* make directory, and fill . and .. entries */
uint16_t _mkdir(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    /* map in mem */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);

    if(!path){
        return -1;
    }
    /* make sure dir doesn't already exist */
    uint16_t inum = fs_path_to_contain_dir(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(inum){
        return -1;
    }
    /* get inums */
    uint16_t dir_inum = fs_path_to_contain_dir(path, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);

    if(!dir_make_dir(dir_inum, file_name_buf)){
        return -1;
    }

    return 0;
}

/* readdir - implemented with just wrapper on read in userspace using fstat*/
/* opendir - implemented as wrappers in userspace using stat (to make sure it is dir) */
/* closedir - implemented as wrpper in userspace using fstat (to mke sure it is dir) */

/* rmdir - remove a dir with just . and .. entries */

uint16_t _rmdir(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    /* map in path */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }

    /* make sure directory is empty (but for . and .. entries), and delete those */
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        return -1;
    }
    struct file_entry * dir = file_get(inum, FILE_MODE_READ);
    if(!dir){
        return -1;
    }
    /* make sure file is actually dir */
    if(!(dir->ind->flags & INODE_FLAG_DIR)){
        file_put(dir);
        return -1;
    }

    uint16_t file_inum = 0;
    while((file_inum = dir_next_entry(dir, file_name_buf)) != 0){
        if(!((!strncmp(".", file_name_buf, 14)) || (!strncmp("..", file_name_buf, 14)))){
            /* dir not empty */
            file_put(dir);
            return -1;
        }
    }
    /* dec link from the . entry */
    dir->ind->links--;
    file_put(dir);

    uint16_t dir_inum = fs_path_to_contain_dir(path, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);
    /* probably just a containing directory didn't exist */
    if(!dir_inum){
        return -1;
    }

    /* dec links from the .. entry in file */
    dir = file_get(dir_inum, FILE_MODE_READ);
    if(!dir){
        return -1;
    }
    dir->ind->links--;
    file_put(dir);

    /* remove directory */
    if(dir_delete_file(dir_inum, file_name_buf)){
        return -1;
    }

}
