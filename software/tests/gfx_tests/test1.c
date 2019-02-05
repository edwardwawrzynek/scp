#include <inout.h>

void gfx_pixel(int x, int y, int color){
    outp(_gfx_addr_port, x + y * 320);
    outp(_gfx_data_port, color);
}

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
