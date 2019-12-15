/* This file was automatically generated.  Do not edit! */
void kernel_reboot();
void kernel_shutdown();
void kernel_exit();
uint8_t * kernel_map_in_mem_aligned_1(uint8_t page, struct proc * proc);
uint8_t * kernel_map_in_mem_aligned_0(uint8_t page, struct proc * proc);
void *kernel_map_in_mem(void *pointer_p,struct proc *proc);
void kernel_start_init(char *initpath,uint8_t print_ok);
void kernel_init();
