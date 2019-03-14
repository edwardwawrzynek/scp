#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>
#include <string.h>

/* Test proc 1 - print and exit */
/*int main(){
    if(write(STDOUT_FILENO, "hello, world (from test1)! -----\n", 34) != 34){
        test_syscall("error in test1 occured\n", 0, 0, 0);
    }

    exit(0);
}*/


int main(){
    uint8_t * brk_v = sbrk(0);
    test_syscall("brk: %u\n", (uint16_t)brk_v);
    test_syscall("brk adj: %u\n", brk(10));
    memset(brk_v, 0, 2048);

    while(1);
}