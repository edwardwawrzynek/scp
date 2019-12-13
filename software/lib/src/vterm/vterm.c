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

static uint16_t vterm_add_getc_seq(vterm_t * term, uint8_t * seq, size_t length);

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

  res->_modifier_keys = 0;

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
  vterm_clr_t fg = term->_fg_clr, bg = term->_bg_clr;
  if(term->flag_handle_sgr_bold_clr && term->_cur_atr & vterm_atr_bold) fg = vterm_clr_bold(fg);
  if(fg == vterm_clr_default) fg = vterm_clr_bold(vterm_clr_white);
  if(bg == vterm_clr_default) bg = vterm_clr_black;
  if(term->_inverted) {
    vterm_clr_t tmp = fg;
    fg = bg;
    bg = tmp;
  }

  if(term->_buf != NULL) {
    term->_buf[x + y * (term->width)] = c;
    term->_buf_atr[x + y * (term->width)] = vterm_encode_atr(fg, bg, term->_cur_atr, term->_cur_charset);
  }

  term->putc(c, x, y, term->_cur_atr, fg, bg, term->_cur_charset);
}

static void vterm_handle_sgr_param(vterm_t * term, uint16_t code) {
  switch(code) {
    case 0:
      term->_fg_clr = vterm_clr_default;
      term->_bg_clr = vterm_clr_default;
      term->_inverted = 0;
      term->_cur_atr = 0;
      break;
    case 1:
      term->_cur_atr |= vterm_atr_bold;
      break;
    case 2:
      term->_cur_atr |= vterm_atr_faint;
      break;
    case 3:
      term->_cur_atr |= vterm_atr_italic;
      break;
    case 4:
      term->_cur_atr |= vterm_atr_underline;
      break;
    case 5:
    case 6:
      term->_cur_atr |= vterm_atr_blink;
      break;
    case 22:
      term->_cur_atr &= ~(vterm_atr_bold | vterm_atr_faint);
      break;
    case 23:
      term->_cur_atr &= ~vterm_atr_italic;
      break;
    case 24:
      term->_cur_atr &= ~vterm_atr_underline;
      break;
    case 25:
      term->_cur_atr &= ~vterm_atr_blink;
      break;
    case 30:
    case 31:
    case 32:
    case 33:
    case 34:
    case 35:
    case 36:
    case 37:
      term->_fg_clr = code - 30;
      break;
    case 40:
    case 41:
    case 42:
    case 43:
    case 44:
    case 45:
    case 46:
    case 47:
      term->_bg_clr = code - 40;
      break;
    case 90:
    case 91:
    case 92:
    case 93:
    case 94:
    case 95:
    case 96:
    case 97:
      term->_fg_clr = vterm_clr_bold(code - 90);
      break;
    case 100:
    case 101:
    case 102:
    case 103:
    case 104:
    case 105:
    case 106:
    case 107:
      term->_bg_clr = vterm_clr_bold(code - 100);
      break;
    case 39:
      term->_fg_clr = vterm_clr_default;
      break;
    case 49:
      term->_bg_clr = vterm_clr_default;
      break;
    /* reverse video */
    case 7:
      term->_inverted = 1;
      break;
    case 27:
      term->_inverted = 0;
      break;
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

/* parse args for fixed arg csi sequences */
static void vterm_parse_csi_params(char * esc, uint16_t * args, size_t num_args) {
  char * code = esc + 2;
  while(*code != '\0' && num_args > 0) {
    *(args++) = atoi(code);
    num_args--;
    while(*code >= '0' && *code <= '9') code++;
    if(*code == '\0') break;
    code++;
  }
  while(num_args > 0) {
    *(args++) = 0;
    num_args--;
  }
}

static void vterm_handle_esc_seq(vterm_t * term, char * esc) {
  uint16_t args[16];
  /* csi sequences */
  if(strlen(esc) <= 1) return;
  if(esc[1] == '[') {
    char last_char = esc[strlen(esc) - 1];
    /* sgi parameters */
    switch(last_char) {
      case 'A':
      case 'B':
      case 'C':
      case 'D':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 0) args[0] = 1;
        if(last_char == 'A') term->_y -= args[0];
        if(last_char == 'B') term->_y += args[0];
        if(last_char == 'C') term->_x += args[0];
        if(last_char == 'D') term->_x -= args[0];

        if(term->_x < 0) term->_x = 0;
        if(term->_x >= term->width) term->_x = term->width-1;
        if(term->_y < 0) term->_y = 0;
        if(term->_y >= term->height) term->_y = term->height-1;
        break;
      case 'f':
      case 'H':
        vterm_parse_csi_params(esc, args, 2);
        if(args[0] == 0) args[0] = 1;
        if(args[1] == 0) args[1] = 1;
        term->_y = args[0]-1;
        term->_x = args[1]-1;
        if(term->_x >= term->width) term->_x = term->width-1;
        if(term->_y >= term->height) term->_y = term->height-1;
        break;
      case 'K':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 0) {
          int16_t pos = term->_x;
          while(pos < term->width) {
            vterm_set_char(term, ' ', pos++, term->_y);
          } 
        } else if (args[0] == 1) {
          int16_t pos = term->_x;
          while(pos >= 0) {
            vterm_set_char(term, ' ', pos--, term->_y);
          } 
        } else if (args[0] == 2) {
          int16_t pos = 0;
          while(pos < term->width) {
            vterm_set_char(term, ' ', pos++, term->_y);
          }
        }
        break;
      case 'J':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 0) {
          int16_t posx = term->_x;
          int16_t posy = term->_y;

          while(posy < term->height) {
            while(posx < term->width) {
              vterm_set_char(term, ' ', posx++, posy);
            } 
            posx = 0;
            posy++;
          }
        } else if (args[0] == 1) {
          int16_t posx = term->_x;
          int16_t posy = term->_y;
          while(posy >= 0) {
            while(posx >= 0) {
              vterm_set_char(term, ' ', posx--, posy);
            }
            posx = term->width-1;
            posy--;
          } 
        } else if (args[0] == 2 || args[0] == 3) {
          for(int16_t posy = 0; posy < term->height; posy++) {
            for(int16_t posx = 0; posx < term->width; posx++) {
              vterm_set_char(term, ' ', posx, posy);
            }
          }
        }
        break;
      case 'm':
        vterm_handle_sgr_seq(term, esc);
        break;
      case 'E':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 0) args[0] = 1;
        term->_y += args[0];
        if(term->_y >= term->height) term->_y = term->height -1;
      case 'F':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 0) args[0] = 1;
        term->_y -= args[0];
        if(term->_y < 0) term->_y = 0;
        break;
      case 'G':
        vterm_parse_csi_params(esc, args, 1);
        term->_x = args[0] -1;
        if(term->_x < 0) term->_x = 0;
        if(term->_x >= term->width) term->_x = term->width - 1;
        break;
      case 'n':
        vterm_parse_csi_params(esc, args, 1);
        if(args[0] == 6) {
          uint8_t pos = 0;
          uint8_t seg[10];
          seg[pos++] = '\x1b';
          seg[pos++] = '[';
          itoa(term->_y+1, seg+pos, 10);
          while(seg[pos] != '\0') pos++;
          itoa(term->_x+1, seg+pos, 10);
          while(seg[pos] != '\0') pos++;
          seg[pos++] = 'R';
          vterm_add_getc_seq(term, seg, pos);
        }
        break;
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
      term->_modifier_keys |= vterm_mod_shift;
      return vterm_getc_blocking;
    case 0x100 + vterm_key_shift:
      term->_modifier_keys &= ~vterm_mod_shift;
      return vterm_getc_blocking;
    case vterm_key_ctrl:
      term->_modifier_keys |= vterm_mod_ctrl;
      return vterm_getc_blocking;
    case 0x100 + vterm_key_ctrl:
      term->_modifier_keys &= ~vterm_mod_ctrl;
      return vterm_getc_blocking;
    default:
      if(!(char_in & 0x100)) {
        if(char_in >= 97 && char_in <= 122 && term->_modifier_keys & vterm_mod_ctrl)
          return char_in - 96;
        if(char_in >= 32 && char_in <= 128 && term->_modifier_keys & vterm_mod_shift) {
          return shifted_charset[char_in - 32];
        }
        return char_in;
      }
  }
}
