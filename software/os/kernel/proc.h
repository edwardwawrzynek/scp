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
