#include "include/defs.h"
#include <lib/kstdio_layer.h>

void panic(uint8_t error){
	printf("\nSCP Kernel Panic\nError code: %u\nstopping\n", error);
	while(1);
}
