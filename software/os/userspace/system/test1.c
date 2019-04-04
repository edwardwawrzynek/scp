#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>
#include <string.h>

/* Test proc 1 - print and exit */
/*int main(){
    if(write(STDOUT_FILENO, "test1\n", 6) != 6){
        test_syscall("error in test1 occured\n", 0, 0, 0);
    }

    exit(0);
}*/

char buf[1000];
int buf_index = 0;

int main(){
    test_syscall("stdin: %u\nmode: %u", (int16_t)stdin, stdin->buf_mode);
    while(1){
        puts(gets(buf));
    }
}