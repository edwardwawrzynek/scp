#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"ls", "-cdir1", "dir2", "dir3", NULL};

int main(){
    printf("test2\n");

    execv("test1", args);
}