#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>

/* Test proc 1 - print and exit */
/*int main(){
    if(write(STDOUT_FILENO, "hello, world (from test1)! -----\n", 34) != 34){
        test_syscall("error in test1 occured\n", 0, 0, 0);
    }

    exit(0);
}*/

struct stat stat_e;

int main(){
    int fd = open("test2.txt", O_RDONLY);
    fstat(fd, &stat_e);
    test_syscall("is exec: %u\n", S_ISEXEC(stat_e.st_mode));
    test_syscall("chmod: %u\n", fchmod(fd, 0));

    //while(1);
    exit(0);
}