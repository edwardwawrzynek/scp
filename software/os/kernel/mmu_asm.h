#include <stddef.h>

/**
 * Function declarations for the mmu_asm.asm file
 * The functions in that file are simple wrappers arround the machine level mmu managment instructions */

void mmu_set_ptb(__reg("ra") uint16_t ptb);

void mmu_set_page(__reg("ra") uint16_t index, __reg("rc") uint16_t val);