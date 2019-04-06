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
    FILE * file = fopen("test.txt", "w+");
    if(file == NULL){
        puts("open failure");
    }
    if(fwrite("hello, world!", 1, 13, file) != 13){
        puts("write failure\n");
    }
    fflush(file);
    fseek(file, 1, SEEK_SET);

    if(fread(buf, 1, 5, file) != 5){
        puts("read failure\n");
    }
    puts(buf);
    fseek(file, 0, SEEK_CUR);
    fputc('a', file);
    fseek(file, 0, SEEK_CUR);
    puts(fgets(buf, 1000, file));

    fclose(file);
}