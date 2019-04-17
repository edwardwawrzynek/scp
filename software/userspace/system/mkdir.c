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
        if(mkdir(argv[optind]) == -1){
            if(errno == EEXIST){
                fprintf(stderr, "mkdir: directory already exists %s\n", argv[optind]);
            } else {
                fprintf(stderr, "mkdir: error making directory %s\n", argv[optind]);
            }
        }
    }

    return 0;
}