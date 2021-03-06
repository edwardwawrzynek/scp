#define _serial_data_in_port 1
#define _serial_next_port 1
#define _serial_in_waiting_port 2
#define _serial_data_out_port 3
#define _serial_tx_busy_port 4

#define _key_in_waiting_port 8
#define _key_data_in_port 7
#define _key_next_port 7

#define _text_addr_port 5
#define _text_data_port 6

#define _gfx_addr_port 9
#define _gfx_data_port 10

#define _sound_freq_port 11

#define _disk_busy_port 13
#define _disk_reset_port 13
#define _disk_error_port 14
#define _disk_block_addr_port 14
#define _disk_data_in_port 15
#define _disk_data_in_next_port 15
#define _disk_data_in_rd_en_port 16
#define _disk_data_in_addr_port 16
#define _disk_data_out_port 17
#define _disk_data_out_wr_en_port 18
#define _disk_data_out_addr_port 18

/* time till next interupt (in 2^12 clock ticks) */
#define _int_timer_port 255
/* time since system started (in 2^12 clock ticks) */
#define _sys_clock_in_port_low 253
#define _sys_clock_in_port_high 254

/* sys info ports */
#define _sys_info_pages_mem 252
#define _sys_info_cpu_speed 251
#define _sys_info_emulated 250