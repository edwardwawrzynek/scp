#include <stdint.h>

/**
 * SCP virtual terminal emulator
 * vterm is an abstract virtual terminal emulator
 * it doesn't actually do any hardware interfacing,
 * it just translates escape sequences, etc to a much
 * simpler interface for programs to handle 
 **/

#ifndef VERTM_INCL
#define VTERM_INCL

/* display attributes */
typedef uint8_t vterm_atr_t;

#define vterm_atr_bold      0b0000001
#define vterm_atr_faint     0b0000010
#define vterm_atr_italic    0b0000100
#define vterm_atr_underline 0b0001000
#define vterm_atr_blink     0b0010000
/* reverse video is handled by fg and bg colors */

/* colors */
typedef uint8_t vterm_clr_t;

/* colors are 0-7 (black, red) */
#define vterm_clr_black   0
#define vterm_clr_red     1
#define vterm_clr_green   2
#define vterm_clr_yellow  3
#define vterm_clr_blue    4
#define vterm_clr_magenta 5
#define vterm_clr_cyan    6
#define vterm_clr_white   7

#define vterm_clr_bold_prefix 8
#define vterm_clr_bold(color) ((color)+vterm_clr_bold_prefix)

#define vterm_clr_default 16

/* vterm blank character (disregard fg and bg color) */
#define vterm_char_blank  0

/* alternate character sets */
typedef uint8_t vterm_charset_t;
#define vterm_charset_0 0
#define vterm_charset_1 1

#define vterm_getc_blocking 256

#define vterm_mod_shift 1
#define vterm_mod_ctrl 4

/* virtual terminal object */
struct vterm {
  /* terminal size */
  uint16_t width;
  uint16_t height;
  /* treat sgr bold as bold color (also sends bold flag) */
  uint8_t flag_handle_sgr_bold_clr;

  /* backend functions (specified by user) */

  /* put a character on screen at a position with the specified attributes */
  void (*putc)(char c, uint16_t x, uint16_t y, vterm_atr_t atr, vterm_clr_t fg_color, vterm_clr_t bg_color, vterm_charset_t charset);
  /* enable handling of vterm_key_* codes in getc */
  uint8_t flag_handle_getc_codes;
  /* vterm_key_* handling values */
  uint8_t _modifier_keys;
  /* get a character from input (it can contain escape sequences, which will be passed through, or will handle vterm_key_* codes) */
  /* getc should return vterm_getc_blocking if no key is available 
   * if a key was released, getc should return it with 0x100 added to it */
  uint16_t (*getc)();
  /* call scroll when scrolling has to happen instead of doing scrolling with repeated calls to putc
  if this is 0, a buffer will be maintained */
  uint8_t flag_call_scroll;
  /* scroll text */
  void (*scroll)();

  /* do bell */
  void (*bell)();

  /* internal values */

  /* position */
  int16_t _x;
  int16_t _y;
  /* buffer of chars that need to be returned from getc (special key escape codes, size report, etc) */
  uint8_t _getc_buf[16];
  uint8_t _getc_buf_pos;

  /* buffer of escape codes being written out that aren't done yet. fifo buffer */
  uint8_t _putc_buf[16];
  uint8_t _putc_buf_pos;

  /* screen buffer (malloc'd if flag_call_scroll == 0). fifo buffer */
  uint8_t * _buf;
  /* screen attribute + color buffer + charset (encoded into one word each) */
  uint16_t * _buf_atr;

  /* current text atr */
  vterm_atr_t _cur_atr;
  /* current charset */
  vterm_charset_t _cur_charset;
  /* logical fg and bg colors */
  vterm_clr_t _fg_clr;
  vterm_clr_t _bg_clr;
  /* if colors should be passed inverted to putc */
  uint8_t _inverted;

  /* saved cursor position */
  uint16_t _saved_x;
  uint16_t _saved_y;

  /* if an escape code is being printed */
  uint8_t _esc_in_progress;
};

typedef struct vterm vterm_t;

/* create a new virtual terminal */
vterm_t * vterm_new(uint16_t width, uint16_t height, void (*putc)(char c, uint16_t x, uint16_t y, vterm_atr_t atr, vterm_clr_t fg_color, vterm_clr_t bg_color, vterm_charset_t charset), uint16_t (*getc)(), uint8_t handle_sgr_bold, uint16_t handle_getc_codes, uint8_t has_scroll_func, void (*scroll)(), void (*bell)());

/* print a character to the virtual terminal */
void vterm_putc(vterm_t * term, uint8_t c);

/* get a character from a virtual terminal 
 * returns vterm_getc_blocking if no key is available */
uint16_t vterm_getc(vterm_t * term);

/* special key definitions */
#define vterm_key_up 29
#define vterm_key_left 28
#define vterm_key_right 30
#define vterm_key_down 31

#define vterm_key_shift 16
#define vterm_key_ctrl 17
#define vterm_key_alt 18
#define vterm_key_tab 9
#define vterm_key_backspace 8
#define vterm_key_esc 27
#define vterm_key_caps_lock 20
#define vterm_key_del 46
#define vterm_key_page_up 33
#define vterm_key_page_down 34
#define vterm_key_insert 45
#define vterm_key_home 36
#define vterm_key_end 35
#define vterm_key_enter 13

#define vterm_key_f1 11
#define vterm_key_f2 12
#define vterm_key_f3 13
#define vterm_key_f4 14
#define vterm_key_f5 15
#define vterm_key_f6 19
#define vterm_key_f7 20
#define vterm_key_f8 21
#define vterm_key_f9 22
#define vterm_key_f10 23
#define vterm_key_f11 24
#define vterm_key_f12 25

#endif