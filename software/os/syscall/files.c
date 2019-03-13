#include "include/defs.h"
#include "kernel/proc.h"
#include "fs/fs.h"
#include "kernel/kernel.h"
#include "fs/file.h"
#include "fs/dir.h"
#include "fs/inode.h"

#include "include/panic.h"
#include "kernel/panic.h"
#include "dev/dev.h"
#include "dev/devices.h"

#include "syscall/files.h"

#include "syscall.h"

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
            return create_file(path, 0, 0);
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

    return create_file(path, 0, 0);
}

/* create a regular, dev, or named pipe */
uint16_t _mknod(uint16_t name, uint16_t mode, uint16_t dev, uint16_t a3){
    char * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }

    /* make sure path doesn't exist */
    if(fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot)){
        return -1;
    }

    uint16_t major = 0, minor = 0;
    if(mode & S_IFDEV){
        major = major(dev);
        minor = minor(dev);
    }
    else if(mode & S_IFIFO){
        major = DEV_NUM_FIFO;
        minor = 1;
    }
    else if(mode & S_IFREG){
        major = 0;
        minor = 0;
    } else {
        /* not a valid mode */
        return -1;
    }

    /* find containing directory */
    uint16_t inum = fs_path_to_contain_dir(path, proc_current_proc->cwd, proc_current_proc->croot, file_name_buf);
    /* probably just a containing directory didn't exist */
    if(!inum){
        return -1;
    }
    /* we know the file doesn't exist, so we can just create it */
    inum = dir_make_file(inum, file_name_buf, major, 0, minor);
    if(!inum){
        return -1;
    }

    return 0;
}

/* create a file, and return its new fd, or -1 on failure */
uint16_t create_file(uint8_t *name, uint16_t dev_num, uint16_t dev_minor){
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
        inum = dir_make_file(inum, file_name_buf, dev_num, 0, dev_minor);
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
    if(fd == -1){
        return -1;
    }
    if(!proc_current_proc->files[fd]){
        return -1;
    }

    file_put(proc_current_proc->files[fd]);
    proc_current_proc->files[fd] = NULL;
    return 0;
}

/* perform an ioctl call on a file descriptor */
uint16_t _ioctl(uint16_t fd, uint16_t cmd, uint16_t arg, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }

    /* only allow ioctl on dev files */
    if(!proc_current_proc->files[fd]->ind->dev_num){
        return -1;
    }

    /* map in arg */
    uint8_t * argp = kernel_map_in_mem((uint8_t *)arg, proc_current_proc);

    return devices[proc_current_proc->files[fd]->ind->dev_num]._ioctl(
        proc_current_proc->files[fd]->ind->dev_minor,
        cmd,
        argp,
        proc_current_proc->files[fd]->ind
    );
}

/* duplicate a file descriptor into an open file descriptor */
uint16_t _dup(uint16_t fd, uint16_t a1, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(fd == -1){
        return -1;
    }
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
    if(old == -1 || new == -1){
        return -1;
    }
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
    if(fd == -1){
        return -1;
    }
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
    if(fd == -1){
        return -1;
    }
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

/* seek to a spot in a file */
uint16_t _lseek(uint16_t fd, uint16_t pos, uint16_t whence, uint16_t a3){
    /* make sure file exists */
    if(fd == -1){
        return -1;
    }
    if(!proc_current_proc->files[fd]){
        return -1;
    }
    /* call seek */
    int res = file_seek(proc_current_proc->files[fd], pos, whence);

    /* file_seek returns -1 on error */
    return res;
}

static void internal_stat(struct inode *in, struct stat * stat){
    stat->st_size = in->size;
    stat->st_ino = in->inum;
    stat->st_nlinks = in->links;
    /* create dev mode */
    if(in->dev_num && in->dev_num != DEV_NUM_FIFO){
        stat->st_dev = makedev(in->dev_num, in->dev_minor);
    } else {
        stat->st_dev = 0;
    }
    /* create modes */
    if(in->flags & INODE_FLAG_DIR){
        stat->st_mode = S_IFDIR;
    }
    else if(in->dev_num == DEV_NUM_FIFO){
        stat->st_mode = S_IFIFO;
    }
    else if(in->dev_num != 0){
        stat->st_mode = S_IFDEV;
    }
    else {
        stat->st_mode = S_IFREG;
    }

    /* set exec flag if needed */
    if(in->flags & INODE_FLAG_EXEC){
        stat->st_mode |= S_IEXEC;
    }

}

/* stat functions on files */
uint16_t _stat(uint16_t name, uint16_t stat_struct, uint16_t a2, uint16_t a3){
    /* map in path */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }
    /* map in struct */
    struct stat * stat = (struct stat *)kernel_map_in_mem2((uint8_t *)stat_struct, proc_current_proc);
    if(!stat){
        return -1;
    }
    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        return -1;
    }
    struct inode *in = inode_get(inum);
    if(!in){
        return -1;
    }

    internal_stat(in, stat);

    inode_put(in);

    return 0;
}

