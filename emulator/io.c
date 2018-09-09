#include "stdint.h"
#include "SDL2/SDL.h"
//io port defs
SDL_Window *window;
SDL_Surface *windowSurface;
SDL_Event window_event;

#define IO_key_in_waiting_port 8
#define IO_key_data_in_port 7
#define IO_key_next_port 7

#define IO_text_addr_port 5
#define IO_text_data_port 6

#define IO_gfx_addr_port 9
#define IO_gfx_data_port 10
#define IO_gfx_screen_en_port 12

#define IO_sound_freq_port 11

#define IO_disk_busy_port 13
#define IO_disk_reset_port 13
#define IO_disk_error_port 14
#define IO_disk_block_addr_port 14

#define IO_disk_data_in_port 15
#define IO_disk_data_in_next_port 15
#define IO_disk_data_in_rd_en_port 16
#define IO_disk_data_in_addr_port 16
#define IO_disk_data_out_port 17
#define IO_disk_data_out_wr_en_port 18
#define IO_disk_data_out_addr_port 18

//io subsys vars
uint16_t io_gfx_addr;
uint16_t io_text_addr;
//the character set (64 bits per char)
uint64_t io_charset[256];
//the character memory
uint8_t io_text_mem[2000];
//the keyboard memory
uint16_t io_key_mem[256];
uint8_t io_key_read;
uint8_t io_key_write;

//graphics functions
void init_sdl(char * window_name){
    char name[256];
    sprintf(name, "scpemu - %s", window_name);
    window = SDL_CreateWindow(name, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 400, SDL_WINDOW_SHOWN);
    windowSurface = SDL_GetWindowSurface(window);
}

static inline void sdl_set_pixel(SDL_Surface *surface, int addr, Uint32 pixel)
{
  Uint32 *target_pixel = (Uint8 *) surface->pixels + addr* sizeof *target_pixel;
  *target_pixel = pixel;
}

//convert a keysym
uint16_t io_to_keycode(SDL_Keycode key, uint8_t release){
    uint16_t res;
    res = key;
    switch(key){
        case 1073741904:
            res = 28;
            break;
        case 1073741906:
            res = 29;
            break;
        case 1073741903:
            res = 30;
            break;
        case 1073741905:
            res = 31;
            break;
        case 1073742049:
            res = 16;
            break;
        case 13:
            res = 10;
            break;
        default:
        break;
    }
    res = release ? 0x100 + res : res;
    return res;
}

void sdl_check_events(){
    //update window
    SDL_UpdateWindowSurface(window);

    while( SDL_PollEvent( &window_event ) ){
        if(window_event.type == SDL_QUIT){
            exit(0);
        }
        if(window_event.type == SDL_KEYDOWN){
            io_key_mem[io_key_write++] = io_to_keycode(window_event.key.keysym.sym, 0);
        }
        if(window_event.type == SDL_KEYUP){
            io_key_mem[io_key_write++] = io_to_keycode(window_event.key.keysym.sym, 1);
        }
    }
}

//convert an 8-bit color to Uint32 for sdl
Uint32 color_conv(uint8_t color){
    Uint32 res;
    //red
    res = ((color>>5) & 0b111)<<(16+5);
    //green
    res += ((color>>2) & 0b111)<<(8+5);
    //blue
    res += ((color) & 0b11)<<6;
    return res;
}

//load the charset from file
void io_load_charset(char * file){
    FILE * fp;
    int addr;

    fp = fopen(file, "r");
    if(fp == NULL){
        printf("No such file: %s\n", file);
        exit(1);
    }
    for(addr = 0; addr < 256; ++addr){
        if(fread(io_charset + addr, 1, 8, fp) != 8){
            printf("charset file: %s not formatted properly\n", file);
        }
    }
    fclose(fp);
}

//write a char to the window
void io_text_write_char(uint8_t c, uint16_t addr){
    uint16_t x;
    uint16_t y;

    unsigned int pos;
    int i;

    uint64_t charset;
    Uint32 color;
    //write to memory
    io_text_mem[addr] = c;

    //x and y in terms of text location
    x = addr%80;
    y = addr/80;

    //find pos on screen
    pos = x*8 + (y*16*640);

    charset = io_charset[c];
    for(i = 0; i < 64; ++i){
        color = charset&0x8000000000000000 ? 0xffffff : 0;
        sdl_set_pixel(windowSurface, pos, color);
        sdl_set_pixel(windowSurface, pos+640, color);
        charset = charset << 1;
        pos++;
        if(pos % 8 == 0){
            pos -= 8;
            pos += 1280;
        }
    }
}

//set a "pixel" on the screen (really a 2x2 block)
void io_gfx_set_pixel(uint16_t addr, uint8_t val){
    uint16_t x;
    uint16_t y;
    x = addr%320;
    y = addr/320;

    sdl_set_pixel(windowSurface, x*2 + y*1280, color_conv(val));
    sdl_set_pixel(windowSurface, (x*2 + y*1280) +1, color_conv(val));
    sdl_set_pixel(windowSurface, (x*2 + y*1280) +640, color_conv(val));
    sdl_set_pixel(windowSurface, (x*2 + y*1280) +641, color_conv(val));
}

//handle io
void io_out(uint8_t port, uint16_t val){
    switch(port){
        //text
        case IO_text_addr_port:
            io_text_addr = val;
            break;
        case IO_text_data_port:
            //get char
            io_text_write_char((uint8_t)val, io_text_addr);
            break;
        //gfx
        case IO_gfx_addr_port:
            io_gfx_addr = val;
            break;
        case IO_gfx_data_port:
            io_gfx_set_pixel(io_gfx_addr, val);
            break;
        default:
        break;
    }
}

//read from io
uint16_t io_in(uint8_t port){
    switch(port){
        case IO_text_data_port:
            return io_text_mem[io_text_addr];
        //keyboard
        case IO_key_in_waiting_port:
            return io_key_write - io_key_read;
        case IO_key_data_in_port:
            return io_key_mem[io_key_read++];
        default:
            return 0;
            break;
    }
}