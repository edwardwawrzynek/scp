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
