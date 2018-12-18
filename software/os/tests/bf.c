#include "include/defs.h"
#include "fs/incl.h"
//Main testing file for os
extern unsigned char * brk;
extern unsigned char * _MEM_END;

#define NUM_CELLS 30000
#define STACK_SIZE 50

char cells[NUM_CELLS];
unsigned int ptr;

unsigned int starts[STACK_SIZE];
unsigned int level;

struct file_entry * fd;

fgetc(struct file_entry * fd){
    unsigned char data;
    if(file_read(fd, &data, 1) != 1){
        return -1;
    }
    return data;
}

main(){
	char c;
	unsigned int pos;

    unsigned int startLevel;

    brk = &_MEM_END;
    fs_init();

	pos = 0;
	fd = file_get(3, FILE_MODE_READ);
	c = fgetc(fd);
	while(c != -1){
		if(c == '>'){
			++ptr;
		} if(c == '<'){
			--ptr;
		} if(c == '+'){
			++cells[ptr];
		} if(c == '-'){
			--cells[ptr];
		} if(c == '.'){
			putchar(cells[ptr]);
		} if(c == ','){
			cells[ptr] = getchar();
		} if(c == '['){
            startLevel = level;
			starts[level++] = pos;
            if(!cells[ptr]){
                while(1){
                    c = fgetc(fd);
                    ++pos;
                    if(c == '['){
                        ++level;
                    }
                    if(c == ']'){
                        --level;
                        if(level == startLevel){
                            c = 0;
                            break;
                        }
                    }
                }
            }
		} if(c == ']'){
			file_seek(fd, starts[--level], SEEK_SET);
            pos = starts[level]-1;
		}
		++pos;
		c=fgetc(fd);
	}
}