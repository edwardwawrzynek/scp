#ifndef __GFX_H_INCL
#define __GFX_H_INCL 1

#include <stdint.h>

/**
 * start gfx mode */
void gfx_init(uint16_t do_clear);

/**
 * exit gfx mode */
void gfx_exit(uint16_t do_clear);

/**
 * clear text on screen */
void gfx_clear_text();

/**
 * put a char on screen at the specifed location
 * uses hardware text support (x is in [0,80) range and y [0,25)) */
void gfx_put_char(__reg("ra") int16_t x, __reg("rb") int16_t y, __reg("rc") char c);

/**
 * put a string onto the screen, starting at pos x,y
 */
void gfx_put_string(int16_t x, int16_t y, char * msg);

/**
 * throttle framerate to the specified value,
 * or default if 0 is passed
 * 
 * the frame rate may be below the specified value if the processor is doing a lot */
void gfx_throttle(uint16_t framerate);

/**
 * draw a pixel on the screen at x, y in color color
 */
void gfx_pixel(__reg("ra") uint16_t x, __reg("rb") uint16_t y, __reg("rc") uint8_t color);

/**
 * draw a rectangle
 * if the rectangle extends off the screen, don't draw it
 * see gfx_rect_safe for a slower version that can draw partially off screen rects
 */
void gfx_rect(__reg("ra") int16_t x, __reg("rb") int16_t y, __reg("rc") int16_t width, __reg("rd") int16_t height, __reg("re") uint8_t color);

/**
 * draw a rectangle, and cut it if it would go offscreen
 * slower than gfx_rect */
void gfx_rect_safe(int16_t x, int16_t y, int16_t width, int16_t height, uint8_t color);

/**
 * clear the screen with color */
void gfx_background(__reg("ra") uint8_t color);

/**
 * gfx key reading has two modes:
 * TRACK_PRESS - keep track of what keys are pressed and what aren't (good for games)
 * STANDARD - just return raw key down, ignore keyups, etc (still raw keys)
 */
enum gfx_in_mode {
  TRACK_PRESS,
  STANDARD
};
/**
 * flush all waiting input */
void gfx_flush_input();
/**
 * set the mode for gfx input */
void gfx_set_input_mode(enum gfx_in_mode mode);
int gfx_get_keypress();
int gfx_is_key_pressed(uint8_t key);

/* special key definitons */
#define gfx_key_up 29
#define gfx_key_left 28
#define gfx_key_right 30
#define gfx_key_down 31

#define gfx_key_shift 16
#define gfx_key_ctrl 17
#define gfx_key_alt 18
#define gfx_key_tab 9
#define gfx_key_backspace 8
#define gfx_key_esc 27
#define gfx_key_caps_lock 20
#define gfx_key_del 46
#define gfx_key_page_up 33
#define gfx_key_page_down 34
#define gfx_key_insert 45
#define gfx_key_home 36
#define gfx_key_end 35
#define gfx_key_enter 10

#define gfx_key_f1 11
#define gfx_key_f2 12
#define gfx_key_f3 13
#define gfx_key_f4 14
#define gfx_key_f5 15
#define gfx_key_f6 19
#define gfx_key_f7 20
#define gfx_key_f8 21
#define gfx_key_f9 22
#define gfx_key_f10 23
#define gfx_key_f11 24
#define gfx_key_f12 25


#define gfx_rgb_to_color(r, g, b) ((b>>6) + ((g>>5)<<2) + ((r>>5)<<5))

#define gfx_red       0b11000000
#define gfx_green     0b00111000
#define gfx_blue      0b00000111

#define gfx_orange    0b11101000
#define gfx_yellow    0b11111000
#define gfx_turquoise 0b00111111
#define gfx_purple    0b10000111
#define gfx_pink      0b11000010

#define gfx_white     0b11111111
#define gfx_black     0b00000000

#endif