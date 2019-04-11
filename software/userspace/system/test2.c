#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"mkdir", "test_dir1", "test_dir2", NULL};

int main(){
    printf("test2\n");

    if(fork() == 0){
        execv("mkdir", args);
    }

    wait(NULL);

    execv("ls", NULL);
}