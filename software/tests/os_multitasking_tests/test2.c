#include <gfx.h>
#include <stdio.h>
#include <stdlib.h>

main(){
    char color;
    unsigned int x, y;
    x = 280;
    y = 10;
    while(1){
        color = rand();
        gfx_pixel(x, y, color);
        x++;
        if(x > 300){
            x = 280;
            y += 2;
        }
        if(y >= 180){
            y = 10;
        }
    }
}
