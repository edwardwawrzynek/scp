#include "serial.h"
#include <libserialport.h>
#include <stdio.h>
#include <stdlib.h>

/* Host program to send files and dirs to scp */

struct sp_port * port;

void _write_byte(uint8_t val){
    sp_blocking_write(port, &val, 1, 0);
}

void _write_word(uint16_t val){
    _write_byte(val&0xff);
    _write_byte(val >> 8);
}

void _write_bytes(uint16_t bytes, uint8_t *buf){
    sp_blocking_write(port, buf, bytes, 0);
}

void _write_file(struct file * file){
    _write_bytes(FILE_NAME_LEN, file->name);

    _write_word(file->bytes);
    _write_byte(file->is_dir);
    _write_byte(file->is_executable);
    _write_word(file->num_files);

    _write_bytes(DIR_MAX_FILES * sizeof(uint16_t), (uint8_t *)file->files);
}

struct file files[MAX_FILES];

void write_files(){
    /* TODO: read in file into files */
    uint16_t num_files = 2;

    /* send number of files */
    _write_word(num_files);
}

int main(int argc, char **argv){
    if(argc!=2){
        printf("Usage: scpftp serial_port\n");
        exit(1);
    }
    /* find port */
    if(sp_get_port_by_name(argv[1], &port) != SP_OK){
        printf("No such serial port: %s\n", argv[1]);
        exit(1);
    }
    /* open */
    if(sp_open(&port, SP_MODE_READ_WRITE) != SP_OK){
        printf("Error opening serial port: %s\n", argv[1]);
        exit(1);
    }
    sp_set_baudrate(port, 115200);
    /* wite files */
    write_files();

}
