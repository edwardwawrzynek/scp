#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/**
 * SCP mkdir
 * No flags
 */

uint8_t did_error = 0;

int main(int argc, char **argv){
    int i;
    /* print errors if options are passed */
    while((i = getopt(argc, argv, "")) != -1);

    for(;optind<argc;optind++){
        if(mkdir(argv[optind]) == -1){
            fprintf(stderr, "mkdir: cannot create directory %s: ", argv[optind]);
            perror(NULL);
            did_error = 1;
        }
    }

    return did_error;
}