#include <inout.h>
#include <gfx.h>

int color = 0;

void rect(int px, int py, int w, int h, int c){
    for(int x = px; x < px+w; x++){
        for(int y = py; y < py+h; y++){
            gfx_pixel(x,y,c);
        }
    }
}

int pos_x = 0;

int speed = 1;

void run(){
    rect(pos_x-1,100,12,10, 0);
    pos_x+=speed;
    rect(pos_x,100,10,10, color);
    if(pos_x < 0 || pos_x >= 310){
        speed = -speed;
    }
    color++;
    for(int i = 40000; i; i++){
    }
}

int main(){
    while(1)
        run();
}
