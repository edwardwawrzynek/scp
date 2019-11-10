#include <inout.h>
#include <gfx.h>

int color = 0;

void run(){
    for(int x = 0; x < 320; x++){
        for(int y = 0; y < 12; y++){
            gfx_pixel(x,y,color);
        }
    }
    for(int i = 1; i; i++){
        for(int g=0; g < 2; g++);
    }
    color++;
}

int main(){
    while(1)
        run();
}
