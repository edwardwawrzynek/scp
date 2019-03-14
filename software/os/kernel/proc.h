/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void proc_put_memory(struct proc *proc);
void proc_release_resources(struct proc *proc);
uint16_t proc_set_next_open_fd(struct proc *proc,struct file_entry *file);
void proc_fork_resources(struct proc *parent,struct proc *child);
void proc_finish_return();
uint8_t proc_begin_execute(struct proc *proc);
void proc_set_cmp_flags(uint8_t cond_code);
void proc_set_cpu_state(struct proc *proc,uint16_t *regs,uint16_t pc_reg,uint8_t cond_reg);
void proc_put(struct proc *proc);
struct proc *proc_create_new(uint16_t inum,pid_t parent,uint16_t cwd,uint16_t croot);
uint16_t proc_set_brk(struct proc *proc,uint8_t *brk);
uint16_t proc_load_mem(struct proc *proc,struct file_entry *file);
struct proc *proc_new_entry(pid_t parent,uint16_t cwd,uint16_t croot);
void proc_reset_cpu(struct proc *proc);
void proc_init_mem_map(struct proc *proc);
void proc_kernel_expand_brk(uint8_t *brk);
void proc_init_kernel_entry();
void proc_write_mem_map(struct proc *proc);
uint16_t proc_is_zombie(struct proc *proc);
uint16_t proc_find_children(pid_t parent,pid_t *pid_list);
struct proc *proc_alloc();
void proc_init_table();
struct proc *proc_get(pid_t pid);
pid_t proc_alloc_pid();
extern struct proc *proc_current_proc;
extern pid_t proc_current_pid_alloc;
extern struct proc proc_table[PROC_TABLE_ENTRIES];
