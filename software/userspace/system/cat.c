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

int8_t did_error = 0;

char buf[512];

int main(int argc, char **argv){
    int i;
    /* print errors if options are passed */
    while((i = getopt(argc, argv, "")) != -1);

    for(;optind<argc;optind++){
        FILE * file;
        if(!strcmp(argv[optind], "-")){
            file = stdin;
        } else {
            file = fopen(argv[optind], "r");
        }
        if(file == NULL){
            fprintf(stderr, "cat: failed to open file: %s: %s\n", argv[optind], strerror(errno));
            did_error = 1;
        } else {
            int8_t c;
            while((c = fgetc(file)) != EOF){
                putchar(c);
            }
        }

    }

    return did_error;
}
