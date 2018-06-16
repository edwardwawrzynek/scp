//putchar routines for SCP
//Location in text memory
unsigned int _screenpos = 960;

//Scroll the screen up a line
_screenscroll(){
	unsigned int i;
	unsigned int val;
	for(i = 0; i < 1000; ++i){
		//Read value down one line, or, if on bottom line, set val to clear char
		outp(5,i+40);
		val = (i < 960) ? inp(6) : 0;
		//And write to current location
		outp(5,i);
		outp(6,val);
	}
	_screenpos = 960;
}

putchar(unsigned char c){
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
	if(_screenpos > 1000){
		_screenscroll();
	}
}
