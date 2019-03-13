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

uint16_t fds[2];
uint8_t buf[16];

int main(){
    test_syscall("create: %u\n", pipe(fds));
    //fds[0] = open("pipe_test", O_RDONLY);
    //fds[1] = open("pipe_test", O_WRONLY);
    test_syscall("fds0: %u, fds1: %u\n", fds[0], fds[1]);

    if(fork() == 0){
        close(fds[1]);
        for(int i = 1; i<20000; i++){
            if(i%1000 == 0){
                test_syscall("#");
            }
            yield();
        }
        /* read from pipe in 16 bytes chuncks */
        while(read(fds[0], buf, 16) > 0){
            test_syscall("read: ");
            test_syscall(buf);
            test_syscall("\n");
        }
    } else {
        close(fds[0]);
        uint8_t data = 0;
        while(data < 255){
            /* write data one bit at a time */
            test_syscall(".");
            write(fds[1], &data, 1);
            for(int i = 1; i<500; i++){
                yield();
            }
            data++;
        }
    }

    exit(0);
}