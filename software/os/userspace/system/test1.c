#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>
#include <string.h>
#include <stdarg.h>

/* Test proc 1 - print and exit */
/*int main(){
    if(write(STDOUT_FILENO, "test1\n", 6) != 6){
        test_syscall("error in test1 occured\n", 0, 0, 0);
    }

    exit(0);
}*/

char buf[1000];
int buf_index = 0;

int method(int num, ...){
    va_list args;

    va_start(args, num);
    while(num--){
        test_syscall("arg: %u\n", (int)va_arg(args, int*));
    }
    va_end(args);
}

int main(){
    method(5, 1, 2, 3, 4, 64345);
}