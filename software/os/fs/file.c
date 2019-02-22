#include "include/defs.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include <panic.h>
#include "kernel/panic.h"
#include "dev/dev.h"
#include "dev/devices.h"

//Handles the file table, allowing operations on entries
//This combines buffers, disk_io, block lists and inodes for convienent file access

//File table
struct file_entry file_table[FILE_TABLE_ENTRIES];

/* get a free entry in the file table
 * returns (struct file_entry *) */

struct file_entry * file_alloc(){
    uint16_t i;
    for(i = 0; i < FILE_TABLE_ENTRIES; ++i){
        //no references to the entry
        if(!(file_table[i].refs)){
            return file_table + i;
        }
    }
    panic(PANIC_FILE_TABLE_FULL);
}

/* creates a file table entry from the file table for the given inode number and
 * init the entries values. sets the mode, and inits the file position from mode
 * flags
 * returns (struct file_entry *) - the file entry, or NULL on failure */

struct file_entry * file_get(uint16_t inum, uint8_t mode){
    struct file_entry * res;
    res = file_alloc();
    //Init refs
    res->refs = 1;
    //init mode
    res->mode = mode;
    //set pos to 0 - FILE_MODE_APPEND changes this
    res->pos = 0;
    //get an inode for the inum
    res->ind = inode_get(inum);
    if(!res->ind){
        res->refs = 0;
        return NULL;
    }
    /* if a dev file, don't setup other resources */
    if(res->ind->dev_num){
        return res;
    }
    //truncate if FILE_MODE_TRUNCATE
    if(mode & FILE_MODE_TRUNCATE){
        inode_truncate(res->ind);
    }
    //set pos to end if appending
    if(mode & FILE_MODE_APPEND){
        res->pos = res->ind->size;
    }
    //load a buffer for the first block, adding a block if none are present
    if(!*(res->ind->blks)){
        inode_add_blk(res->ind);
    }
    res->buf = buffer_get(*(res->ind->blks));
    return res;
}

/* inc refs on file entry */
void file_inc_refs(struct file_entry * file){
    file->refs++;
}

/* releases a file table entry, realesing its inode, buffer, and marking it as
 * free in the file table, if it no longer has refrences
 * returns (none) */

void file_put(struct file_entry * file){
    //decrease refs
    --file->refs;
    //remove if no longer referenced
    if(!(file->refs)){
        //release inode
        inode_put(file->ind);
        //release buffer -- only if not dev file
        if(!file->ind->dev_num){
            buffer_put(file->buf);
        }
    }
}

/* release all file pointers
 * returns (none) */

void file_put_all(){
    uint16_t i;
    for(i = 0; i < FILE_TABLE_ENTRIES; ++i){
        file_put(file_table + i);
    }
}

/* set the buffer for a file to the correct one for the pos
 * returns (none) */

void file_set_buf(struct file_entry * file){
    uint16_t blk_i;
    blk_i = (file->pos) >> DISK_BLK_SIZE_EXP;
    while(blk_i >= file->ind->num_blks){
        inode_add_blk(file->ind);
    }
    //set blk_i to be the blk number, not index, to be loaded
    blk_i = (file->ind->blks)[blk_i];
    if(file->buf->blk != blk_i){
        buffer_put(file->buf);
        file->buf = buffer_get(blk_i);
    }
}

/* write bytes bytes from buf into the file file. write flag must be set
 * returns (uint16_t) - the number of bytes written*/
uint16_t file_write_nonblocking(struct file_entry * file, uint8_t * buffer, uint16_t bytes, uint8_t *eof){
    uint16_t bytes_c;

    *eof = 0;
    bytes_c = bytes;
    if(!(file->mode & FILE_MODE_WRITE)){
        *eof = 1;
        return 0;
    }

    /* call dev method if needed */
    if(file->ind->dev_num){
        return devices[file->ind->dev_num]._write(file->ind->dev_minor, buffer, bytes, eof);
    }

    //initial set
    file_set_buf(file);
    while(bytes--){
        if(!(file->pos & DISK_BLK_SIZE_MASK)){
            file_set_buf(file);
        }
        file->buf->buf[(file->pos++)&DISK_BLK_SIZE_MASK] = *(buffer++);
        if(file->pos > file->ind->size){
            file->ind->size = file->pos;
        }
    }
    return bytes_c;
}

/* reads bytes bytes into buf fom the file file. only reads to end of file.
 * returns (uint16_t) - the number of bytes read*/

uint16_t file_read_nonblocking(struct file_entry * file, uint8_t * buffer, uint16_t bytes, uint8_t *eof){
    uint16_t bytes_c;

    *eof = 0;
    bytes_c = bytes;
    if(!(file->mode & FILE_MODE_READ)){
        *eof = 1;
        return 0;
    }

    /* call dev method if needed */
    if(file->ind->dev_num){
        return devices[file->ind->dev_num]._read(file->ind->dev_minor, buffer, bytes, eof);
    }

    //initial set
    file_set_buf(file);
    while(bytes--){
        //if the end of file is reached, return
        if(file->pos >= file->ind->size){
            *eof = 1;
            return bytes_c - (bytes+1);
        }
        if(!(file->pos&DISK_BLK_SIZE_MASK)){
            file_set_buf(file);
        }
        *(buffer++) = file->buf->buf[(file->pos++)&DISK_BLK_SIZE_MASK];
    }
    return bytes_c;
}

/* blocking methods of file read and file write
 * only used by os when os is sure file isn't dev file */
uint16_t file_write(struct file_entry * file, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_in = 0;
    do {
        uint16_t read = file_write_nonblocking(file, buffer, bytes, &eof);
        buffer += read;
        bytes_in += read;
        bytes -= read;
    } while (!eof && bytes);

    return bytes_in;
}
uint16_t file_read(struct file_entry * file, uint8_t * buffer, uint16_t bytes){
    uint8_t eof;
    uint16_t bytes_out = 0;
    do {
        uint16_t read = file_read_nonblocking(file, buffer, bytes, &eof);
        buffer += read;
        bytes_out += read;
        bytes -= read;
    } while (!eof && bytes);

    return bytes_out;
}

/* move the position in the file around. modes: 1-offset from beggining, 2-
 * offset from cur pos, 3-offset from end.
 * returns (uint16_t) the new position */

uint16_t file_seek(struct file_entry * file, int16_t offset, uint8_t mode){
    switch(mode){
    case SEEK_CUR:
        file->pos += offset;
        break;
    case SEEK_END:
        file->pos = file->ind->size + offset;
        break;
    case SEEK_SET: /* seek_set is default */
    default:
        file->pos = offset;
        break;
    }
    //we can read past the end of file
    return file->pos;
}

/* return the position in the file
 * returns (uint16_t) */

uint16_t file_tell(struct file_entry * file){
    return file->pos;
}
