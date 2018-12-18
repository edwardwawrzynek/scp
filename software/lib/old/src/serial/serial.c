#include "serial.h"

serial_in_waiting(){
	return inp(serial_in_waiting_port);
}

//Return -1 if no data is waiting
serial_async_read(){
	int c;
	if(serial_in_waiting()){
		c = inp(serial_data_in_port);
		outp(serial_next_port, 1);
		return c;
	}
	return -1;
}

//Read, block until char ready
serial_read(){
	int c;
	do{
		c = serial_async_read();
	} while(c == -1);
	return c;
}

//Write, returning -1 if tx busy
serial_async_write(unsigned char c){
	if(inp(serial_tx_busy_port)){
		return -1;
	}
	outp(serial_data_out_port, c);
}

//Write, block till the tx is not busy to send
serial_write(unsigned char c){
	while(inp(serial_tx_busy_port)){};
	outp(serial_data_out_port, c);
}
