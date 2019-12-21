#ifndef __GFX_H_INCL
#define __GFX_H_INCL 1

#include <stdint.h>

/**
 * an area of the screen being managed by gfx
 * must be aligned on 8 x 8 pixels */
typedef struct {
  /* location in pixels */
  uint16_t x, y, width, height;
  /* buffer containing previously present text - saved and restored on exit */
  uint16_t * prev_cont_buf;
} gfx_t;
void gfx_put_string(gfx_t * gfx, int16_t x, int16_t y, char * msg);
void gfx_put_char(gfx_t *gfx, uint16_t x, uint16_t y, uint16_t c);
uint16_t gfx_get_char(gfx_t * gfx, uint16_t x, uint16_t y);
void gfx_pixel(gfx_t *gfx,int16_t x,int16_t y,uint8_t color);
void gfx_throttle(uint16_t framerate);
void gfx_exit(gfx_t *gfx);
void gfx_rect(gfx_t *gfx,int16_t x,int16_t y,int16_t width,int16_t height,uint8_t color);
gfx_t *gfx_new_window();
void gfx_clear_txt_cont(gfx_t *gfx);
void gfx_restore_txt_cont(gfx_t *gfx);
void gfx_save_txt_cont(gfx_t *gfx);
void gfx_inst_free(gfx_t *gfx);
gfx_t *gfx_inst_new(uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint8_t do_save_cont);
void gfx_background(gfx_t * gfx, uint8_t color);

/** macros **/
#define gfx_width(gfx) (gfx->width)
#define gfx_height(gfx) (gfx->height)


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
#define gfx_key_enter 13

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

/* gfx_colors */

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
