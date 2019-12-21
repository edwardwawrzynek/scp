#include <inout.h>
#include <gfx.h>

gfx_t * window;

int16_t x = 0, y = 0, dx = 2, dy = 1;

uint16_t width = 10, height = 10;

void run(){
    gfx_rect(window, x, y, width, height, gfx_orange);
    x += dx;
    y += dy;
    if(x < 0 || x + width >= gfx_width(window)) dx = -dx;

    if(y < 0 || y + height >= gfx_height(window)) dy = -dy;
    gfx_rect(window, x, y, width, height, gfx_blue);

    gfx_throttle(1);
}

int main(){
    window = gfx_new_window();
    gfx_background(window, gfx_orange);
    while(1)
        run();
}
