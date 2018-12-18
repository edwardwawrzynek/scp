#ifndef __STDIO_INCL
#define __STDIO_INCL 1
_SCP_gen_auto_ln ("stdio.h");

#define stdin 0
#define stdout 1
#define stderr 2

#ifndef NULL
#define NULL 0
#endif

#define EOF (-1)
#define FILE char

#define KEY_F1 11
#define KEY_F2 12
#define KEY_F3 13
#define KEY_F4 14
#define KEY_F5 15
#define KEY_F6 19
#define KEY_F7 20
#define KEY_F8 21
#define KEY_F9 22
#define KEY_F10 23
#define KEY_F11 24
#define KEY_F12 25

#define KEY_LEFT 28
#define KEY_UP 29
#define KEY_RIGHT 30
#define KEY_DOWN 31

#define KEY_PAGE_UP 33
#define KEY_PAGE_DOWN 34

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7

#define _text_addr_port 5
#define _text_data_port 6

#define _gfx_addr_port 9
#define _gfx_data_port 10
#define _gfx_screen_en_port 12

#define _sound_freq_port 11

#ifndef _STDIO_NO_EXTERNS
//If true, getchar prints the chars it recives
extern unsigned char _getcharecho;
//if shift is being pressed
extern unsigned char _getcharshifted;
extern unsigned int _screenpos;

#endif

#endif
