/**
 * Device driver for pipes
 * Isn't really a dev, but uses dev interface for simplicity
 */

#include "dev.h"

#include <lib/inout.h>
#include <stdint.h>
#include "kernel/panic.h"
#include "include/panic.h"
#include "include/defs.h"
#include "lib/kmalloc.h"
#include "fs/file.h"

/* Pipes ignore minor numbers. Instead, the manipulate the pipe structs in the inodes */

/* go through file table, and get the number of readers and writers (number of file table entries) that have the pipe open */
static void pipe_get_read_write(struct inode *ind, uint16_t *read, uint16_t *write){
    *read = 0;
    *write = 0;
    for(uint16_t i = 0; i < FILE_TABLE_ENTRIES; i++){
        if(file_table[i].ind == ind && file_table[i].refs){
            if(file_table[i].mode & FILE_MODE_READ){
                (*read)++;
            }
            if(file_table[i].mode & FILE_MODE_WRITE){
                (*write)++;
            }
        }
    }
}

int _pipe_open(int minor, struct inode *ind){
    /* open a buffer */
    if(ind->pipe.buf != NULL){
        panic(PANIC_PIPE_BUF_ALREADY_OPEN);
    }
    ind->pipe.buf = kmalloc(PIPE_BUF_SIZE);
    ind->pipe.read_pos = 0;
    ind->pipe.write_pos = 0;

    return 0;
}

int _pipe_close(int minor, struct inode *ind){
    /* free buffer */
    kfree(ind->pipe.buf);
    ind->pipe.buf = NULL;
    /* if pipe is unnamed, set links to 0 so that it won't be kept on fs */
    if(!ind->pipe.is_named){
        ind->links = 0;
    }

    return 0;
}

int _pipe_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *ind){
    uint16_t read = 0;
    /* if there is data in pipe, read it */
    if(ind->pipe.read_pos != ind->pipe.write_pos){
        *eof = 0;
        while(ind->pipe.read_pos != ind->pipe.write_pos && read < bytes){
            *(buf++) = ind->pipe.buf[ind->pipe.read_pos++];
            read++;
            /* if we went past the end of buffer, return to beginning */
            if(ind->pipe.read_pos >= PIPE_BUF_SIZE){
                ind->pipe.read_pos = 0;
            }
        }

        return read;
    } else {
        /* make sure there are still writers */
        uint16_t oread, owrite;
        pipe_get_read_write(ind, &oread, &owrite);
        if(owrite == 0){
            *eof = 1;
            return 0;
        } else {
            /* just waiting for data to come in */
            *eof = 0;
            return 0;
        }
    }
}

/* return true if next write wouldn't overwrite next read */
static int pipe_space_left(struct inode *ind){
    if(ind->pipe.write_pos == (ind->pipe.read_pos-1)){
        return 0;
    }
    if(ind->pipe.write_pos == PIPE_BUF_SIZE-1 && ind->pipe.read_pos == 0){
        return 0;
    }

    return 1;
}

int _pipe_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof, struct inode *ind){
    uint16_t written = 0;
    /* if there is space left in pipe, use it */
    if(pipe_space_left(ind)){
        *eof = 0;
        while(pipe_space_left(ind) && written < bytes){
            ind->pipe.buf[ind->pipe.write_pos++] = *(buf++);
            written++;
            /* if we went past the end of buffer, return to beginning */
            if(ind->pipe.write_pos >= PIPE_BUF_SIZE){
                ind->pipe.write_pos = 0;
            }
        }

        return written;
    } else {
        /* make sure there are still readers */
        uint16_t oread, owrite;
        pipe_get_read_write(ind, &oread, &owrite);
        if(oread == 0){
            /* TODO: send signal to proc trying to write */
            *eof = 1;
            return 0;
        } else {
            /* just waiting for data to be read */
            *eof = 0;
            return 0;
        }
    }
}

int _pipe_ioctl(int minor, int req_code, uint8_t * arg, struct inode *ind){
    /* pipes don't support ioctl */
    return -1;
}