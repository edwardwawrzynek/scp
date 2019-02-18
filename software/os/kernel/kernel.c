#include "include/defs.h"
#include "fs/fs.h"
#include "kernel/proc.h"
#include "kernel/mmu.h"
#include "kernel/mmu_asm.h"
#include "include/lib/kstdio_layer.h"



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
  //start kstdio layer
  kstdio_layer_init(1);
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
  page_in_proc = (uint16_t)pointer >> MMU_PAGE_SIZE_SHIFT;
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
  mmu_set_page(KERNEL_MEM_MAP_PAGE_1, page1 | 0b10000000);
  mmu_set_page(KERNEL_MEM_MAP_PAGE_2, page2 | 0b10000000);
  //return the pointer
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_1 << MMU_PAGE_SIZE_SHIFT) +
  ((uint16_t)pointer & MMU_PAGE_SIZE_MASK);
}

/**
 * map in a pointer to at most an aligned word, or a byte
 * can be used at the same time as kernel_map_in_mem, as it uses a different page */
uint8_t * kernel_map_in_word(uint8_t * word, struct proc * proc){
  //the index of the page in the proc's addr space
  uint16_t page_in_proc;
  //real page that the pointer resides in
  uint16_t page1;
  //get which page the pointer is in the proc
  page_in_proc = (uint16_t)word >> MMU_PAGE_SIZE_SHIFT;
  //load real pages
  page1 = proc->mem_map[page_in_proc];
  //check that page is actually mapped in
  if(!(page1 & 0b10000000)){
    return NULL;
  }
  //clear assigned bit
  page1 = page1 & 0b01111111;

  //map into kernel addr space
  mmu_set_page(KERNEL_MEM_MAP_PAGE_3, page1 | 0b10000000);
  //return the pointer
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_3 << MMU_PAGE_SIZE_SHIFT) +
  ((uint16_t)word & MMU_PAGE_SIZE_MASK);
}