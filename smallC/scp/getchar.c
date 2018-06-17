//Not implemented
#include <stdio.h>

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7

//retur number of keys in waiting
_key_in_waiting(){
	return inp(_key_in_waiting_port);
}

//Return -1 if none in waiting, return raw key otherwise
_key_async_read(){
	unsigned char c;
	if(_key_in_waiting()){
		c = inp(_key_data_in_port);
		outp(_key_next_port, 1);
	}
	return -1;		 
}

//Block until a key is ready, and return its raw value
_key_read(){
	unsigned char c;
	do{
		c = _key_async_read();
	} while(c == -1);
	return c;
}

//If true, getchar prints the chars it recives

unsigned char _getcharecho = 1;

//Block until a char is recived, echo it (depends on _getcharecho), and apply formatting (shifts)
#define _keyshifted ""
getchar(){
	char * shifted;
}
