#include <inout.h>
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

int main(){
    struct gfx_inst * test = gfx_get_default_inst();
    uint8_t color = 0;
    uint8_t offset = 0;
    gfx_background(test, gfx_white);
    for(int16_t y = 0; y < gfx_height(test); y++) {
        for(int16_t x = 0; x < gfx_width(test); x++) {
            gfx_pixel(test, x, y, rainbow(color++));
        }
        color = offset++;
    }
    getchar();
    gfx_exit(test);
}
