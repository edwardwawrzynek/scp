#include "include/io.h"
#include "include/defs.h"
//Basic disk operations

/**
 * init the disk
 * returns (uint16_t) - 0 on sucess, error code on failure */
uint16_t disk_init(){
    outp(_disk_reset_port, 0);
    outp(_disk_reset_port, 1);
    while(inp(_disk_busy_port));
    return inp(_disk_error_port);
}

/**
 * reads a block into the buffer at addr
 * returns (none) */
void disk_read(unsigned int blk, unsigned char * addr){
    //Wait for disk to be done
    while(inp(_disk_busy_port));

    //Set block addr
    outp(_disk_block_addr_port, blk);

    //Start Read
    outp(_disk_data_in_rd_en_port, 1);
    outp(_disk_data_in_rd_en_port, 0);

    //Wait for read to complete
    while(inp(_disk_busy_port));
    //Read data into buffer
    do {
        *(addr++) = inp(_disk_data_in_port);
        //Inc addr
        outp(_disk_data_in_next_port, 0);
    } while(inp(_disk_data_in_addr_port));
}

/**
 * write a buffer at addr to the block at blk */
void disk_write(unsigned int blk, unsigned char * addr){
    //Wait for disk to be done
    while(inp(_disk_busy_port));

    //Set block addr
    outp(_disk_block_addr_port, blk);

    //Write data to hardware buffer
    do{
        outp(_disk_data_out_port, *(addr++));

    } while(inp(_disk_data_out_addr_port));
    //Start write
    outp(_disk_data_out_wr_en_port, 1);
    outp(_disk_data_out_wr_en_port, 0);
}
