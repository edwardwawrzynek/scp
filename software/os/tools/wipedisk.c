#include "include/defs.h"

char buf[512];

main(){
    //Clear the whole disk
    unsigned int i;
    i = 0;
    while(++i){
        disk_write(i, buf);
        printf("%u ", i);
    }
    printf("\nDone. Disk Cleared.");
}
