#include <inout.h>
#include <stdint.h>
#include <gfx.h>
#include <unistd.h>
#include <string.h>

/* start gfx mode */
void gfx_init(uint16_t do_clear) {
  if(do_clear) {
    gfx_clear_text();
    gfx_background(0);
  }
  /* setup input to raw mode */
  gfx_set_input_mode(STANDARD);
}

/* exit gfx mode */
void gfx_exit(uint16_t do_clear) {
  if(do_clear) {
    gfx_background(0);
    gfx_clear_text();
  }
  /* setup input to canomode */
  struct termios in_termios = {.flags = TERMIOS_CANON | TERMIOS_CTRL | TERMIOS_ECHO};
  ioctl(STDIN_FILENO, TCSETA, &in_termios);
}

/* 0 if not pressed, 1 if pressed */
static uint8_t pressed_keys[128];

static char flush_buf[50];
/**
 * flush all waiting input */
void gfx_flush_input() {
  uint8_t is_eof;
  while(read_nb(STDIN_FILENO, flush_buf, 50, &is_eof) == 50);
  memset(pressed_keys, 0, 128);
}

/**
 * clear text on screen */
void gfx_clear_text() {
  for(int x = 0; x < 80; x++) {
    for(int y = 0; y < 25; y++) {
      gfx_put_char(x, y, '\0');
    }
  }
}

static enum gfx_in_mode gfx_mode;

/**
 * set the mode for gfx input
 * this flushes all current input in buffer */
void gfx_set_input_mode(enum gfx_in_mode mode) {
  gfx_mode = mode;
  struct termios in_termios;
  if(mode == TRACK_PRESS) {
    in_termios.flags = TERMIOS_RAW | TERMIOS_RELEASE;
    ioctl(STDIN_FILENO, TCSETA, &in_termios);
  } else if(mode == STANDARD) {
    in_termios.flags = TERMIOS_RAW;
    ioctl(STDIN_FILENO, TCSETA, &in_termios);
  }

  gfx_flush_input();
}

/**
 * return a keypress, or -1 if none available
 * use with mode STANDARD */
int gfx_get_keypress() {
  if(gfx_mode != STANDARD) return -1;

  uint8_t c;
  uint8_t is_eof;
  if(read_nb(STDIN_FILENO, &c, 1, &is_eof) != 1) return -1;
  return c;
}

/**
 * check if a key is currently pressed
 * use with mode TRACK_PRESS
 */
int gfx_is_key_pressed(uint8_t key) {
  if(gfx_mode != TRACK_PRESS) return 0;

  /* update pressed_keys */
  uint8_t c;
  uint8_t is_eof;
  while(read_nb(STDIN_FILENO, &c, 1, &is_eof) == 1) {
    if(c & 0x80) pressed_keys[c & 0x7f] = 0;
    else          pressed_keys[c & 0x7f] = 1;
  }

  return pressed_keys[key & 0x7f];
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
 * draw a rectangle, and cut it if it would go offscreen
 * slower than gfx_rect */
void gfx_rect_safe(int16_t x, int16_t y, int16_t width, int16_t height, uint8_t color) {
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

  if(x+width > 320) {
    if(x >= 320) return;
    width -= (x+width-320);
  }
  if(y+height > 200) {
    if(y >= 200) return;
    height -= (y+height-200);
  }

  gfx_rect(x, y, width, height, color);
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
      gfx_put_char(cur_x++, cur_y, *msg);
    }

    msg++;
  }
}