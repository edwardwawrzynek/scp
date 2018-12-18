//#include <stdio.h>

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7
#define serial_data_in_port 1
#define serial_next_port 1
#define serial_in_waiting_port 2
#define serial_data_out_port 3
#define serial_tx_busy_port 4
#define _text_addr_port 5
#define _text_data_port 6
#define _gfx_addr_port 9
#define _gfx_data_port 10

unsigned int screenpos = 0;

//inout
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

//Write, block till the tx is not busy to send
serial_write(unsigned char c){
	while(inp(serial_tx_busy_port)){};
	outp(serial_data_out_port, c);
}

putchar(unsigned char c){
	outp(_text_addr_port, screenpos++);
	outp(_text_data_port, c);
}

puts(unsigned char * c){
	while(*c){
		putchar(*(c++));
	}
}

clear_txt(){
	unsigned int i;
	for(i = 0; i < 64000; ++i){
		outp(_gfx_addr_port, i);
		outp(_gfx_data_port, 0);
	}
}

clear(){
	unsigned int i;
	for(i = 0; i < 2000; ++i){
		outp(_text_addr_port, i);
		outp(_text_data_port, 0);
	}
	clear_txt();
}

main(){
	unsigned char c;
	unsigned char * pos;
	unsigned char state;
	screenpos = 0;
	pos = 0;
	state = 0;

	//clear keyboard buffer
	while(inp(_key_in_waiting_port)){outp(_key_next_port, 1);}

	clear();
	puts("SCP Serial Bootloader Version 1.0");
	screenpos = 80;
	while(1){
		c = serial_read();
		serial_write(c);
		*(pos++) = c;
		if(c == 0x00 && state == 3){
		clear_txt();
		_asm("\n\
			jmp 	#0\n\
		");
		}
		if(c == 0xf0){state=1;}
		else if(c == 0x0f && state == 1){state=2;}
		else if(c == 0xff && state == 2){state=3;}
		else{state = 0;}
		if(pos % 256 == 0){
			putchar('.');
		}
	}
}
