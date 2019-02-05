/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void proc_put_memory(struct proc *proc);
void proc_finish_return();
uint8_t proc_begin_execute(struct proc *proc);
void proc_set_cmp_flags(uint8_t cond_code);
void proc_set_cpu_state(struct proc *proc,uint16_t *regs,uint16_t pc_reg,uint8_t cond_reg);
void proc_put(struct proc *proc);
struct proc *proc_create_new(pid_t parent,uint16_t inum);
uint16_t proc_load_mem(struct proc *proc,struct file_entry *file);
struct proc *proc_new_entry(pid_t parent);
void proc_init_mem_map(struct proc *proc);
void proc_kernel_expand_brk(uint8_t *brk);
void proc_init_kernel_entry();
void proc_write_mem_map(struct proc *proc);
struct proc *proc_get(pid_t pid);
struct proc *proc_alloc();
void proc_init_table();
extern struct proc *proc_current_proc;
extern pid_t proc_current_pid_alloc;
extern struct proc proc_table[PROC_TABLE_ENTRIES];
