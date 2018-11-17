#include <iostream>

#include "serial.h"
#include "ports.h"

/**
 * open a serial port */
void SerialIO::open(char * file){
    /* set path */
    if(sp_get_port_by_name(file, &serial_port) != SP_OK){
        std::cout << "scpemu: no such serial port: " << file << "\n";
        exit(1);
    }
    /* open */
    if(sp_open(serial_port, SP_MODE_READ_WRITE) != SP_OK){
        std::cout << "scpemu: error opening serial port: " << file << "\n";
        exit(1);
    }
    /* set baud */
    sp_set_baudrate(serial_port,115200);
}

/**
 * write a byte to the port */
void SerialIO::write(char val){
    /* write out, don't block */
    sp_nonblocking_write(serial_port, &val, 1);
}

/**
 * get the number of bytes waiting */
uint16_t SerialIO::waiting(){
    return sp_input_waiting(serial_port);
}

/**
 * read a byte */
uint8_t SerialIO::read(){
    char c;
    sp_blocking_read(serial_port, &c, 1, 0);
    return c;
}

/**
 * read any waiting bytes into the buffer */
void SerialIO::update(){
    while(waiting()){
        buf[write_pos++] = read();
    }
}

/**
 * handle io reads and writes to serial subsytem */
uint16_t SerialIO::io_read(uint8_t port){
    update();

    switch(port){
        case _serial_data_in_port:
            return buf[read_pos];

        case _serial_in_waiting_port:
            return write_pos - read_pos;

        case _serial_tx_busy_port:
            /* not exactly accurate to hardware, but still sets busy port high while bytes are being written */
            return sp_output_waiting(serial_port) ? 1 : 0;

        default:
            /* these ports don't do anything on read */
            break;
    }
}

void SerialIO::io_write(uint8_t port, uint16_t val){
    update();

    switch(port){
        case _serial_next_port:
            read_pos++;
            break;

        case _serial_data_out_port:
            write(val);
            break;

        default:
            /* these ports don't do anything on write */
            break;
    }
}