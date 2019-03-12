#include <stdint.h>
#include <stdio.h>
#include "../syscall_lib/syscall.h"
#include <inout.h>
#include <stddef.h>

/* Test proc 1 - print and loop */
int main(){
    while(1){
        if(write(STDOUT_FILENO, "hello, world (from test2)!\n", 28) != 28){
            test_syscall("error in test2 occured\n", 0, 0, 0);
            while(1);
        }
    }
}