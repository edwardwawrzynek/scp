#include "include/defs.h"
#include "fs/fs.h"
#include "fs/file.h"
#include "kernel/proc.h"
#include "kernel/mmu.h"
#include "kernel/mmu_asm.h"
#include "include/lib/kstdio_layer.h"
#include "kernel/panic.h"
#include "kernel/shed.h"
#include "dev/dev.h"
#include "lib/kmalloc.h"
#include "kernel/kernel_asm.h"


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
  kstdio_layer_init(DEV_NUM_TTY);
  printf("Booting Kernel\nInit MMU System\t\t\t[ \x1b[92mOK\x1b[39m ]\nStart Filesystem\t\t[ \x1b[92mOK\x1b[39m ]\nStart Proccess System\t\t[ \x1b[92mOK\x1b[39m ]\nStart IO System\t\t\t[ \x1b[92mOK\x1b[39m ]\n");
}

/* create the init process from the /init binary, and run it
 * init doesn't have stdin, stdout, or stderr, and has to open it itself 
 * return on failure */
void kernel_start_init(char * initpath, uint8_t print_ok){
  uint16_t init_inum = fs_path_to_inum(initpath, 2, 2);
  if(!init_inum){
    return;
  }
  /* give init pid 2 (pid 1 is symbolic for orphaned procs) */
  proc_current_pid_alloc++;
  /* don't give init a parent */
  struct proc * proc = proc_create_new(init_inum, 0, 2, 2);

  if(proc == NULL) return;

  if(print_ok) printf("[ \x1b[92mOK\x1b[39m ]\n");

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
  if(IS_MMU_UNASSIGNED(page1)) {
    return NULL;
  }

  //only load 2nd page if the pointer isn't pointing to the last page
  if(page_in_proc != 31){
    page2 = (proc->mem_map[page_in_proc]);
    //check that page is actually mapped in
    if(IS_MMU_UNASSIGNED(page2)){
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

/* map in aligned pages from a proc */
uint8_t * kernel_map_in_mem_aligned_0(uint8_t page, struct proc * proc) {
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_1] = proc->mem_map[page];
  proc_write_mem_map(&proc_table[0]);
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_1 << MMU_PAGE_SIZE_SHIFT);
}

uint8_t * kernel_map_in_mem_aligned_1(uint8_t page, struct proc * proc) {
  proc_table[0].mem_map[KERNEL_MEM_MAP_PAGE_2] = proc->mem_map[page];
  proc_write_mem_map(&proc_table[0]);
  return (uint8_t *)(KERNEL_MEM_MAP_PAGE_2 << MMU_PAGE_SIZE_SHIFT);
}

void kernel_exit() {
  printf("Flush Filesystem to disk\t");
  fs_close();
  printf("[ \x1b[92mOK\x1b[39m ]\nShutdown\t\t\t[ \x1b[92mOK\x1b[39m ]\n");
}

void kernel_shutdown() {
  printf("\n");
  kernel_exit();
  while(1);
}

/* kind of hacky
   we load the bios from disk into a malloc'd buffer, copy to last 512 bytes, and jump to it */
void kernel_reboot() {
  printf("\nLoading bootloader for reboot\t");
  uint16_t bios_inum = fs_path_to_inum("/etc/bios", 2, 2);
  if(!bios_inum) panic(PANIC_NO_BIOS_FILE);
  struct file_entry * bios = file_get(bios_inum, FILE_MODE_READ);
  if(bios == NULL) panic(PANIC_NO_BIOS_FILE);
  uint8_t * buf = kmalloc(512);
  if(buf == NULL) panic(PANIC_NO_BIOS_FILE);
  memset(buf, 0, 512);
  uint16_t bytes = file_read(bios, buf, 512);
  if(bytes == 0) panic(PANIC_NO_BIOS_FILE);

  printf("[ \x1b[92mOK\x1b[39m ]\n");
  kernel_exit();

  /* reset kernel mem map, but this may clear pages holding kmalloc'd pages */
  /* copy buf to addr 0 (disable write protection first) */
  proc_table[0].mem_map[0] &= ~(MMU_TEXT_FLAG);
  mmu_set_ptb(0);
  proc_write_mem_map(&proc_table[0]);
  uint8_t *newbuf = NULL;
  memcpy(newbuf, buf, 512);
  /* clear text protection on kernel pages and reset map */
  for(uint8_t i = 0; i < 32; i++) {
    proc_table[0].mem_map[i] = i | MMU_ASSIGN_FLAG;
  }

  mmu_set_ptb(0);

  /* write kernel mem map */
  proc_write_mem_map(&proc_table[0]);

  /* we need to load bootloader in non stack using asm, as loading bootloader block wrecks stack */
  kernel_load_bootloader_block(newbuf);
}
