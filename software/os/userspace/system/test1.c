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

struct dirent entry;

int main(){
    int fd = opendir("dir_test");
    if(fd == -1){
        test_syscall("failure opening\n");
    } else {
        test_syscall("success %u\n", fd);
    }

    while(readdir(fd, &entry) > 0){
        test_syscall(entry.name);
    }

    closedir(fd);
    while(1);
}