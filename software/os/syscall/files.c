#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"

#include "include/panic.h"
#include "kernel/panic.h"

#include "syscall/files.h"

/* file modes */
#define O_RDONLY 1 /* read only mode */
#define O_WRONLY 2 /* write only mode */
#define O_RDWR 3   /* read and write mode */
#define O_APPEND 4 /* start at end of file for writing */
#define O_CREAT 8  /* create file if it doesn't exist (don't do anything if it already does) */
#define O_TRUNC 16 /* truncate file to length 0 */
#define O_EXCL 32  /* fail if O_CREAT is set and file already exists */

uint8_t file_name_buf[17];

/* Open a file, and return its file descriptor */
uint16_t _open(uint16_t name, uint16_t flags, uint16_t a2, uint16_t a3){

    char * path = kernel_map_in_mem((uint8_t *) name, proc_current_proc);
    if(!path){
        return -1;
    }
    /* find file */
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        if(flags & O_CREAT){
            return create_file(path);
        } else {
            return -1;
        }
    }
    uint16_t mode = 0;
    /* handle r/w modes (O_RDWR is handled by being O_RDONLY | O_WRONLY) */
    if(flags & O_RDONLY){
        mode |= FILE_MODE_READ;
    }
    if(flags & O_WRONLY){
        mode |= FILE_MODE_WRITE;
    }
    if(!(flags & 3)) {
        /* some kind of r/w mode is needed */
        return -1;
    }

    /* handle truncate */
    if(flags & O_TRUNC){
        if(!(mode & FILE_MODE_WRITE)){
            return -1;
        }
        mode |= FILE_MODE_TRUNCATE;
    }

    if(flags & O_APPEND){
        mode |= FILE_MODE_APPEND;
    }

    /* open */
    struct file_entry * file = file_get(inum, mode);
    if(!file){
        return -1;
    }

    /* put in proc */
    uint16_t fd = proc_set_next_open_fd(proc_current_proc, file);

    return fd;
}

/* create a new file, and return its file descriptor */
uint16_t _creat(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    char * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }

    return create_file(path);
}

/* create a file, and return its new fd, or -1 on failure */
uint16_t create_file(uint8_t *name){
    struct file_entry *file = NULL;
    /* if file exists already, truncate it */
    uint16_t inum = fs_path_to_inum(name, proc_current_proc->cwd, proc_current_proc->croot);
    if(inum){
        file = file_get(inum, FILE_MODE_WRITE | FILE_MODE_TRUNCATE);
        return proc_set_next_open_fd(proc_current_proc, file);
    } else {
        /* find containing directory */
        inum = fs_path_to_contain_dir(name, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);
        /* probably just a containing directory didn't exist */
        if(!inum){
            return -1;
        }
        /* we know the file doesn't exist, so we can just create it */
        inum = dir_make_file(inum, file_name_buf, 0, 0, 0);
        if(!inum){
            return -1;
        }
        file = file_get(inum, FILE_MODE_WRITE | FILE_MODE_TRUNCATE);
        return proc_set_next_open_fd(proc_current_proc, file);
    }
}

/* close a file descriptor */
uint16_t _close(uint16_t fd, uint16_t a1, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }

    file_put(proc_current_proc->files[fd]);
    proc_current_proc->files[fd] = NULL;
    return 0;
}

/* duplicate a file descriptor into an open file descriptor */
uint16_t _dup(uint16_t fd, uint16_t a1, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }

    uint16_t new_fd = proc_set_next_open_fd(proc_current_proc, proc_current_proc->files[fd]);

    file_inc_refs(proc_current_proc->files[fd]);

    return new_fd;
}

/* duplicate a file descriptor into a specific fd slot */
uint16_t _dup2(uint16_t old, uint16_t new, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[old]){
        return -1;
    }
    /* close new if open */
    if(proc_current_proc->files[new]){
        file_put(proc_current_proc->files[new]);
    }

    proc_current_proc->files[new] = proc_current_proc->files[old];

    file_inc_refs(proc_current_proc->files[new]);

    return new;
}

/* non blocking read and write calls (userspace implements blocking wrappers) */
uint16_t _read_nb(uint16_t fd, uint16_t buf, uint16_t bytes, uint16_t eof){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }
    uint8_t *kbuf = kernel_map_in_mem((uint8_t *)buf, proc_current_proc);
    uint8_t * keof = kernel_map_in_mem2((uint8_t *)eof, proc_current_proc);
    if((!kbuf) || (!keof)){
        /* can't set eof */
        return -1;
    }

    uint16_t read = file_read_nonblocking(proc_current_proc->files[fd], kbuf, bytes, keof);
    return read;
}

uint16_t _write_nb(uint16_t fd, uint16_t buf, uint16_t bytes, uint16_t eof){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }
    uint8_t *kbuf = kernel_map_in_mem((uint8_t *)buf, proc_current_proc);
    uint8_t * keof = kernel_map_in_mem2((uint8_t *)eof, proc_current_proc);
    if((!kbuf) || (!keof)){
        /* can't set eof */
        return -1;
    }

    return file_write_nonblocking(proc_current_proc->files[fd], kbuf, bytes, keof);
}

/* Link a previously existed file to a new location */
uint16_t _link(uint16_t old, uint16_t new, uint16_t a2, uint16_t a3){
    /* map in mem */
    uint8_t * old_path = kernel_map_in_mem((uint8_t *)old, proc_current_proc);
    uint8_t * new_path = kernel_map_in_mem2((uint8_t *)new, proc_current_proc);

    if((!old_path) || (!new_path)){
        return -1;
    }
    /* get inums */
    uint16_t old_inum = fs_path_to_inum(old_path, proc_current_proc->cwd, proc_current_proc->croot);
    /* make sure file doesn't exist already */
    uint16_t new_inum = fs_path_to_inum(new_path, proc_current_proc->cwd, proc_current_proc->croot);
    if(new_inum){
        return -1;
    }
    /* create new file */
    uint16_t dir_inum = fs_path_to_contain_dir(new_path, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);
    /* probably just a containing directory didn't exist */
    if(!dir_inum){
        return -1;
    }

    /* add link */
    if(!dir_link_inum(dir_inum, file_name_buf, old_inum)){
        return -1;
    }

    return 0;
}

/* unlink a file entry */
uint16_t _unlink(uint16_t name, uint16_t a1, uint16_t a2, uint16_t a3){
    /* map in path */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }
    uint16_t dir_inum = fs_path_to_contain_dir(path, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);
    /* probably just a containing directory didn't exist */
    if(!dir_inum){
        return -1;
    }

    if(dir_delete_file(dir_inum, file_name_buf)){
        return -1;
    }

    return 0;
}
