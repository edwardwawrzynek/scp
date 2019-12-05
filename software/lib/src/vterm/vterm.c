#include "vterm.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#ifdef SCPOS
#include <lib/kmalloc.h>
#define malloc kmalloc
#define free kfree
#define realloc krealoc
#define calloc kcalloc
#endif

/* encode fg color, bg color, atr, charset into a word */
static uint16_t vterm_encode_atr(vterm_clr_t fg, vterm_clr_t bg, vterm_atr_t atr, vterm_charset_t charset) {
  uint16_t res = 0;
  /* 5 bits wide */
  res |= (fg & 0x1f);
  /* 5 bits wide */
  res |= (bg & 0x1f) << 5;
  /* 5 bits wide */
  res |= (atr & 0x1f) << 10;
  /* 1 bit wide */
  res |= (charset & 0x1) << 15;

  return res;
}

/* decode fg color, background color, atr, charset from word */
static void vterm_decode_atr(uint16_t word, vterm_clr_t * fg, vterm_clr_t * bg, vterm_atr_t * atr, vterm_charset_t * charset) {
  *fg = word&0x1f;
  *bg = (word>>5)&0x1f;
  *atr = (word>>10)&0x1f;
  *charset = (word>>15)&0x1;
}

/* create a new virtual terminal */
vterm_t * vterm_new(uint16_t width, uint16_t height, void (*putc)(char c, uint16_t x, uint16_t y, vterm_atr_t atr, vterm_clr_t fg_color, vterm_clr_t bg_color, vterm_charset_t charset), uint16_t (*getc)(), uint8_t handle_sgr_bold, uint16_t handle_getc_codes, uint8_t has_scroll_func, void (*scroll)(), void (*bell)()) {
  vterm_t * res = malloc(sizeof(vterm_t));

  res->width = width;
  res->height = height;
  res->putc = putc;
  res->getc = getc;
  res->scroll = scroll;
  res->bell = bell;
  res->flag_handle_sgr_bold_clr = handle_sgr_bold;
  res->flag_call_scroll = has_scroll_func;
  res->flag_handle_getc_codes = handle_getc_codes;

  /* defaults */
  res->_x = 0;
  res->_y = 0;

  res->_shifted = 0;

  memset(&(res->_getc_buf), 0, 16);
  res->_getc_buf_pos = 0;
  memset(&(res->_putc_buf), 0, 16);
  res->_putc_buf_pos = 0;

  if(res->flag_call_scroll) {
    res->_buf = NULL;
    res->_buf_atr = NULL;
  } else {
    res->_buf = malloc(width*height);
    memset(res->_buf, 0, width*height);
    res->_buf_atr = malloc(width * height * sizeof(uint16_t));
    memset16(res->_buf_atr, vterm_encode_atr(vterm_clr_default, vterm_clr_default, 0, vterm_charset_0), width*height);
  }
  res->_cur_atr = 0;
  res->_fg_clr = vterm_clr_default;
  res->_bg_clr = vterm_clr_default;
  res->_inverted = 0;

  res->_saved_x = 0;
  res->_saved_y = 0;

  res->_esc_in_progress = 0;

  res->_cur_charset = vterm_charset_0;

  return res;
}


/* scroll a vterm if needed */
static void vterm_scroll(vterm_t * term) {
  while(term->_y >= term->height) {
    /* TODO: handle case of no buffer */
    term->scroll();
    term->_y--;
  }
}

/* set a character in a terminal (and set buf if needed) */
static void vterm_set_char(vterm_t * term, char c, uint16_t x, uint16_t y) {
  vterm_clr_t fg, bg;
  if(term->_inverted) {
    fg = term->_bg_clr;
    bg = term->_fg_clr;
  } else {
    fg = term->_fg_clr;
    bg = term->_bg_clr;
  }

  if(term->_buf != NULL) {
    term->_buf[x + y * (term->width)] = c;
    term->_buf_atr[x + y * (term->width)] = vterm_encode_atr(fg, bg, term->_cur_atr, term->_cur_charset);
  }

  term->putc(c, x, y, term->_cur_atr, fg, bg, term->_cur_charset);
}

static void vterm_handle_sgr_param(vterm_t * term, uint16_t code) {
  /* light colors */
  if(code >= 30 && code <= 37) {
    term->_fg_clr = code - 30;
  }
  if(code >= 40 && code <= 47) {
    term->_bg_clr = code - 40;
  }
  /* bright colors */
  if(code >= 90 && code <= 97) {
    term->_fg_clr = vterm_clr_bold(code - 90);
  }
  if(code >= 100 && code <= 107) {
    term->_bg_clr = vterm_clr_bold(code - 100);
  }
  /* color restart */
  if(code == 39) {
    term->_fg_clr = vterm_clr_default;
  }
  if(code == 49) {
    term->_bg_clr = vterm_clr_default;
  }
}

