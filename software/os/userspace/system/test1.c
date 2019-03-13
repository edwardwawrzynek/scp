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

struct stat stat_s;

int main(){
    int fd = open("init", O_RDONLY);
    fstat(fd, &stat_s);
    test_syscall("is_dir: %u, is_reg: %u, links: %u\n", S_ISDIR(stat_s.st_mode), S_ISREG(stat_s.st_mode), stat_s.st_size);

    while(1);
}