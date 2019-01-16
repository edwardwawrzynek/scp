#include "include/defs.h"
#include "kernel/mmu_asm.h"

/* mmu layout
 * -- Virtual Memory Addr to Physical --
 * The high 5 bits of an addr are the page, low 11 addr in that page (2k pages)
 * The PTB register is added to the high 5 bits, and used as addr in page table
 * -- MMU Table Layout --
 * 2k pages, 128k total memory
 * 2^11 Entries on the table, each being composed of {(1 bit - page enabled),(6 bits - page(of 64 physical pages))}
 * Each process can access 2^5 pages - proc 0 (kenel) is entries 0-31, proc 1 entries 32-63, proc 2 64-47
 * Therefore, the high 6 bits of entry addr is the proc, the low 5 bits the page
 *
 */

/* mmu managment functions */

/* Dump a 32 value (64k addr space) page table into the mmu - sets ptb
 * this only dumps value with the most significant bit set, and sets those without it set to unassigned
 * table is 1 32 value array, offset the offset into the mmu table
 * returns (nones)
 */

void mmu_proc_table_out(uint8_t * table, uint16_t offset){
    uint16_t i;
    for(i = 0; i < 32; ++i){

        if(table[i]&0b10000000){
            mmu_set_page(offset+i, table[i]);
        } else {
            mmu_set_page(offset+i, MMU_UNUSED);
        }
    }
}


/* init the values in all proc table entries except the kernel to be unassigned 0xff
 * used in the boot process
 * returns (none) */

void mmu_init_clear_table(){
    unsigned int i;
    for(i = 32; i < MMU_NUM_PROCS * PROC_MMU_PAGES; ++i){
        mmu_set_page(i, MMU_UNUSED);
    }
}