#include <stdint.h>
#include "SDL2/SDL.h"

#include <time.h>

#include "charset.c"

//io port defs
SDL_Window *window;
SDL_Surface *windowSurface;
SDL_Event window_event;

#define IO_serial_data_in_port 1
#define IO_serial_next_port 1
#define IO_serial_in_waiting_port 2
#define IO_serial_data_out_port 3
#define IO_serial_tx_busy_port 4

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
//the character memory
uint8_t io_text_mem[2048];
//gfx memory
uint8_t io_gfx_mem[65536];

//the keyboard memory
uint16_t io_key_mem[256];
uint8_t io_key_read;
uint8_t io_key_write;

//disk subsystem
uint16_t io_disk_blk_addr;
uint8_t io_disk_blk_mem[512];
uint16_t io_disk_blk_mem_addr;
FILE * io_disk_file;
//timing variables
clock_t p_clock;

//serial
struct sp_port * io_serial_port;
//memory
uint8_t io_serial_mem[256];
uint8_t io_serial_read;
uint8_t io_serial_write;

//timer int subsytem
uint16_t int_countdown;
uint8_t do_int;

//graphics functions
void init_sdl(char * window_name){
    char name[256];
    sprintf(name, "scpemu - %s", window_name);
    window = SDL_CreateWindow(name, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 400, SDL_WINDOW_SHOWN);
    windowSurface = SDL_GetWindowSurface(window);
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

static inline void sdl_set_pixel(SDL_Surface *surface, int addr, Uint32 pixel)
{
    if(addr < 256000){
        Uint32 *target_pixel = (Uint32 *)((Uint8 *) surface->pixels + addr* sizeof *target_pixel);
        *target_pixel = pixel;
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

void sdl_check_events(unsigned long cycles){
    char c;

    //update window
    SDL_UpdateWindowSurface(window);

    while( SDL_PollEvent( &window_event ) ){
        if(window_event.type == SDL_QUIT){
            fclose(io_disk_file);
            exit(0);
        }
        if(window_event.type == SDL_KEYDOWN){
            io_key_mem[io_key_write++] = io_to_keycode(window_event.key.keysym.sym, 0);
        }
        if(window_event.type == SDL_KEYUP){
            io_key_mem[io_key_write++] = io_to_keycode(window_event.key.keysym.sym, 1);
        }
    }
    //check for serial data in
    while(sp_input_waiting(io_serial_port) > 0){
        sp_blocking_read(io_serial_port, &c, 1, 0);
        io_serial_mem[io_serial_write++] = c;
    }

    //how long it took the emulator to run cycles cycles
    double time = (double)(clock()-p_clock)/(double)CLOCKS_PER_SEC;
    //the rate in mhz (1x10^6 for mhz)
    double rate = ((double)cycles/(time*1000000.0));
    if(limit_speed){
        do{
            time = (double)(clock()-p_clock)/(double)CLOCKS_PER_SEC;
            rate = ((double)cycles/(time*1000000.0));
        } while (rate > speed_limit);
    }
    if(print_speed){
        printf("%.1f Mhz\n", rate);
    }
    p_clock = clock();
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
    //write text data if the char isn't zero
    if(c){
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
    } else {
        //write screen mem instead of char mem
        addr = x*4 + (y*320*8);
        for(i = 0; i < 32; ++i){
            color = io_gfx_mem[addr];
            io_gfx_set_pixel(addr, color);
            addr++;
            if(addr % 4 == 0){
                addr -= 4;
                addr += 320;
            }
        }
    }
}



//init the disk and serial port
void io_init(char * path, char * io_serial_port_path){
    io_disk_file = fopen(path, "r+");
    if(io_disk_file == NULL){
        printf("scpemu: No such file: %s\n", path);
        exit(1);
    }

    if(sp_get_port_by_name(io_serial_port_path, &io_serial_port) != SP_OK){
        printf("scpemu: no such serial port: %s\n", io_serial_port_path);
        exit(1);
    }
    if(sp_open(io_serial_port, SP_MODE_READ_WRITE) != SP_OK){
        printf("scpemu: error openning serial port: %s\n", io_serial_port_path);
        exit(1);
    }
    sp_set_baudrate(io_serial_port,115200);
}

//handle io
void io_out(uint8_t port, uint16_t val){
    char val_c;
    uint16_t txt_x;
    uint16_t txt_y;
    switch(port){
        //text
        case IO_text_addr_port:
            io_text_addr = val&0b11111111111;
            break;
        case IO_text_data_port:
            io_text_write_char((uint8_t)val, io_text_addr);
            io_text_mem[io_text_addr] = val;
            break;
        //gfx
        case IO_gfx_addr_port:
            io_gfx_addr = val;
            break;
        case IO_gfx_data_port:
            txt_x = (io_gfx_addr % 320) / 4;
            txt_y = (io_gfx_addr / (320*8));
            if(!io_text_mem[txt_x+(txt_y*80)]){
                io_gfx_set_pixel(io_gfx_addr, val);
            }
            io_gfx_mem[io_gfx_addr] = val;
            break;

        //disk
        //set the blk addr
        case IO_disk_block_addr_port:
            io_disk_blk_addr = val;
            break;
        //init a read of the disk
        case IO_disk_data_in_rd_en_port:
            //seek to place in disk
            fseek(io_disk_file, ((long)io_disk_blk_addr)*512, SEEK_SET);
            if(fread(io_disk_blk_mem, 1, 512, io_disk_file) != 512){
                printf("scpemu: disk read failed\n");
                exit(1);
            }
            io_disk_blk_mem_addr = 0;
            break;

        case IO_disk_data_in_next_port:
            io_disk_blk_mem_addr++;
            if(io_disk_blk_mem_addr >= 512){
                io_disk_blk_mem_addr = 0;
            }
            break;

        //write the contents of io_disk_blk_mem to disk
        case IO_disk_data_out_wr_en_port:
            //seek to place in disk
            fseek(io_disk_file, ((long)io_disk_blk_addr)*512, SEEK_SET);
            if(fwrite(io_disk_blk_mem, 1, 512, io_disk_file) != 512){
                printf("scpemu: disk write failed\n");
                exit(1);
            }
            io_disk_blk_mem_addr = 0;
            break;

        case IO_disk_data_out_port:
            io_disk_blk_mem[io_disk_blk_mem_addr++] = val;
            if(io_disk_blk_mem_addr >= 512){
                io_disk_blk_mem_addr = 0;
            }
            break;

        //serial
        case IO_serial_data_out_port:
            val_c = val;
            sp_blocking_write(io_serial_port, &val_c, 1, 0);
            break;

        case IO_serial_next_port:
            io_serial_read++;
            break;

        //timer int
        case 255:
            do_int = 1;
            int_countdown = val;

        default:
        break;
    }
}

//check the timer interupt
void io_check_timer_int(struct cpu * cpu){
    if(do_int){
        int_countdown--;
    }
    if(int_countdown == 0 && do_int){
        do_int = 0;
        cpu_int(cpu, 2);
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
        /**/
        //disk
        case IO_disk_data_in_port:
            //return data in buffer
            return io_disk_blk_mem[io_disk_blk_mem_addr];

        case IO_disk_data_out_addr_port:
        case IO_disk_data_in_addr_port:
            //return cur place in buffer
            return io_disk_blk_mem_addr;

        //serial
        case IO_serial_data_in_port:
            return io_serial_mem[io_serial_read];

        case IO_serial_in_waiting_port:
            return io_serial_write - io_serial_read;

        default:
            return 0;
            break;
    }
}