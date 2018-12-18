/* This file was automatically generated.  Do not edit! */
_int_reset_timer(uint16_t n);
_int5_handler();
_int4_handler();
_int3_handler();
_int2_handler();
_int1_handler();
_int0_handler();
/* This file was automatically generated.  Do not edit! */
kernel_map_in_mem(uint8_t *pointer,struct proc *proc);
kernel_init();
/* This file was automatically generated.  Do not edit! */
mmu_init_clear_table();
mmu_set_page(uint16_t page_addr,uint8_t value);
mmu_proc_table_out(unsigned char *table,unsigned int offset);
/* This file was automatically generated.  Do not edit! */
palloc_free(uint8_t i);
palloc_new();
extern uint8_t palloc_page_in_use[MMU_NUM_PROCS];
/* This file was automatically generated.  Do not edit! */
panic(uint8_t error);
/* This file was automatically generated.  Do not edit! */
proc_put_memory(struct proc *proc);
proc_begin_execute(struct proc *proc);
proc_set_cpu_state(struct proc *proc,uint16_t a,uint16_t b,uint16_t pc,uint16_t sp);
proc_put(struct proc *proc);
proc_create_new(pid_t parent,uint16_t inum);
proc_load_mem(struct proc *proc,struct file_entry *file);
proc_new_entry(pid_t parent);
proc_init_mem_map(struct proc *proc);
proc_init_kernel_entry();
proc_write_mem_map(struct proc *proc);
proc_get(pid_t pid);
proc_alloc();
proc_init_table();
extern struct proc *proc_current_proc;
extern pid_t proc_current_pid;
extern struct proc proc_table[PROC_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
shed_shedule();
