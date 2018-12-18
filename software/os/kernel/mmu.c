#include "include/io.h"
#include "lib/incl.h"
#include "include/defs.h"

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

mmu_proc_table_out(unsigned char * table, unsigned int offset){
    unsigned int i;
    for(i = 0; i < 32; ++i){
        offset+i;
        _asm("\n\
	        aptb\n\
        ");
        if(table[i]&0b10000000){
            table[i];
            _asm("\n\
	            lbib	#0\n\
	            mmus\n\
            ");
        } else {
            MMU_UNUSED;
            _asm("\n\
	            lbib	#0\n\
	            mmus\n\
            ");
        }
    }
}

/* set a page table entry to a specific value
 * returns (none) */

mmu_set_page(uint16_t page_addr, uint8_t value){
    page_addr;
    _asm("  aptb\n");
    value;
    _asm("\n\
        lbib  #0\n\
        mmus\n\
        ");
}

/* init the values in all proc table entries except the kernel to be unassigned 0xff
 * used in the boot process
 * returns (none) */

mmu_init_clear_table(){
    unsigned int i;
    for(i = 32; i < 2048; ++i){
        i;
        _asm("\n\
            aptb\n\
        ");
        MMU_UNUSED;
        _asm("\n\
            lbib    #0\n\
            mmus\n\
        ");
    }
}