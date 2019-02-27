#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>
#include <lib/string.h>

#include "serial.h"

/* file descriptor for serial dev */
int serial_fd;
#define BUF_SIZE 128
/* serial dev buffer */
uint8_t in_buffer[BUF_SIZE];
/* index in buffer */
uint16_t in_buf_index;

/* read and write data to serial port */

/* read in a whole buffer */
void _read_buf(){
    if(read(serial_fd, in_buffer, BUF_SIZE) != BUF_SIZE){
        /* abort */
        test_syscall("serial read failure",0,0,0);
    }

    /* write out buf to confirm we got it */
    if(write(serial_fd, in_buffer, BUF_SIZE) != BUF_SIZE){
        /* abort */
        test_syscall("serial write failure",0,0,0);
    }

    in_buf_index = 0;
}

uint8_t _read_byte(){
    if(in_buf_index >= BUF_SIZE){
        _read_buf();
    }
    return in_buffer[in_buf_index++];
}

uint16_t _read_word(){
    return _read_byte() + (_read_byte() << 8);
}

void _read_bytes(uint16_t bytes, uint8_t * buf){
    while(bytes--){
        *(buf++) = _read_byte();
    }
}

void _read_file(struct file * file){
    _read_bytes(FILE_NAME_LEN, file->name);

    file->bytes = _read_word();
    file->is_dir = _read_byte();
    file->is_executable = _read_byte();
    file->num_files = _read_word();

    _read_bytes(DIR_MAX_FILES * sizeof(uint16_t), (uint8_t *)file->files);
}

/**
 * SCP Program to recive files and directories over the serial port */

struct file files[MAX_FILES];

void read_files(){
    /* read number of files */
    uint16_t num_files = _read_word();
    /* read in file headers */
    for(uint16_t i = 0; i < num_files; i++){
        _read_file(&files[i]);
        /* print name - just for testing */
        test_syscall("File Name: %s\n", files[i].name, 0, 0);
    }
}

int main(){
    /* open serial port */
    serial_fd = open("/dev/serial0", O_RDWR);
    /* make sure it is open */
    if(serial_fd == -1){
        return 1;
    }
    /* Read files */
    read_files();

    while(1);
}

