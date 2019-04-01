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
    FILE * file = fopen("/test.txt", "r");
    if(file == NULL){
        test_syscall("open failure\n");
    }
    int c;
    while((c = fgetc(file)) != EOF){
        buf[buf_index++] = c;
        fseek(file, 2, SEEK_CUR);
    }

    test_syscall(buf);

}