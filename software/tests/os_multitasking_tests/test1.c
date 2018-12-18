#include <gfx.h>
#include <stdio.h>
#include <stdlib.h>

main(){
    char color;
    unsigned char x, dx, y, dy;
    x = 10;
    dx = 2;
    y = 10;
    dy = 1;
    while(1){
        color = rand();
        gfx_rect_fill(0,0,60,60,0);
        gfx_rect_fill(x,y,30,30,color);
        x += dx;
        y += dy;
        if(x <= 2 || x > 20){
            dx = -dx;
        }
        if(y <= 2 || y > 20){
            dy = -dy;
        }
    }
}
