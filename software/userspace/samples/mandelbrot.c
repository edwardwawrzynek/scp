#include <inout.h>
#include <stdint.h>
#include <gfx.h>

/* convert index in range (0-255) to a color in the rainbow spectrum */
uint8_t rainbow(uint8_t pos) {
  pos = 255 - pos;
  if(pos < 85) {
    return gfx_rgb_to_color(255 - pos * 3, 0, pos * 3);
  }
  if(pos < 170) {
    pos -= 85;
    return gfx_rgb_to_color(0, pos * 3, 255 - pos * 3);
  }
  pos -= 170;
  return gfx_rgb_to_color(pos * 3, 255 - pos * 3, 0);
}

int fractal(int16_t x, int16_t y){
	unsigned int i;
	int16_t tempX;
	int16_t cx;
	int16_t cy;
	cx = x;
	cy = y;
	for(i = 0; i < 128; ++i){
		tempX = x;
    x = (((x>>4)*(x>>4)))-(((y>>4)*(y>>4))) + cx;
    y = (((((32*(tempX>>4)))>>4)*(y>>4))) + cy;
    if(((((x>>4)*(x>>4))) + (((y>>4)*(y>>4)))) > 1024){
      return rainbow(i*10 > 255 ? 255: i*10);
    }
	}
	return 0;
}

int main(){
	struct gfx_inst * window = gfx_get_default_inst();
	unsigned int x;
	unsigned int y;
	int16_t zx;
	int16_t zy;



	zx = -600;
	zy = -300;
	for(y = 0; y < 200; ++y){
		zx = -600;
		for(x = 0; x < 320; ++x){
			gfx_pixel(window, x, y, fractal(zx, zy));
			zx += 3;
		}
		zy += 3;
	}
	getchar();
	gfx_exit(window);

	return 0;

}
