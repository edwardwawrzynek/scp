#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"mkdir", "test_dir1", "test_dir2", NULL};

int main(){
    uint8_t data=255;
    printf("test2\n");

    if(fork() == 0){
        execv("mkdir", args);
    }

    wait(&data);
    printf("mkdir returned: %u\n", data);

    execv("ls", NULL);
}