uint16_t _fstat(uint16_t fd, uint16_t stat_struct, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }
    /* map in struct */
    struct stat * stat = (struct stat *)kernel_map_in_mem2((uint8_t *)stat_struct, proc_current_proc);
    if(!stat){
        return -1;
    }

    uint16_t inum = proc_current_proc->files[fd]->ind->inum;
    if(!inum){
        return -1;
    }
    struct inode *in = inode_get(inum);
    if(!in){
        return -1;
    }

    internal_stat(in, stat);

    inode_put(in);

    return 0;
}

/* change permissions on a file (only S_IEXEC flag is applicable) */

static void internal_chmod(struct inode *in, uint16_t mode){
    if(mode & S_IEXEC){
        in->flags |= INODE_FLAG_EXEC;
    } else {
        in->flags &= (~INODE_FLAG_EXEC);
    }
}

uint16_t _chmod(uint16_t name, uint16_t mode, uint16_t a2, uint16_t a3){
    /* map in path */
    uint8_t * path = kernel_map_in_mem((uint8_t *)name, proc_current_proc);
    if(!path){
        return -1;
    }

    uint16_t inum = fs_path_to_inum(path, proc_current_proc->cwd, proc_current_proc->croot);
    if(!inum){
        return -1;
    }
    struct inode *in = inode_get(inum);
    if(!in){
        return -1;
    }

    internal_chmod(in, mode);

    inode_put(in);

    return 0;
}

uint16_t _fchmod(uint16_t fd, uint16_t mode, uint16_t a2, uint16_t a3){
    /* make sure file exists */
    if(!proc_current_proc->files[fd]){
        return -1;
    }

    uint16_t inum = proc_current_proc->files[fd]->ind->inum;
    if(!inum){
        return -1;
    }
    struct inode *in = inode_get(inum);
    if(!in){
        return -1;
    }

    internal_chmod(in, mode);

    inode_put(in);

    return 0;
}

/* create an unamed pipe, and return a read and write end */
uint16_t _pipe(uint16_t fds, uint16_t a1, uint16_t a2, uint16_t a3){
    uint16_t *pipefds = (uint16_t *)kernel_map_in_mem((uint8_t *)fds, proc_current_proc);
    if(!pipefds){
        return -1;
    }
    /* pipefds[0] is read end, pipefds[1] is write end */
    uint16_t inum = inode_new(DEV_NUM_FIFO, 0, 0);
    if(!inum){
        return -1;
    }
    /* make sure it will be deleted when closed */
    struct file_entry *fread = file_get(inum, FILE_MODE_READ);
    struct file_entry *fwrite = file_get(inum, FILE_MODE_WRITE);
    if((!fread) || (!fwrite)){
        return -1;
    }
    fread->ind->pipe.is_named = 0;

    pipefds[0] = proc_set_next_open_fd(proc_current_proc, fread);
    pipefds[1] = proc_set_next_open_fd(proc_current_proc, fwrite);

    return 0;
}