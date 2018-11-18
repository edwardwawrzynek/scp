#include <string.h>
#include <iostream>

#include "gfx.h"
#include "ports.h"

/**
 * reset the subsystem state */
void GfxIO::reset(){
  txt_mem_addr = 0;
  gfx_mem_addr = 0;
  key_read_addr = 0;
  key_write_addr = 0;

  memset(txt_mem, 0, 2048*sizeof(uint8_t));
  memset(gfx_mem, 0, 65536*sizeof(uint8_t));
  memset(key_mem, 0, 256*sizeof(uint16_t));
}

/**
 * create the sdl window */
void GfxIO::init(){
  window = SDL_CreateWindow("SCP Emulator", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 400, SDL_WINDOW_SHOWN);
  windowSurface = SDL_GetWindowSurface(window);
}

/**
 * convert an 8-bit color to 32 bit for sdl */
uint32_t GfxIO::conv_color(uint8_t color){
  uint32_t res;
  //red
  res = ((color>>5) & 0b111)<<(16+5);
  //green
  res += ((color>>2) & 0b111)<<(8+5);
  //blue
  res += ((color) & 0b11)<<6;
  return res;
}

/**
 * set a pixel in the sdl window */
void GfxIO::sdl_set_pixel(uint32_t addr, uint8_t color)
{
  if(addr < 256000){
    uint32_t *target_pixel = (Uint32 *)((Uint8 *)windowSurface->pixels + addr* sizeof *target_pixel);
    *target_pixel = conv_color(color);
  }
}

/**
 * set a pixel on the scp window - really a 2x2 pixel */
//set a "pixel" on the screen (really a 2x2 block)
void GfxIO::gfx_set_pixel(uint16_t addr, uint8_t val){
  uint16_t x;
  uint16_t y;

  /* set on screen */
  x = addr%320;
  y = addr/320;

  sdl_set_pixel(x*2 + y*1280, val);
  sdl_set_pixel((x*2 + y*1280) +1, val);
  sdl_set_pixel((x*2 + y*1280) +640, val);
  sdl_set_pixel((x*2 + y*1280) +641, val);
}

/**
 * set a pixel in gfx mem, and set it on the screen if it is not covered by a non-null character */
void GfxIO::set_pixel(uint16_t addr, uint8_t val){
  /* set mem */
  gfx_mem[addr] = val;

  /* check if it is covered by text */
  uint16_t txt_x = (addr % 320) / 4;
  uint16_t txt_y = (addr / (320*8));

  if(!txt_mem[txt_x+(txt_y*80)]){
    gfx_set_pixel(addr, val);
  }
}

/**
 * set a char on the screen, or, if it is null, set its space to the gfx contents in its spot */
//write a char to the window
void GfxIO::set_txt(uint16_t addr, uint8_t val){
  uint16_t x;
  uint16_t y;

  unsigned int pos;
  int i;
  uint64_t charset;
  uint8_t color;

  //write to memory
  txt_mem[addr] = val;

  //x and y in terms of text location
  x = addr%80;
  y = addr/80;

  //find pos on screen
  pos = x*8 + (y*16*640);
  //write text data if the char isn't zero
  if(val){
    charset = gfx_charset[val];
    for(i = 0; i < 64; ++i){
      color = charset&0x8000000000000000 ? 0xff : 0;
      sdl_set_pixel(pos, color);
      sdl_set_pixel(pos+640, color);
      charset = charset << 1;
      pos++;
      if(pos % 8 == 0){
        pos -= 8;
        pos += 1280;
      }
    }
  } else {
    /* write screen mem instead of char mem */
    addr = x*4 + (y*320*8);
    for(i = 0; i < 32; ++i){
      color = gfx_mem[addr];
      gfx_set_pixel(addr, color);
      addr++;
      if(addr % 4 == 0){
        addr -= 4;
        addr += 320;
      }
    }
  }
}

/**
 * convert an sdl keycode to scp keycode */
uint16_t GfxIO::get_keycode(SDL_Keycode key, uint8_t release){
  uint16_t res;
  res = key;
  switch(key){
    /* arrow keys */
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
    /* shift */
    case 1073742049:
        res = 16;
        break;
    /* return */
    case 13:
        res = 10;
        break;
    /* page up and down */
    case 1073741899:
      res = 33;
      break;
    case 1073741902:
      res = 34;
      break;
    /* function keys */
    /*f1*/
    case 1073741882:
      res = 11;
      break;
    /*f2*/
    case 1073741883:
      res = 12;
      break;
    /*f3*/
    case 1073741884:
      res = 13;
      break;
    /*f4*/
    case 1073741885:
      res = 14;
      break;
    /*f5*/
    case 1073741886:
      res = 15;
      break;
    /*f6*/
    case 1073741887:
      res = 19;
      break;
    /*f7*/
    case 1073741888:
      res = 20;
      break;
    /*f8*/
    case 1073741889:
      res = 21;
      break;
    /*f9*/
    case 1073741890:
      res = 22;
      break;
    /*f10*/
    case 1073741891:
      res = 23;
      break;
    /*f11*/
    case 1073741892:
      res = 24;
      break;
    /*f12*/
    case 1073741893:
      res = 25;
      break;

    default:
      break;
  }
  res = release ? 0x100 + res : res;
  return res;
}

/**
 * write a keypress into key_mem */
void GfxIO::write_key(SDL_Keycode key, uint8_t release){
  key_mem[key_write_addr++] = get_keycode(key, release);
}

/**
 * update window, and read in any keypresses, and kill if the window was killed */
void GfxIO::update(){
  //update window
  SDL_UpdateWindowSurface(window);

  while( SDL_PollEvent( &window_event ) ){
    if(window_event.type == SDL_QUIT){
      exit(0);
    }
    if(window_event.type == SDL_KEYDOWN){
      write_key(window_event.key.keysym.sym, 0);
    }
    if(window_event.type == SDL_KEYUP){
      write_key(window_event.key.keysym.sym, 1);
    }
  }
}

/**
 * handle io reads and writes to gfx subsytem */
uint16_t GfxIO::io_read(uint8_t port){
  update();

  switch(port){
    case _key_in_waiting_port:
      return key_write_addr - key_read_addr;

    case _key_data_in_port:
      return key_mem[key_read_addr];

    default:
      /* these ports don't do anything on read */
      break;
  }

  return 0;
}

void GfxIO::io_write(uint8_t port, uint16_t val){
    update();

  switch(port){
    case _key_next_port:
      key_read_addr++;
      break;

    case _text_addr_port:
      txt_mem_addr = val;
      break;

    case _text_data_port:
      set_txt(txt_mem_addr, val);
      break;

    case _gfx_addr_port:
      gfx_mem_addr = val;
      break;

    case _gfx_data_port:
      set_pixel(gfx_mem_addr, val);
      break;

    default:
        /* these ports don't do anything on write */
        break;
  }
}