/* handle sgr sequence */
static void vterm_handle_sgr_seq(vterm_t * term, char * esc) {

  char * code = esc + 2;
  while(*code != '\0') {
    uint16_t res = atoi(code);
    while(*code >= '0' && *code <= '9') code++;
    if(*code == '\0') break;
    code++;
    vterm_handle_sgr_param(term, res);
  }
}

static void vterm_handle_esc_seq(vterm_t * term, char * esc) {
  /* csi sequences */
  if(strlen(esc) <= 1) return;
  if(esc[1] == '[') {
    char last_char = esc[strlen(esc) - 1];
    /* sgi parameters */
    switch(last_char) {
      case 'm':
        vterm_handle_sgr_seq(term, esc);
      default:
        return;
    }
  }
}

/* print a character to the virtual terminal */
void vterm_putc(vterm_t * term, uint8_t c) {
  if(term->_esc_in_progress) {
    term->_putc_buf[term->_putc_buf_pos++] = c;
    /* interpret end of escape codes */
    /* csi sequences */
    if(term->_putc_buf[1] == '[') {
      /* end byte */
      if(isalpha(c)) {
        term->_putc_buf[term->_putc_buf_pos] = '\0';
        vterm_handle_esc_seq(term, term->_putc_buf);
        term->_putc_buf_pos = 0;
        term->_esc_in_progress = 0;
      }
    }
  } else if(c == 0x1b) {
    term->_putc_buf_pos = 0;
    term->_esc_in_progress = 1;
    term->_putc_buf[term->_putc_buf_pos++] = c;
  } else {
    /* char is not part of an escape code */

    switch(c) {
      case 13:  /* carriage return */
        term->_x = 0;
        break;
      case 10: /* linefeed */
        term->_y++;
        vterm_scroll(term);
        break;
      case 9: /* horizontal tab - just moves cursor */
        /* tab when already on eigth spot moves cursor forwards */
        if(!(term->_x & 7) ) term->_x++;
        while(term->_x & 7) term->_x++;
        if(term->_x >= term->width) term->_x = term->width - 1;
        break;
      case 8: /* backspace */
        if(term->_x > 0) term->_x--;
        break;
      case 7: /* bell */
        if(term->bell != NULL) term->bell();
        break;
      default: /* all other characters */
        if(term->_x >= term->width) {
          term->_x = 0;
          term->_y++;
          vterm_scroll(term);
        }
        vterm_set_char(term, c, term->_x, term->_y);
        term->_x++;
        break;
    }
  }
}

/* put an escape sequence into a vterm getc buffer, and return the first element of it */
static uint16_t vterm_add_getc_seq(vterm_t * term, uint8_t * seq, size_t length) {
  length--;
  size_t i = 1;
  while(length--) {
    term->_getc_buf[term->_getc_buf_pos++] = seq[i++];
  }
  return seq[0];
}

static char * shifted_charset = " !\"#$%&\"()*+<_>?)!@#$%^&*(::<+>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}^_~ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~\\";

/* get a character from a virtual terminal, or return vterm_getc_blocking if none are available */
uint16_t vterm_getc(vterm_t * term) {
  /* if data is waiting to be sent, send it */
  if(term->_getc_buf_pos > 0) {
    /* get first element */
    uint8_t elem = term->_getc_buf[0];
    /* shift buffer */
    term->_getc_buf_pos--;
    memmove(&(term->_getc_buf[0]), &(term->_getc_buf[1]), term->_getc_buf_pos * sizeof(uint8_t));
    return elem;
  }

  uint16_t char_in = term->getc();
  if(char_in == vterm_getc_blocking) return vterm_getc_blocking;
  if(!term->flag_handle_getc_codes) return char_in;

  /* handle getc codes */
  switch(char_in) {
    case vterm_key_backspace:
      return 0x7f;
    case vterm_key_enter:
      return 13;
    case vterm_key_tab:
      return 9;
    case vterm_key_up:
      return vterm_add_getc_seq(term, (uint8_t []){0x1b, '[', 'A'}, 3);
    case vterm_key_down:
      return vterm_add_getc_seq(term, (uint8_t []){0x1b, '[', 'B'}, 3);
    case vterm_key_right:
      return vterm_add_getc_seq(term, (uint8_t []){0x1b, '[', 'C'}, 3);
    case vterm_key_left:
      return vterm_add_getc_seq(term, (uint8_t []){0x1b, '[', 'D'}, 3);
    case vterm_key_shift:
      term->_shifted = 1;
      return vterm_getc_blocking;
    case 0x100 + vterm_key_shift:
      term->_shifted = 0;
      return vterm_getc_blocking;
    default:
      if(!(char_in & 0x100)) {
        if(char_in >= 32 && char_in <= 128 && term->_shifted) {
          return shifted_charset[char_in - 32];
        }
        return char_in;
      }
  }
}