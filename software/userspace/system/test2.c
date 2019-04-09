#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"ls", "dev", ".", NULL};

int main(){
    printf("test2\n");

    execv("ls", args);
}