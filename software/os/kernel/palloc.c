#include "include/defs.h"
#include "kernel/panic.h"
#include <panic.h>

//Allocation functions

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

//array of refs to each page
uint8_t palloc_page_refs[MMU_NUM_PROCS];

/* get a new page, and mark it as in use
 * returns (uint8_t) - the page addr, suitable for use in a mem_map array*/
uint8_t palloc_new(){
    unsigned int i;
    for(i = 0; i < MMU_NUM_PROCS; ++i){
        if(!palloc_page_refs[i]){
            palloc_page_refs[i] = 1;
            return (i | 0b10000000);
        }
    }
    panic(PANIC_NO_MORE_PAGES);
}

/* increase the refs for a certain page
 * returns (uint8_t) - the page addr, suitable for use in mem_map, and for deallocation by palloc_free */
uint8_t palloc_add_ref(uint8_t page){
    //clear bit mask if page was obtained from mmu tables or mem_map
    page = page & 0b01111111;
    if(!palloc_page_refs[page]){
        panic(PANIC_PALLOC_ADD_REF_UNASIGNED_PAGE);
    }
    palloc_page_refs[page]++;

    return page;
}

/* free a page, and mark it as free
 * returns (none) */
void palloc_free(uint8_t i){
    //clear bit mask
    i = i  & 0b01111111;
    if(!palloc_page_refs[i]){
        panic(PANIC_PALLOC_FREE_UNASIGNED);
    }
    palloc_page_refs[i]--;
}