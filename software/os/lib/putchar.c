#define _STDIO_NO_EXTERNS
#include <stdio.h>
//putchar routines for SCP
//Location in text memory
unsigned int _screenpos = 1920;

//Scroll the screen up a line
_screenscroll(){
	unsigned int i;
	unsigned int val;
	for(i = 0; i < 2000; ++i){
		//Read value down one line, or, if on bottom line, set val to clear char
		outp(5,i+80);
		val = (i < 1920) ? inp(6) : 0;
		//And write to current location
		outp(5,i);
		outp(6,val);
	}
	_screenpos = 1920;
}

//Clear the screen
_screenclear(){
	unsigned int i;
	for(i = 0; i < 2000; i++){
		outp(5,i);
		outp(6,0);
	}
	_screenpos = 1920;
}

putchar(unsigned char c){
	if(_screenpos >= 2000){
		_screenscroll();
	}
	if(c == '\n'){
		_screenscroll();
	}
	else if(c == '\t'){
		_screenpos += 8;
	}
	else if(c == 8){
		_screenpos -= 1;
		outp(5, _screenpos);
		outp(6, 0);
	}
	else{
		outp(5,_screenpos++);
		outp(6,c);
	}
}
