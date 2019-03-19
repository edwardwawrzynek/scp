#include "include/defs.h"
#include "fs/fs.h"
#include "kernel/proc.h"
#include "kernel/mmu.h"
#include "kernel/mmu_asm.h"
#include "include/lib/kstdio_layer.h"
#include "kernel/panic.h"
#include "kernel/shed.h"


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

/* create the init process from the /init binary, and run it
 * init doesn't have stdin, stdout, or stderr, and has to open it itself */
void kernel_start_init(char * initpath){
  uint16_t init_inum = fs_path_to_inum(initpath, 2, 2);
  if(!init_inum){
    panic(PANIC_NO_INIT_FILE);
  }
  /* give init pid 2 (pid 1 is symbolic for orphaned procs) */
  proc_current_pid_alloc++;
  /* don't give init a parent */
  struct proc * proc = proc_create_new(init_inum, 0, 2, 2);

  /* return from kernel */
  shed_shedule();
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

  //only load 2nd page if the pointer isn't pointing to the last page
  if(page_in_proc != 31){
    page2 = (proc->mem_map[page_in_proc]);
    //check that page is actually mapped in
    if(!(page2 & 0b10000000)){
      return NULL;
    }

  } else {
    page2 = MMU_UNUSED;
  }
  //map into kernel addr space
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_1] = page1;
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_2] = page2;
  proc_write_mem_map(&proc_table[0]);
  //return the pointer
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_1 << MMU_PAGE_SIZE_SHIFT) +
  ((uint16_t)pointer & MMU_PAGE_SIZE_MASK);
}

/**
 * map a pointer from a proc's addr space into the kernels
 * can map up to 2048 bytes (TODO: make this a variable size limit)
 * maps the pointer to the last 2 pages 2 before the stack page in the kernel addr space
 * returns (uint8_t *) - NULL on failure, or a pointer in the kernel addr space, valid until the next call to kernel_map_in_mem2
 * by using this and kernel_map_in_mem, two buffers can be mapped in at once */
uint8_t * kernel_map_in_mem2(uint8_t * pointer, struct proc * proc){
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

  //only load 2nd page if the pointer isn't pointing to the last page
  if(page_in_proc != 31){
    page2 = (proc->mem_map[page_in_proc]);
    //check that page is actually mapped in
    if(!(page2 & 0b10000000)){
      return NULL;
    }

  } else {
    page2 = MMU_UNUSED;
  }
  //map into kernel addr space
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_3] = page1;
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_4] = page2;
  proc_write_mem_map(&proc_table[0]);
  //return the pointer
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_3 << MMU_PAGE_SIZE_SHIFT) +
  ((uint16_t)pointer & MMU_PAGE_SIZE_MASK);
}