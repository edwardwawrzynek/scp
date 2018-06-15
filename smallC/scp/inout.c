//inout
outp(unsigned char pno, unsigned int val){
	//Load pno into a
  pno;
	//Switch a and b, putting pno into b
	#asm
	xswp	
	#endasm
	//Load val into a
  val;
	//Write out
	#asm
	outa	
	#endasm
}

inp(unsigned char pno){
	//Load pno into a
	pno;
	//Switch a and b, putting pno into b, and call ina, putting the value in a for return
	#asm
	xswp	
	ina 	
	#endasm
}
