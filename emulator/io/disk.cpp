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

void DiskIO::io_write(uint8_t port, uint16_t val){};
uint16_t DiskIO::io_read(uint8_t port){};