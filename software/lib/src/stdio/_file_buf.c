#include <syscall.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

/* file buffer handling (TODO) */

int fflush(struct _file * file){

}

/* set the buffer and buffering mode on a file */
int setvbuf(struct _file *file, uint8_t *buf, uint8_t mode, uint16_t size){
   
}

void setbuf(struct _file * file, uint8_t * buf){
    
}