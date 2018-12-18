//IO Port Routines

outp(unsigned char pno, unsigned int val){
	//Load pno into a
  pno;
	//Switch a and b, putting pno into b
	_asm("\n\
		xswp\n\
	");
	//Load val into a
  val;
	//Write out
	_asm("\n\
		outa\n\
	");
}

inp(unsigned char pno){
	//Load pno into a
	pno;
	//Switch a and b, putting pno into b, and call ina, putting the value in a for return
	_asm("\n\
		xswp\n\
		ina \n\
	");
}
