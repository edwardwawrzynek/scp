#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"

#include "include/panic.h"
#include "kernel/panic.h"

/* file modes */
#define O_RDONLY 1 /* read only mode */
#define O_WRONLY 2 /* write only mode */
#define O_RDWR 3   /* read and write mode */
#define O_APPEND 8 /* start at end of file for writing */
#define O_CREAT 16 /* create file if it doesn't exist (don't do anything if it already does) */
#define O_TRUNC 32 /* truncate file to length 0 */
#define O_EXCL 64  /* fail if O_CREAT is set and file already exists */

/* Open a file, and return its file descriptor */
int16_t _open(uint16_t name, uint16_t flags, uint16_t a2, uint16_t a3){
    printf("Name: %u, Flags: %u\n", name, flags);
    uint16_t fd = proc_next_open_fd(proc_current_proc);

    char * path = kernel_map_in_mem((uint8_t *) name, proc_current_proc);
    printf("Mapped in: %u, %s, cwd: %u, croot: %u\n", path, path, proc_current_proc->cwd, proc_current_proc->croot);
    /* find file */
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
        printf("opening, inum: %u\n", inum);
    if(!inum){
        printf("returning\n");
        /* TODO: handle O_CREAT flag with creat system call */
        return -1;
    }
    uint16_t mode = 0;
    /* handle r/w modes (O_RDWR is handled by being O_RDONLY | O_WRONLY) */
    if(flags & O_RDONLY){
        mode |= FILE_MODE_READ;
    }
    if(flags & O_WRONLY){
        mode |= FILE_MODE_WRITE;
    } else {
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
    proc_current_proc->files[fd] = file;

    return fd;
}