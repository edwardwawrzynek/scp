#include <stdint.h>
//asm support for proc_begin_execute
void context_switch_run_state();

//get the state of the cond register
uint16_t context_switch_get_cond_reg();
