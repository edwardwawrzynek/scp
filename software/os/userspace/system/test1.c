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
    test_syscall("create: %u\n", mknod("test_tty", S_IFDEV, makedev(1,0)));
    /*int fd = open("test_tty", O_RDONLY);
    fstat(fd, &stat_e);
    test_syscall("major: %u, minor: %u\n", major(stat_e.st_dev), minor(stat_e.st_dev));
    test_syscall("chmod: %u\n", fchmod(fd, 0));*/

    //while(1);
    exit(0);
}