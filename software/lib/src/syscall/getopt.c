#include <unistd.h>
#include <stdio.h>
#include <string.h>

/**
 * SCP getopt implementation (simplified posix version)
 * optstr consists of option characters, each of which can be followed by : to indicate a required argument, or :: to indicate an optional argument
 */

char * optarg;
int optind = 1, optopt, opterr = 1;

int getopt(int argc, char **argv, char *optstr){
    if(optind >= argc){
        return -1;
    }
    char * arg = argv[optind++];
    /* if --, return rest as arg to program without scanning*/
    if(!strcmp(arg, "--")){
        return -1;
    }

    if(arg[0] != '-'){
        optind--;
        return -1;
    }

    /* just - is not a valid argument */
    if(strlen(arg) < 2){
        if(opterr){
            fprintf(stderr, "%s: '-' is not recognized as a valid option\n", argv[0]);
        }
        optopt = '-';
        return '?';
    }


    char arg_c = arg[1];
    uint8_t req_arg = 0;
    uint8_t opt_arg = 0;
    uint8_t good_arg_c = 0;
    for(int i = 0; i < strlen(optstr); i++){
        if(optstr[i] == arg_c){
            if(optstr[i+1] == ':'){
                if(optstr[i+2] == ':'){
                    opt_arg = 1;
                } else {
                    req_arg = 1;
                }
            }
            good_arg_c = 1;
        }
    }
    if(!good_arg_c){
        if(opterr){
            fprintf(stderr, "%s: -%c is not recognized as a valid option\n", argv[0], arg_c);
        }
        optopt = arg_c;
        return '?';
    }
    /* check for arg in this option */
    if(strlen(arg) >= 3){
        if((!req_arg) && (!opt_arg)){
            if(opterr){
                fprintf(stderr, "%s: -%c does not accept an argument\n", argv[0], arg_c);
            }
            optopt = arg_c;
            return '?';
        } else {
            optarg = &arg[2];
            return arg_c;
        }
    }
    /* check for arg in next option */
    if(req_arg || opt_arg){
        if(optind < argc){
            if(argv[optind][0] != '-'){
                optarg = argv[optind];
                optind++;
                return arg_c;
            } else if(req_arg){
                if(opterr){
                    fprintf(stderr, "%s: -%c requires an argument\n", argv[0], arg_c);
                }
                optopt = arg_c;
                return '?';
            }
        } else {
            if(req_arg){
                if(opterr){
                    fprintf(stderr, "%s: -%c requires an argument\n", argv[0], arg_c);
                }
                optopt = arg_c;
                return '?';
            }
        }
    }
    optarg = 0;
    return arg_c;
}
