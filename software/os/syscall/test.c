#include "include/defs.h"

#include "kernel/kernel.h"
#include "kernel/proc.h"
#include "include/lib/kstdio_layer.h"

/* Test syscall */
uint16_t _test_syscall(uint16_t arg0, uint16_t arg1, uint16_t arg2, uint16_t arg3){
    /* printf with up to three args */

    uint8_t * str = kernel_map_in_mem((uint8_t *)arg0, proc_current_proc);

    printf(str, arg1, arg2, arg3);
    return 0;
}