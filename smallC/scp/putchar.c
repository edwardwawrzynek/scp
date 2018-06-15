//putchar routines for SCP
//Location in text memory
unsigned int Xscreenpos = 960;

//Scroll the screen up a line
Xscreenscroll(){
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
	Xscreenpos = 960;
}

putchar(unsigned char c){
	if(c == '\n'){
		Xscreenscroll();
	}
	else if(c == '\t'){
		Xscreenpos += 8;
	}
	else{
		outp(5,Xscreenpos++);
		outp(6,c);
	}
	if(Xscreenpos >= 1000){
		Xscreenscroll();
	}
}
