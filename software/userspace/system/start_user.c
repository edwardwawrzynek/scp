#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"sh", NULL};

int main(){
    printf("start_user up\n");
    printf("starting sh ...\n");
    uint8_t ret_val;
    if(fork() == 0){
        execv("sh", args);
        perror("sh exec failed: ");
        fprintf(stderr, "start_user exiting\n");
        exit(1);
    }
    wait(NULL);
    printf("sh terminated\n");
    printf("start_user exiting\n");
    exit(1);
}