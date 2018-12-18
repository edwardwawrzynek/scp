#ifndef __STDIO_INCL
#define __STDIO_INCL 1

#define stdin 0
#define stdout 1
#define stderr 2

#ifndef NULL
#define NULL 0
#endif

#define EOF (-1)
#define FILE char

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7

#define _text_addr_port 5
#define _text_data_port 6

#define _gfx_addr_port 9
#define _gfx_data_port 10
#define _gfx_screen_en_port 12

#define _sound_freq_port 11

#endif
#ifndef _DISK_INCL

#define _DISK_INCL 1

#define _disk_busy_port 13
#define _disk_reset_port 13
#define _disk_error_port 14
#define _disk_block_addr_port 14

#define _disk_data_in_port 15
#define _disk_data_in_next_port 15
#define _disk_data_in_rd_en_port 16
#define _disk_data_in_addr_port 16

#define _disk_data_out_port 17
//Writing to 17 atomatically increments the addr

#define _disk_data_out_wr_en_port 18
#define _disk_data_out_addr_port 18

#endif
