#include "io/serial.h"

/**
 * open a serial port */
void SerialIO::open(char * file){
    /* set path */
    if(sp_get_port_by_name(file, &out_port) != SP_OK){
        printf("scpemu: no such serial port: %s\n", file);
        exit(1);
    }
    /* open */
    if(sp_open(out_port, SP_MODE_READ_WRITE) != SP_OK){
        printf("scpemu: error opening serial port: %s\n", fiel);
        exit(1);
    }
    /* set baud */
    sp_set_baudrate(out_port,115200);
}

/**
 * write a byte to the port */
void SerialIO::write(char val){
    /* write out, with no timeout */
    sp_blocking_write(io_serial_port, &val, 1, 0);
}