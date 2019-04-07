#include <stdio.h>
#include <unistd.h>

char *args[4];

int main(){
    args[0] = "arg 1";
    args[1] = "arg 2";
    args[2] = "arg 3 - yeah";
    args[4] = NULL;
    printf("test2\n");
    printf("argv: %u\n", (uint16_t)args[0]);

    execv("test1", args);
}