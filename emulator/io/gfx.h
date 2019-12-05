#include "SDL2/SDL.h"
#include <cstdint>

/* Subsystem handling text and pixel graphics, along with keyboard */

/* charset - included from gfx_charset.cpp */
extern uint64_t gfx_charset[256];

class GfxIO {
  /* sdl objects */
  SDL_Window *window;
  SDL_Surface *windowSurface;
  SDL_Event window_event;

  /* text memory */
  uint16_t txt_mem_addr;
  uint16_t txt_mem[2048];

  /* colored txt memory */
  uint8_t txt_fg_mem[16];
  uint8_t txt_bg_mem[16];

  /* gfx memory */
  uint16_t gfx_mem_addr;
  uint8_t gfx_mem[65536];

  /* keyboard memory */
  uint8_t key_read_addr;
  uint8_t key_write_addr;
  uint16_t key_mem[256];

  /* convert from 8 bit to 32 bit color */
  uint32_t conv_color(uint8_t color);
  /* set a pixel on the sdl window */
  void sdl_set_pixel(uint32_t addr, uint8_t color);
  /* set a pixel on the io screen - realy 2x2 blocks */
  void gfx_set_pixel(uint16_t addr, uint8_t color);

  /* write a pixel to gx mem - sets mem, and screen if not covered by text */
  void set_pixel(uint16_t addr, uint8_t val);

  /* set a txt char on screen, or, if it is null, write data from gfx_mem to screen */
  void set_txt(uint16_t addr, uint16_t val);

  /* convert an sdl keypress to scp keycode */
  uint16_t get_keycode(SDL_Keycode key, uint8_t release);
  /* write a keypress into key_mem */
  void write_key(SDL_Keycode key, uint8_t release);

  public:
    /* reset state */
    void reset();

    /* update the window and other parts of the subsystem - call often */
    void update();

    /* perform an io read or write - only handles gfx ports*/
    uint16_t io_read(uint8_t port);
    void io_write(uint8_t port, uint16_t val);

    /* init the window */
    void init();

    void close();

};