/**
 * System Call Mechanism:
 * system calls use int #7
 * Args are passed in (no syscall uses more than four args):
 * arg1: ra
 * arg2: rb
 * arg3: rc
 * arg4: rd
 * system call number: re
 * system call return: re
 */

uint16_t test_syscall(__reg("ra") uint8_t *a0, uint16_t __reg("rb") a1, __reg("rc") uint16_t a2, uint16_t __reg("rd") a3);

uint16_t getpid();
uint16_t getppid();
uint16_t fork();
