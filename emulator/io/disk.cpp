#include <cstdint>
#include <iostream>
#include <fstream>

#include <string.h>

#include "disk.h"
#include "ports.h"

void DiskIO::reset(){
    blk_addr = 0;
    blk_mem_addr = 0;

    memset(blk_mem, 0, sizeof(blk_mem));
}

void DiskIO::open(char *path){
    disk_file.open(path, std::ios::in | std::ios::out | std::ios::binary);

    if(disk_file.fail()){
        std::cout << "scpemu: no such disk file: " << path << "\n";
        exit(1);
    }
}

void DiskIO::close(){
    disk_file.close();
}

/* read and write to the disk ports */
void DiskIO::io_write(uint8_t port, uint16_t val){
    switch(port){
        //set blk
        case _disk_block_addr_port:
            blk_addr = val;
            break;
        //read off the disk - don't try to emulate speed of actual hardware
        case _disk_data_in_rd_en_port:
            //seek to place
            disk_file.seekg(((long)blk_addr)*512);
            //read
            disk_file.read((char *)blk_mem, 512);
            if(disk_file.fail()){
                std::cerr << "scpemu: disk read failed\n";
                exit(1);
            }
            blk_mem_addr = 0;
            break;

        //move to next data point
        case _disk_data_in_next_port:
            blk_mem_addr++;
            if(blk_mem_addr >= 512){
                blk_mem_addr = 0;
            }
            break;

        //write to disk
        case _disk_data_out_wr_en_port:
            //seek
            disk_file.seekp(((long)blk_addr)*512);
            //write
            disk_file.write((char *)blk_mem, 512);
            if(disk_file.fail()){
                std::cerr << "scpemu: disk write failure\n";
            }
            blk_mem_addr = 0;
            break;

        //write to buffer
        case _disk_data_out_port:
            blk_mem[blk_mem_addr++] = val;
            if(blk_mem_addr >= 512){
                blk_mem_addr = 0;
            }
            break;

        //don't care about disk reset */
        case _disk_reset_port:
            break;

        default:
            //not an output port
            break;
    }
};

uint16_t DiskIO::io_read(uint8_t port){
    switch(port){
        /* get current char in buffer */
        case _disk_data_in_port:
            return blk_mem[blk_mem_addr];

        /* get position in buffer (read and write are combined in emulation) */
        case _disk_data_out_addr_port:
        case _disk_data_in_addr_port:
            return blk_mem_addr;

        /* always return disk success */
        case _disk_error_port:
            return 0;
    }
    return 0;
};