#include "include/defs.h"
#include "fs/incl.h"
#include <serial.h>
//Main testing file for os
extern unsigned char * brk;
extern unsigned char * _MEM_END;

char buf[256];
char *arg;

#define DIGARR "0123456789abcdef"
hexdump(unsigned char * mem, unsigned int n){
    unsigned char * dig;
    unsigned int i, j;
    unsigned char is_end;
    dig = DIGARR;
    for(i = 0; i < n; ++i){
        putchar(dig[(*mem)>>4]);
        putchar(dig[(*(mem++))&0x0f]);
        is_end = (i%10) == 9;
        putchar(is_end ? '|' : ' ');
        if(is_end){
            //print out ascii representation
            mem = mem - 10;
            for(j = 0; j < 10; ++j){
                if(*mem != '\n' && *mem != '\t' && *mem != 8){
                    putchar(*mem);
                } else {
                    putchar(219);
                }
                mem++;
            }
        }
    }
}

list_dir(struct file_entry * dir){
    uint16_t i;
    uint8_t name[14];
    i = dir_next_entry(dir, name);
    while(i){
        printf("%u: %s\n", i, name);
        i = dir_next_entry(dir, name);
    }
}

unsigned char data;

main(){
    struct file_entry * fin;
	brk = &_MEM_END;
    fs_init();

    fin = file_get(3, FILE_MODE_WRITE | FILE_MODE_TRUNCATE);
    printf("Inum: %u\n", fin->ind->inum);

    while(1){
        data = serial_read();
        if(data == 0xf0){
            break;
        }
        file_write(fin, &data, 1);
        serial_write(data);
        printf("%u\n", data);
    }
    file_put(fin);
    printf("Done");
    fs_close();
    
}

serial_in_waiting(){
	return inp(serial_in_waiting_port);
}

//Return -1 if no data is waiting
serial_async_read(){
	int c;
	if(serial_in_waiting()){
		c = inp(serial_data_in_port);
		outp(serial_next_port, 1);
		return c;
	}
	return -1;
}

//Read, block until char ready
serial_read(){
	int c;
	do{
		c = serial_async_read();
	} while(c == -1);
	return c;
}

//Write, returning -1 if tx busy
serial_async_write(unsigned char c){
	if(inp(serial_tx_busy_port)){
		return -1;
	}
	outp(serial_data_out_port, c);
}

//Write, block till the tx is not busy to send
serial_write(unsigned char c){
	while(inp(serial_tx_busy_port)){};
	outp(serial_data_out_port, c);
}
