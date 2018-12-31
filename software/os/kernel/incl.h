/* This file was automatically generated.  Do not edit! */
void _int_reset_timer(uint16_t n);
void _int5_handler();
void _int4_handler();
void _int3_handler();
void _int2_handler();
void _int1_handler();
void _int0_handler();
/* This file was automatically generated.  Do not edit! */
uint8_t *kernel_map_in_mem(uint8_t *pointer,struct proc *proc);
void kernel_init();
/* This file was automatically generated.  Do not edit! */
void mmu_init_clear_table();
void mmu_set_page(uint16_t page_addr,uint8_t value);
void mmu_proc_table_out(unsigned char *table,unsigned int offset);
/* This file was automatically generated.  Do not edit! */
void palloc_free(uint8_t i);
uint8_t palloc_new();
extern uint8_t palloc_page_in_use[MMU_NUM_PROCS];
/* This file was automatically generated.  Do not edit! */
void panic(uint8_t error);
/* This file was automatically generated.  Do not edit! */
void proc_put_memory(struct proc *proc);
void proc_begin_execute(struct proc *proc);
void proc_set_cpu_state(struct proc *proc,uint16_t a,uint16_t b,uint16_t pc,uint16_t sp);
void proc_put(struct proc *proc);
struct proc *proc_create_new(pid_t parent,uint16_t inum);
uint16_t proc_load_mem(struct proc *proc,struct file_entry *file);
struct proc *proc_new_entry(pid_t parent);
void proc_init_mem_map(struct proc *proc);
void proc_init_kernel_entry();
void proc_write_mem_map(struct proc *proc);
struct proc *proc_get(pid_t pid);
struct proc *proc_alloc();
void proc_init_table();
extern struct proc *proc_current_proc;
extern pid_t proc_current_pid;
extern struct proc proc_table[PROC_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
void shed_shedule();
