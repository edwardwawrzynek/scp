#include "include/defs.h"
#include "fs/disk.h"
#include "fs/superblock.h"

#include <lib/kmalloc.h>
#include <lib/string.h>

#include <panic.h>
#include "kernel/panic.h"
#include <lib/kstdio_layer.h>

//TODO: store last allocd block in superblock for fast allocd

//Manipulates the on disk block linked list, and manages file block allocation
//block linked list format is described in include/fs.h

//buffer for operations - all operations use ints
uint16_t balloc_buffer[256];
uint16_t balloc_get_buf[129];
//disk_read and disk_write are used instead of buffer.c operations beacuse these are the only methods that should touch the block ll


/**
 * gets the first free block number (starts at superblk.first_blk)
 * returns (uint16_t) */
uint16_t balloc_alloc(){
    uint16_t index;
    uint16_t value;
    //Read in buffer to start
    disk_read(superblk.first_blk>>8, (uint8_t *)balloc_buffer);
    for(index = superblk.first_blk; index < 65535; ++index){
        //Read in disk if on a new block
        if(!(index&0xff)){
            disk_read(index>>8, (uint8_t *)balloc_buffer);
        }
        value = balloc_buffer[index&0xff];
        if(value == 0){
            return index;
        }
    }
    panic(PANIC_DISK_BLOCK_LL_FULL);
}

/**
 * write out a list of blocks to disk, with the list terminated by a value of 0
 * returns (none) */

void balloc_put(uint16_t * blocks){
    uint16_t blk_num, offset, lastpos;
    lastpos = *(blocks++);
    while(*blocks){
        //Get addr to write to
        blk_num = lastpos>>8;
        offset=lastpos&0xff;
        //Read in blk
        disk_read(blk_num, (uint8_t *) balloc_buffer);
        //Edit the entry, only writing if the data is new
        if(balloc_buffer[offset] != *blocks){
            balloc_buffer[offset] = *blocks;
            //Write to disk
            disk_write(blk_num, (uint8_t *) balloc_buffer);
        }
        lastpos = *(blocks++);
    };
    //Write out a 1 in the last block
    blk_num = lastpos>>8;
    offset=lastpos&0xff;
    //Read in blk
    disk_read(blk_num, (uint8_t *) balloc_buffer);
    if(balloc_buffer[offset] != 1){
        balloc_buffer[offset] = 1;
        //Write to disk
        disk_write(blk_num, (uint8_t *) balloc_buffer);
    }
}

/**
 * get a list of the blks that an inode occupies (including first_blk), the list
 * being terminated by a 0. The list is kmalloc'd. num_blks is set
 * returns (uint16_t *) - pointer to the list */

uint16_t *balloc_get(uint16_t first_blk, uint8_t * num_blks){
    uint16_t i;
    uint16_t * res;
    i = 1;
    balloc_get_buf[0] = first_blk;
    //set first blk
    while(1){
        //Read in buffer
        disk_read(first_blk>>8, (uint8_t *) balloc_buffer);
        //Set balloc_get_buf, and first_blk
        first_blk = balloc_buffer[first_blk&0xff];
        //if 0, the block doesn't refernce a used block - 0xffff is unusable blk
        if(!first_blk || first_blk == 0xffff){
            return NULL;
        }
        //If 1, the end of file has been reached
        if(first_blk == 1){
            if(i >= 129){
                panic(PANIC_LOAD_FILE_SIZE_TOO_BIG);
            }
            //don't count zero in num_blks
            *num_blks = i;
            balloc_get_buf[i++] = 0;
            res = kmalloc(i<<1);
            memcpy(res, balloc_get_buf, i<<1);
            return res;
        }
        balloc_get_buf[i++] = first_blk;
    }
}

/**
 * free all of the blocks associated with a starting block. Used in deleting and
 * trunctuating files, etc. Operates on disk, not on lists malloc'd or free'd by
 * balloc_get and balloc_put
 * returns (none) */

void balloc_free(uint16_t blk){
    uint16_t nxt;
    do{
        //Read block into buffer
        disk_read(blk>>8, (uint8_t *)balloc_buffer);
        //record next blk
        nxt = balloc_buffer[blk&0xff];
        //mark as free
        balloc_buffer[blk&0xff] = 0;
        //write to disk
        disk_write(blk>>8, (uint8_t *) balloc_buffer);
        //set blk
        blk = nxt;
    } while (blk && blk != 1 && blk != 0xffff);
}
