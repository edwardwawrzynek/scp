#include "include/defs.h"
#include "kernel/incl.h"
#include "lib/incl.h"
#include "fs/incl.h"

//main functions for the kernel

//perform a broad initilization of the kernel
void kernel_init(){
  //set all mmu entries but proc 0 (kernel) to be unassigned
  mmu_init_clear_table();
  //bring up filesystem
  fs_init();
  //init proc table
  proc_init_table();
  //init kernel entry
  proc_init_kernel_entry();
}

/* map a pointer from a proc's addr space into the kernels
 * can map up to 2048 bytes (TODO: make this a variable size limit)
 * maps the pointer to the last 2 pages before the stack page in the kernel addr space
 * returns (uint8_t *) - NULL on failure, or a pointer in the kernel addr space, valid until the next call to kernel_map_in_mem */
uint8_t * kernel_map_in_mem(uint8_t * pointer, struct proc * proc){
  //the indes of the page in the proc's addr space
  uint16_t page_in_proc;
  //real pages that the pointer resides in
  uint16_t page1;
  uint16_t page2;
  //get which page the pointer is in the proc
  page_in_proc = pointer >> MMU_PAGE_SIZE_SHIFT;
  //load real pages
  page1 = proc->mem_map[page_in_proc];
  //check that page is actually mapped in
  if(!(page1 & 0b10000000)){
    return NULL;
  }
  //clear assigned bit
  page1 = page1 & 0b01111111;
  //only load 2nd page if the pointer isn't pointing to the last page
  if(page_in_proc != 31){
    page2 = (proc->mem_map[page_in_proc]);
    //check that page is actually mapped in
    if(!(page2 & 0b10000000)){
      return NULL;
    }
    //clear assigned bit
    page2 = page2 & 0b01111111;
  } else {
    page2 = MMU_UNUSED;
  }
  //map into kernel addr space
  mmu_set_page(KERNEL_MEM_MAP_PAGE_1, page1);
  mmu_set_page(KERNEL_MEM_MAP_PAGE_2, page2);
  //return the pointer
  return (KERNEL_MEM_MAP_PAGE_1 << MMU_PAGE_SIZE_SHIFT) + (pointer & MMU_PAGE_SIZE_MASK);
}