#include "include/defs.h"

panic(uint8_t error){
	printf("\n\n\nThe Kernel Experienced An Error\nError Code: %u\nStopping\n", error);
	while(1);
}
