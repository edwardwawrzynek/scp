#include <stdio.h>
#include <gfx.h>
#include <stdint.h>

fractal(int16_t x, int16_t y){
	unsigned int i;
	int16_t tempX;
	int16_t cx;
	int16_t cy;
	cx = x;
	cy = y;
	for(i = 0; i < 64; ++i){
		tempX = x;
    x = (((x>>4)*(x>>4)))-(((y>>4)*(y>>4))) + cx;
    y = (((((32*(tempX>>4)))>>4)*(y>>4))) + cy;
    if(((((x>>4)*(x>>4))) + (((y>>4)*(y>>4)))) > 1024){
      return i*i;
    }
	}
	return 0;
}

main(){
	unsigned int x;
	unsigned int y;
	int16_t zx;
	int16_t zy;

	//clear
	_screenclear();
	gfx_background(255);
	//draw

	zx = -600;
	zy = -300;
	for(y = 0; y < 200; ++y){
		zx = -600;
		for(x = 0; x < 320; ++x){
			gfx_pixel(x, y, fractal(zx, zy));
			zx += 3;
		}
		zy += 3;
	}
	gfx_text("SCP\nMandelbrot", 0, 23);

}
