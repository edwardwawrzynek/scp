#include <stdint.h>
#ifndef __SETJMP_INCL
#define __SETJMP_INCL 1

struct __jmp_buf {
  /* 15 regs (re - function return not included) + pc at index 15 */
  uint16_t regs[16];
};

typedef struct __jmp_buf jmp_buf[1];


void longjmp(__reg("ra") jmp_buf env, __reg("re") int value);

int setjmp(__reg("ra") jmp_buf env);

#endif