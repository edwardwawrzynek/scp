//Not implemented
#include <stdio.h>

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7

//retur number of keys in waiting
_key_in_waiting(){
	return inp(_key_in_waiting_port);
}

//Return -1 if none in waiting, return raw (including release) key otherwise
_key_async_read(){
	unsigned int c;
	if(_key_in_waiting()){
		c = inp(_key_data_in_port);
		outp(_key_next_port, 1);
		return c;
	}
	return -1;		 
}

//Block until a key is ready, and return its raw (may be a release) value
_key_read(){
	unsigned int c;
	do{
		c = _key_async_read();
	} while(c == -1);
	return c;
}

//Block until a press is ready, and return its value
_key_press_read(){
	unsigned int c;
	do {
		c = _key_read();
	}
	while (c & 0x0100);
	return c;
}

//If true, getchar prints the chars it recives

unsigned char _getcharecho = 1;
//if shift is being pressed
unsigned char _getcharshifted = 0;

//Block until a char is recived, echo it (depends on _getcharecho), and apply formatting (shifts)
#define _keyshifted ""
getchar(){
	char * shifted;
}
