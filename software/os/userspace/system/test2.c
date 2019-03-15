#include <stdint.h>
#include <stdio.h>
#include "syscall.h"
#include <inout.h>
#include <stddef.h>
#include <string.h>

/* Test proc 1 - print and loop */
int pos = 0;
int speed = 1;
char buf[80];

char null;
void run(){
    if(pos >= 80){
        speed = -1;
    }
    if(pos < 0){
        speed = 1;
    }
    pos+=speed;
    memset(buf, 0, 80);
    buf[pos] = '#';
    if(write(STDOUT_FILENO, buf, 80) != 80){
        test_syscall("error in test2 occured\n", 0, 0, 0);
        while(1);
    }
}

int main(){
    while(1){
        run();
    }
}