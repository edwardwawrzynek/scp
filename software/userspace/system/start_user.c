#include <stdio.h>
#include <unistd.h>
#include <setjmp.h>

unsigned char *args[] = {"sh", "-i", NULL};

int main(){
    printf("start_user: starting sh\t\n");
    chdir("/home");
    uint8_t ret_val;
    if(fork() == 0){
        execv("sh", args);
        perror("sh exec failed: ");
        fprintf(stderr, "start_user exiting\n");
        exit(1);
    }
    wait(NULL);
    printf("sh terminated\n");
    exit(1);
}