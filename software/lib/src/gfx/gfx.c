#include <inout.h>
#include <stdint.h>
#include <gfx.h>
#include <unistd.h>
#include <string.h>
#include <termios.h>
#include <stdlib.h>
#include <termios.h>
#include <gfx.h>

/* pixels per x char */
#define _GFX_CHAR_WIDTH 4
#define _GFX_CHAR_HEIGHT 8

/* internal drawing functions */
void _gfx_rect(__reg("ra") int16_t x, __reg("rb") int16_t y, __reg("rc") int16_t width, __reg("rd") int16_t height, __reg("re") uint8_t color);
void _gfx_put_char(__reg("ra") int16_t x, __reg("rb") int16_t y, __reg("rc") char c);
uint16_t _gfx_read_char(__reg("ra") int16_t x, __reg("rb") int16_t y);
void _gfx_pixel(__reg("ra") uint16_t x, __reg("rb") uint16_t y, __reg("rc") uint8_t color);

/* create a gfx inst object */
struct gfx_inst * gfx_inst_new(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint8_t do_save_cont) {
  /* make sure section is aligned to text */
  if(width % _GFX_CHAR_WIDTH != 0 || height % _GFX_CHAR_HEIGHT != 0) return NULL;

  struct gfx_inst * res = malloc(sizeof(struct gfx_inst));
  res->x = x;
  res->y = y;
  res->width = width;
  res->height = height;
  if(do_save_cont) {
    res->prev_cont_buf = malloc((width/_GFX_CHAR_WIDTH)*(height/_GFX_CHAR_HEIGHT)*sizeof(uint16_t));
  } else {
    res->prev_cont_buf = NULL;
  }
  return res;
}

/* free gfx inst object */
void gfx_inst_free(struct gfx_inst * gfx) {
  if(gfx->prev_cont_buf != NULL) free(gfx->prev_cont_buf);
  free(gfx);
}

/* save current screen text content to buffer */
void gfx_save_txt_cont(struct gfx_inst * gfx) {
  if(gfx->prev_cont_buf == NULL) return;

  uint16_t addr = 0;
  for(int16_t y = 0; y < gfx->height; y+= _GFX_CHAR_HEIGHT) {
    for(int16_t x = 0; x < gfx->width; x+= _GFX_CHAR_WIDTH ) {
      gfx->prev_cont_buf[addr++] = _gfx_read_char((x + gfx->x)/_GFX_CHAR_WIDTH, (y + gfx->y)/_GFX_CHAR_HEIGHT);
    }
  }
}

/* restore screen contents from buffer */
void gfx_restore_txt_cont(struct gfx_inst * gfx) {
  if(gfx->prev_cont_buf == NULL) return;

  uint16_t addr = 0;
  for(int16_t y = 0; y < gfx->height; y+= _GFX_CHAR_HEIGHT) {
    for(int16_t x = 0; x < gfx->width; x+= _GFX_CHAR_WIDTH ) {
      _gfx_put_char((x + gfx->x)/_GFX_CHAR_WIDTH, (y + gfx->y)/_GFX_CHAR_HEIGHT, gfx->prev_cont_buf[addr++]);
    }
  }
}

/* clear content occupied by gfx_inst */
void gfx_clear_txt_cont(struct gfx_inst * gfx) {
  for(int16_t y = 0; y < gfx->height; y+= _GFX_CHAR_HEIGHT) {
    for(int16_t x = 0; x < gfx->width; x+= _GFX_CHAR_WIDTH ) {
      _gfx_put_char((x + gfx->x)/_GFX_CHAR_WIDTH, (y + gfx->y)/_GFX_CHAR_HEIGHT, ' ');
    }
  }
}

/**
 * Default method of obtaining and exiting a gfx_inst object
 * This should be used instead of gfx_inst_new, as this will be modified to work with window managers etc in the future */
struct gfx_inst * gfx_get_default_inst() {
  /* TODO: detect window manager, etc */
  struct gfx_inst * res = gfx_inst_new(8, 8, 304, 184, 1);
  gfx_save_txt_cont(res);
  gfx_clear_txt_cont(res);
  gfx_rect(res, 0, 0, res->width, res->height, 0);
  return res;
}

void gfx_exit(struct gfx_inst * gfx) {
  gfx_background(gfx, gfx_black);
  gfx_restore_txt_cont(gfx);
  gfx_inst_free(gfx);
}

/**
 * throttle framerate to the specified value,
 * or default if 0 is passed
 * 
 * this only guarantees we won't go above this rate */
void gfx_throttle(uint16_t framerate) {
  /* TODO: we need hardware support (and os) for timers (upto seconds) */
  /* for now, just do a couple syscalls to slow us down */
  for(int i = 0; i < 3; i++) {
    yield();
  }
}

/**
 * draw a pixel */
void gfx_pixel(struct gfx_inst * gfx, int16_t x, int16_t y, uint8_t color) {
  /* check bounds */
  if(x <0 || x >= gfx->width || y < 0 || y >= gfx->height) return;

  _gfx_pixel(x+gfx->x, y+gfx->y, color);
}

/**
 * draw a rectangle, and cut it if it would go offscreen
 * slower than asm routine, but safe */
void gfx_rect(struct gfx_inst * gfx, int16_t x, int16_t y, int16_t width, int16_t height, uint8_t color) {
  if(x < 0) {
    if((-x) >= width) return;
    width += x;
    x=0;
  }
  if(y < 0) {
    if((-y) >= height) return;
    height += y;
    y = 0;
  }

  if(x+width > gfx->width) {
    if(x >= gfx->width) return;
    width -= (x+width-gfx->width);
  }
  if(y+height > gfx->height) {
    if(y >= gfx->height) return;
    height -= (y+height-gfx->height);
  }

  _gfx_rect(x + gfx->x, y + gfx->y, width, height, color);
}

/**
 * set background
 * just calls rect */
void gfx_background(struct gfx_inst * gfx, uint8_t color) {
  _gfx_rect(gfx->x, gfx->y, gfx->width, gfx->height, color);
}

/**
 * put a string onto the screen, starting at pos x,y
 */
void gfx_put_string(int16_t x, int16_t y, char * msg) {
  int16_t cur_x = x;
  int16_t cur_y = y;
  while(*msg) {
    if(cur_x >= 80) {
      cur_x = x;
      cur_y++;
    }
    if(*msg == '\n') {
      cur_x = x;
      cur_y++;
    } else {
      _gfx_put_char(cur_x++, cur_y, *msg);
    }

    msg++;
  }
}