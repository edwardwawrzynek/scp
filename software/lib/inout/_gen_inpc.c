/* generate the inp.c file containing the _inp functions needed for the inp call to work */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv){
    if(argc != 4){
        printf("Usage: _gen_inpc inp.c __inp.h max_port_num\n");
        exit(1);
    }
    int max_port = atoi(argv[3]);

    FILE *out = fopen(argv[1], "w");
    FILE *outh = fopen(argv[2], "w");
    if(!out){
        printf("Failed to open file: %s\n", argv[1]);
        exit(1);
    }
    if(!outh){
        printf("Failed to open %s\n", argv[2]);
        exit(1);
    }

    for(int i = 0; i <= max_port; i++){
        fprintf(out, "int _inp_%u(){__asm(\"\\tin.r.p re %u\");}\n", i, i);
        fprintf(outh, "int _inp_%u(void);\n", i);
    }
}