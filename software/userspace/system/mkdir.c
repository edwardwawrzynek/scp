#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/**
 * SCP mkdir
 * No flags
 */

int main(int argc, char **argv){
    int i;
    /* print errors if options are passed */
    while((i = getopt(argc, argv, "")) != -1);

    for(;optind<argc;optind++){
        int fd = open(argv[optind], O_RDONLY);
        if(fd != -1){
            fprintf(stderr, "mkdir: directory %s already exists\n", argv[optind]);
            close(fd);
        }
        else if(mkdir(argv[optind]) == -1){
            fprintf(stderr, "mkdir: error making directory %s\n", argv[optind]);
            return 1;
        }
    }

    return 0;
}