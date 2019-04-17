#include "include/defs.h"
#include "fs/buffer.h"
#include "fs/superblock.h"
#include "fs/balloc.h"
#include "fs/disk.h"
#include "fs/fs.h"

#include "fs/inode.h"

#include <lib/kmalloc.h>

#include <panic.h>
#include "kernel/panic.h"

#include "dev/dev.h"
#include "dev/devices.h"

#include <lib/util.h>
#include <lib/kstdio_layer.h>
#include <lib/string.h>
//TODO: put last allocd inode in superblock for fast new inode alloc

//Inode table
struct inode inode_table[INODE_TABLE_ENTRIES];

/* alloc a free inode from the table - don't adjust refs
 * returns (struct inode *) */

struct inode * inode_alloc(){
    uint16_t i;
    for(i = 0; i < INODE_TABLE_ENTRIES; ++i){
        if(inode_table[i].refs == 0)
        {
            return inode_table + i;
        }
    }

    panic(PANIC_INODE_TABLE_FULL);
}

/* load a disk_inode from disk into the inode pointer, in-core values are left
 * returns (none) */

void inode_load(struct inode * in, uint16_t inum){
    uint16_t blk_num, offset;
    //don't load if inum is higher than number of inodes
    if(inum >= superblk.num_inodes){
        panic(PANIC_INODE_NUMBER_TOO_HIGH);
    }
    //figure out what disk blk the inode is on
    blk_num = INODE_TABLE_ADDR + (inum>>INODES_PER_BLK_EXP);
    offset = (inum & INODES_PER_BLK_MASK) * DISK_INODE_SIZE;
    //read in block with inode
    disk_read(blk_num, fs_global_buf);
    //read in inode from blk
    uint8_t *buf = fs_global_buf+offset;


    in->links = _read_byte(&buf);
    in->flags = _read_byte(&buf);
    in->dev_num = _read_byte(&buf);
    in->size = _read_word(&buf);
    in->disk_blk = _read_word(&buf);
    in->dev_minor = _read_byte(&buf);

}

/* write a disk_inode to disk - just copies values, no other processing
 * returns (none) */

void inode_write(struct inode * in, uint16_t inum){
    uint16_t blk_num, offset;
    //don't load if inum is higher than number of inodes
    if(inum >= superblk.num_inodes){
        panic(PANIC_INODE_NUMBER_TOO_HIGH);
    }
    //figure out what disk blk the inode is on
    blk_num = INODE_TABLE_ADDR + (inum>>INODES_PER_BLK_EXP);
    offset = (inum & INODES_PER_BLK_MASK) * DISK_INODE_SIZE;
    //read in block with inode
    disk_read(blk_num, fs_global_buf);
    //copy inode to buffer
    uint8_t *buf = fs_global_buf+offset;

    _write_byte(&buf, in->links);
    _write_byte(&buf, in->flags);
    _write_byte(&buf, in->dev_num);
    _write_word(&buf, in->size);
    _write_word(&buf, in->disk_blk);
    _write_byte(&buf, in->dev_minor);

    //write out
    disk_write(blk_num, fs_global_buf);
}

/* gets an inode in the inode table for a specified inum, loading in a new one
 * if nessesary, setting in-core values
 * also, open dev if not open already
 * returns (struct inode *) - the inode, or NULL on failure */

struct inode * inode_get(uint16_t inum){
    uint16_t i;
    struct inode * res;
    //check if it is already loaded
    for(i = 0; i < INODE_TABLE_ENTRIES; ++i){
        //Make sure the entry has at least 1 ref, or else inode 0 will be falsly
        //returned on any free entry
        if(inode_table[i].inum == inum && inode_table[i].refs)
        {
            //inc refs
            ++inode_table[i].refs;
            return inode_table + i;
        }
    }
    //get a new inode
    res = inode_alloc();
    //read in data
    inode_load(res, inum);
    //if the inode is not marked as in use, return failure
    if(!(res->links)){
        return NULL;
    }
    //set refs
    res->refs = 1;
    //set inum
    res->inum = inum;
    //load block list
    res->blks = balloc_get(res->disk_blk, &(res->num_blks));
    //if blks is null, the disk_blk is an invalid block
    if(res->blks == NULL){
        //probably due to an inum of 0 or 1
        inode_put(res);
        return NULL;
        //panic(PANIC_INODE_REFS_BAD_BLOCK);
    }
    /* set pipe info */
    res->pipe.buf = NULL;
    res->pipe.read_pos = 0;
    res->pipe.write_pos = 0;
    /* set to be named by default
     * if pipe is created by pipe syscall, this will be set to be 0 explicitly */
    res->pipe.is_named = 1;
    /* open dev */
    if(res->dev_num){
        if(devices[res->dev_num]._open(res->dev_minor, res)){
            inode_put(res);
            return NULL;
        }
    }
    return res;
}

