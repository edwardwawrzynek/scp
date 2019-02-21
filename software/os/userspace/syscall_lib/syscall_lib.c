#include "include/defs.h"
#include "syscall.h"


/* System Call Wrappers
 * The actual syscalls are implemented in asm, but wrappers for ones that need to block are implemented here */

uint16_t test_syscall(uint16_t __reg("ra") a0, uint16_t __reg("rb") a1, __reg("rc") uint16_t a2, uint16_t __reg("rd") a3);