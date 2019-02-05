#include <stdint.h>

/**
 * Vars needed for loading cpu state for use in context_switch.asm
 * Used for both starting and int'ing from procs
 */

/* cpu regs */
uint16_t context_switch_regs[16];
/* pc reg */
uint16_t context_switch_pc_reg;
/* condition register - only set when intterupting prc */
uint8_t context_switch_cond_reg;
/* two value to compare when switching to proc to produce proper cond reg */
uint16_t context_switch_cmp1;
uint16_t context_switch_cmp2;