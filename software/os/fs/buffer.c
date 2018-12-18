#include "include/defs.h"
#include "fs/incl.h"
#include "lib/incl.h"

//Disk buffer operations

//buffer table
struct buffer_header buffer_table[BUFFER_TABLE_ENTRIES];

/**
 * get an unused buffer table entry with a malloc'd buffer, and set its blk prop
 * returns (struct buffer_header*) */
buffer_alloc(uint16_t blk){
    uint16_t i;
    //search table for free buffer
    for(i = 0; i < BUFFER_TABLE_ENTRIES; ++i){
        if(!buffer_table[i].refs){
            //malloc buffer
            buffer_table[i].buf = kmalloc(DISK_BLK_SIZE);
            //inc refs
            buffer_table[i].refs = 1;
            //set blk
            buffer_table[i].blk = blk;
            //read in data
            disk_read(blk, buffer_table[i].buf);
            return &buffer_table[i];
        }
    }
    panic(PANIC_BUFFER_TABLE_FULL);
}

/**
 * gets a buffer for a disk blk, returning a new one if none for that blk is active
 * returns (struct buffer_header*) */
buffer_get(uint16_t blk){
    uint16_t i;
    for(i = 0; i < BUFFER_TABLE_ENTRIES; ++i){
        if(buffer_table[i].blk == blk && buffer_table[i].refs){
            //inc refs
            ++buffer_table[i].refs;
            return buffer_table + i;
        }
    }
    //return a new one, as none with the block number are open
    return buffer_alloc(blk);
}

/**
 * releases a buffer, writing to disk if there are no active references to it
 * returns none */

buffer_put(struct buffer_header * buf){
    //deincrement refs
    --buf->refs;
    //if no refs, write to disk and free buffer
    if(!buf->refs){
        disk_write(buf->blk, buf->buf);
        kfree(buf->buf);
        buf->buf = NULL;
    }
}

/**
 * flush all of the buffers in the table - for shutdown, etc
 * returns (none) */

buffer_flush_all(){
    uint16_t i;
    for(i = 0; i < BUFFER_TABLE_ENTRIES; ++i){
        if(buffer_table[i].refs){
            disk_write(buffer_table[i].blk, buffer_table[i].buf);
        }
    }
}
