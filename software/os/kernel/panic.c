#include "include/defs.h"
#include <lib/kstdio_layer.h>

void panic(uint8_t error){
	printf("\n\n\nThe Kernel Experienced An Error\nError Code: %u\nStopping\nPress a key to halt\n", error);
	getchar();
	__asm("\thlt.n.n\n");
}
