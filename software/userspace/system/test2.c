#include <stdio.h>
#include <unistd.h>

unsigned char *args[] = {"mkdir", "test_dir1", "test_dir2", NULL};

unsigned char *args2[] = {"ls", "dev", "fsakdj", ".", NULL};

int main(){
    printf("test2\n");
    uint8_t ret_val;

    if(fork() == 0){
        execv("mkdir", args);
    }
    wait(&ret_val);
    printf("mkdir returned: %u\n", ret_val);

    if(fork() == 0){
        execv("ls", args2);
    }

   wait(&ret_val);
    printf("mkdir returned: %u\n", ret_val);

}