/* releases an inode, and, if its ref count is zero, deallocates its blk list,
 * writes it to disk, and frees the in-core copy for future use
 * returns (none) */

void inode_put(struct inode * in){
    //dec references
    --in->refs;
    //if the inode is no longer referenced, free it
    //if we are keeping inode entries open, don't do this until needed, unless the inode no longer has any links to it (and no refs)
    if(!in->refs){
        inode_force_put(in);
    }
}

/* releases an inode, regardless of its refs count - shouldn't be called directly
 * if the inode has a zero link count, it is deleted off disk
 * returns (none) */

void inode_force_put(struct inode * in){
    //only write if the inode has a blk list set, meaning it is in use.
    if(in->blks){
        kfree(in->blks);
        /* close dev */
        if(in->dev_num){
            devices[in->dev_num]._close(in->dev_minor, in);
        }
        //mark blocks as null for use with
        in->blks = NULL;
        /* check if we need to delete the inum */
        if(!in->links){
            inode_delete(in->inum);
        } else {
            inode_write(in, in->inum);
        }
    } else {
        panic(PANIC_INODE_PUT_ON_NON_OPENED_INODE);
    }
}

/* release all inodes
 * returns none */

void inode_put_all(){
    uint16_t i;
    for(i = 0; i < INODE_TABLE_ENTRIES; ++i){
        /* make sure the inode is loaded */
        if(inode_table[i].blks){
            inode_force_put(inode_table+i);
        }
    }
}

/* adds a block to an in-core inode - this writes the new list to disk to stop
 * balloc_alloc() from returning the block twice.
 * returns (none) - the new blk number should be accessed through the blks list */

void inode_add_blk(struct inode * ind){
    //The old size alloc'd
    uint16_t old_size;
    uint16_t *i;
    //figure out the current size
    old_size = 0;
    i = ind->blks;
    do{++old_size;} while(*(i++));
    //realloc
    ind->blks = krealloc(ind->blks, (old_size+1)<<1);
    //set the new blk
    (ind->blks)[old_size-1] = balloc_alloc();
    //set last item as zero
    (ind->blks)[old_size] = 0;
    //inc number of blks
    ++ind->num_blks;
    //write to disk to mark block as used
    balloc_put(ind->blks);
}

/* truncate an inode, setting its size to zero, freeing its blocks, assigning
 * it a first starting block, and setting num_blks
 * returns (none) */

void inode_truncate(struct inode * ind){
    uint16_t blks[2];
    uint16_t *i;
    //set size
    ind->size = 0;
    //free blks
    balloc_free(ind->disk_blk);
    //add a block
    ind->disk_blk = balloc_alloc();
    blks[0] = ind->disk_blk;
    blks[1] = 0;
    balloc_put(blks);
    kfree(ind->blks);
    ind->blks = balloc_get(ind->disk_blk, &(ind->num_blks));
}

/* creates a new inode on disk, init'ing its links, disk_blk, links, and size
 * properties, and setting its dev_num and flags from args. Sets links to 1
 * this function assumes that any inode with links clear doesn't have any blks
 * or other resources allocated to it
 * returns (uint16_t) - the inum of the new inode */

uint16_t inode_new(uint16_t dev_num, uint8_t flags, uint8_t dev_minor){
    uint16_t i;
    struct inode ind;
    uint16_t blks[2];
    //search the disk for a free inode, using inode_load
    //TODO:this is VERY INEFFICIENT
    for(i = 0; i < superblk.num_inodes; ++i){
        inode_load(&ind, i);
        if(!ind.links){
            //This inode is good
            //mark it as in use
            ind.links = 1;
            ind.size = 0;
            //set args
            ind.dev_num = dev_num;
            ind.dev_minor = dev_minor;
            ind.flags = flags;
            //init a block
            ind.disk_blk = balloc_alloc();
            //write block as in use
            blks[0] = ind.disk_blk;
            blks[1] = 0;
            balloc_put(blks);
            //write inode to disk
            inode_write(&ind, i);
            //return inum
            return i;
        }
    }
    //no free inodes
    panic(PANIC_NO_FREE_INODES);
}

/* deletes an inode from disk,  setting its links to 0,
 * and freeing all of the blocks alloc'd to it. This function deletes the inode
 * regardless of if it is being used
 * returns (none) */

void inode_delete(uint16_t inum){
    struct inode ind;
    //load inode
    inode_load(&ind, inum);
    //clear some values
    ind.links = 0;
    ind.size = 0;
    //free blks
    balloc_free(ind.disk_blk);
    //write to disk
    inode_write(&ind, inum);

}
