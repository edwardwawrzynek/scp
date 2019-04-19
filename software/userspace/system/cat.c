#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/**
 * SCP cat
 * No flags
 * - as an arg cats stdin
 */

uint8_t did_error = 0;

char * args[] = {"cat", "test2"};

int main(int argc, char **argv){
    int i;
    test_syscall("starting cat\n");
    /* print errors if options are passed */
    while((i = getopt(argc, argv, "")) != -1);

    for(;optind<argc;optind++){
        int fd;
        if(!strcmp(argv[optind], "-")){
            fd = STDIN_FILENO;
        } else {
            fd = open(argv[optind], O_RDONLY);
            test_syscall("opened: %u\n", (int16_t)fd);
        }
        if(fd == -1){
            fprintf(stderr, "cat: error opening %s", argv[optind]);
            did_error = 1;
        } else{
            int8_t c;
            test_syscall("running\n");
            while(read(fd, &c, 1) == 1){
                putchar(c);
            }
        }

    }

    return did_error;
}