#include <stdio.h>
#include <string.h>
#include <gfx.h>
#include <stdlib.h>

triangle(unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2, unsigned int n){
	unsigned int m0x, m0y, m1x, m1y, m2x, m2y;
	if(n > 5){return 0;}
	gfx_triangle_stroke(x0, y0, x1, y1, x2, y2, gfx_orange);
	m0x = (x0+x1)/2;
	m0y = (y0+y1)/2;

	m1x = (x0+x2)/2;
	m1y = (y0+y2)/2;

	m2x = (x1+x2)/2;
	m2y = (y1+y2)/2;
	triangle(x0, y0, m0x, m0y, m1x, m1y, n+1);
	triangle(x1, y1, m0x, m0y, m2x, m2y, n+1);
	triangle(x2, y2, m1x, m1y, m2x, m2y, n+1);

}

main(){
	unsigned int i;
	unsigned int x;
	unsigned int y;
	//Sierpinski Triangle
	gfx_clearscreen();
	gfx_text("Sierpinski\n Triangle", 30, 14);
	gfx_text("Press\n A Key", 34, 17);
	triangle(45, 199, 160, 1, 275, 199, 0);
	_key_press_read();
	gfx_background(gfx_red);
	_screenclear();
	//Cool mesh
	x = 200;
	for(y = 0; y < 200; y+=8){
		x-=8;
		gfx_line(0,y,x,0,gfx_turquoise);
	}
	x = 120;
	for(y = 0; y < 200; y+=8){
		x+=8;
		gfx_line(x,0,319,y,gfx_turquoise);
	}
	x = 0;
	for(y = 0; y < 200; y+=8){
		x+=8;
		gfx_line(0,y,x,199,gfx_turquoise);
	}
	x = 320;
	for(y = 0; y < 200; y+=8){
		x-=8;
		gfx_line(319,y,x,199,gfx_turquoise);
	}
	gfx_text("Some Lines", 30, 14);
	gfx_text("Press\nA Key", 34, 16);
	_key_press_read();
	_screenclear();
	for(x = 0; x < 64000; ++x){
		outp(9, x);
		outp(10, rand());
	}
	gfx_text("Pseudo Randomness", 26, 14);
	gfx_text("Press A Key", 32, 16);
	_key_press_read();
	_screenclear();
	gfx_clearscreen();
	gfx_text("Some  Sound", 32, 14);
	gfx_text("Press A Key", 32, 16);
	for(x = 0; x < 65535; x+=255){
		_screenpos = 960;
		printf("Cycle T: %u", x);
		outp(11, x);
		gfx_background(x);
		if(_key_async_press_read() != -1){
			break;
		}
	}
	outp(11, 0);
	_screenclear();
	gfx_clearscreen();
}
