#include <stdio.h>
#include <unistd.h>

char *args[] = {"arg1", "arg2 - hey!", "3rd arg", NULL};

int main(){
    printf("test2\n");

    execv("test1", args);
}