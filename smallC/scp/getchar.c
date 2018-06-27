//Not implemented
#include <stdio.h>

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

//Return -1 if none in waiting, return pressed key otherwise
_key_async_press_read(){
	unsigned int c;
	if(_key_in_waiting()){
		c = inp(_key_data_in_port);
		outp(_key_next_port, 1);
		return (c & 0x0100) ? -1 : c;
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
		c = _key_async_press_read();
	}
	while (c == -1);
	return c;
}

//If true, getchar prints the chars it recives

unsigned char _getcharecho = 1;
//if shift is being pressed
unsigned char _getcharshifted = 0;

//Block until a char is recived, echo it (depends on _getcharecho), and apply formatting (shifts)
#define _keyshifted " !\"#$%&\"()*+<_>?)!@#$%^&*(::<+>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}^_~ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~"
getchar(){
	char * shifted;
	unsigned int c;
	shifted = _keyshifted;
	while(1){
		c = _key_read();
		//Set _getcharshifted
		if(c == 16){
			_getcharshifted = 1;
			continue;
		}
		if(c == 272){
			_getcharshifted = 0;
			continue;
		}
		//Don't count releases
		if(c & 0x0100){
			continue;
		}
		if(_getcharshifted){
			c = shifted[c-32];
		}
		if(_getcharecho){
			putchar(c);
		}
		return c;
	}
					
}
