#include "include/defs.h"

/* Test syscall */
uint16_t _test_syscall(uint16_t arg0, uint16_t arg1, uint16_t arg2, uint16_t arg3){
    /* return sum */

    return arg0 + arg1 + arg2 + arg3;
}