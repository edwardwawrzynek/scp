#include "include/defs.h"
#include <lib/string.h>
#include "kernel/mmu.h"
#include "kernel/mmu_asm.h"
#include "kernel/proc_asm.h"
#include "kernel/palloc.h"
#include "fs/file.h"
#include "kernel/kernel.h"
#include "kernel/panic.h"
#include "include/panic.h"
#include "kernel/proc.h"

/* process table */

struct proc proc_table[PROC_TABLE_ENTRIES];

//current pid assignment - incremented with each new process - a process likely won't still hold a reference once the pid loops around
pid_t proc_current_pid_alloc = 0;

//the currently executing process (or NULL if a process hasn't been inited)
struct proc * proc_current_proc;

//regs for loading in proc_begin_execute
uint16_t proc_begin_execute_regs[16];
uint16_t proc_begin_execute_pc_reg;
//cmp1 and cmp2 are used by proc_finish execute, this is just to keep track of it while figuring out what to compare
uint8_t  proc_begin_execute_cond_reg;
//two value to compare to set the right condition code value in proc_finish_execute
uint16_t proc_begin_execute_cmp1;
uint16_t proc_begin_execute_cmp2;

#define proc_alloc_pid() proc_current_pid_alloc++

/* initilize the proc table - set mmu_index
 * this is only called from kernel_init() - mmu_index tags aren't changed after init
 * returns (none) */

void proc_init_table(){
    uint8_t i;
    for(i = 0; i < PROC_TABLE_ENTRIES; ++i){
        proc_table[i].mmu_index = i;
    }
}

/* get an empty entry in the process table
 * returns (struct proc *) - the new entry, with in_use marked */

struct proc *proc_alloc(){
    unsigned int i;
    for(i = 0; i < PROC_TABLE_ENTRIES; ++i){
        if(!proc_table[i].in_use){
            return proc_table + i;
        }
    }
    panic(PANIC_PROC_TABLE_FULL);
}

/* get the process table entry for a specific pid
 * returns (struct proc *) - the entry, or NULL if there is no entry matching the pid */

struct proc *proc_get(pid_t pid){
    unsigned int i;
    for(i = 0; i < PROC_TABLE_ENTRIES; ++i){
        if(proc_table[i].pid == pid && proc_table[i].in_use){
            return proc_table + i;
        }
    }
    return NULL;
}

/* write a proc's mmu map to the mmu_table */
void proc_write_mem_map(struct proc * proc){
    mmu_proc_table_out(proc->mem_map, (proc->mmu_index) << PROC_MMU_SHIFT);
}

/* init the kernel entry in the process table
 * mark as in use, set pid, set parent to NULL, set state, and create a memory map,
 * allocating the pages with palloc_new() (marks them in page table)
 * returns (none) */
void proc_init_kernel_entry(){
    struct proc * entry;
    uint8_t page;
    //get first entry
    entry = proc_table;
    //mark entry as in_use
    entry->in_use = 1;
    //pid of kernel is zero
    proc_current_pid_alloc = 0;
    entry->pid = proc_alloc_pid();
    //no parent
    entry->parent = NULL;
    //make the sheduler and related ignore the kernel
    entry->state = PROC_STATE_IS_KERNEL;
    /* allocate memory
     * note: if no pages have been marked as in use, this will allocate the pages from 0-31 in order
     * this is the current configuration on startup - this won't mess it up
     * palloc_new() is used just to properly mark them as in use in the palloc use table */
    for(page = 0; page < 32; ++page){
        entry->mem_map[page] = palloc_new();
    }
    //write out memory map
    proc_write_mem_map(entry);
}
/* init's the mem_map for a process from the the proc's proc_mem struct
 * takes a struct proc and inits mem_map from the proc_mem in the proc
 * returns (none) */

void proc_init_mem_map(struct proc * proc){
    uint16_t addr, i;
    addr = 0;
    i = 0;
    //init the instr pages
    for(i = 0; i < (proc->mem_struct.instr_pages); ++i){
        proc->mem_map[addr++] = palloc_new();
    }
    //init the data pages
    for(i = 0; i < (proc->mem_struct.data_pages); ++i){
        proc->mem_map[addr++] = palloc_new();
    }
    //init the stack pages
    addr = 31;
    for(i = 0; i < (proc->mem_struct.stack_pages); ++i){
        proc->mem_map[addr--] = palloc_new();
    }
}

/* creates a new process entry from a parent pid
 * doesn't init memory contents or memory layout
 * returns (struct proc *) the process entry */

struct proc * proc_new_entry(pid_t parent){
    struct proc * res;
    //get a new entry
    res = proc_alloc();
    //mark as in use
    res->in_use = 1;
    //get an id
    res->pid = proc_alloc_pid();
    //set parnet
    res->parent = parent;
    //set cpu state for execution
    memset(res->cpu_state.regs, 0, sizeof(uint16_t) * 16);
    res->cpu_state.pc_reg = 0;
    //start with a valid state
    res->cpu_state.cond_reg = COND_REG_INIT;
    //put in an init'd state
    res->state = PROC_STATE_INIT;

    return res;
}

/* load the memory, create a memory layout, and write the memory for a process from a binary
 * returns (uint16_t) - 0 on success, a true value on failure */
uint16_t proc_load_mem(struct proc * proc, struct file_entry * file){
    uint8_t * mapped_in;
    uint8_t * addr;
    uint16_t bytes_read;
    //get size, and set the number of pages appropriately
    //TODO: read binary header
    proc->mem_struct.instr_pages = 0;
    proc->mem_struct.data_pages = (file->ind->size >> MMU_PAGE_SIZE_SHIFT) + 1;
    proc->mem_struct.stack_pages = PROC_DEFAULT_STACK_PAGES;
    //init memory
    proc_init_mem_map(proc);
    //write out memory map
    proc_write_mem_map(proc);

    //load the contents of the file into process memory
    addr = 0;
    file_seek(file, 0, SEEK_SET);
    do{
        if((mapped_in = kernel_map_in_mem(addr, proc)) == NULL){
            return 1;
        };
        bytes_read = file_read(file, mapped_in, MMU_PAGE_SIZE);
        addr += bytes_read;
    } while(bytes_read == MMU_PAGE_SIZE);
    //only return success if whole file was loaded
    return ((uint16_t)addr != file->ind->size);
}

/* create a new process in a ready to run state from a parent pid, a binary file inode number
 * TODO: create other process resources here
 * returns (struct proc *) - the process, or NULL on failure */

struct proc * proc_create_new(pid_t parent, uint16_t inum){
    struct proc * res;
    struct file_entry * file;
    res = proc_new_entry(parent);
    //open file
    file = file_get(inum, FILE_MODE_READ);
    if(!file){
        proc_put(res);
        return NULL;
    }
    //read in memory
    if(proc_load_mem(res, file)){
        file_put(file);
        proc_put(res);
        return NULL;
    };
    //set in runnable state
    res->state = PROC_STATE_RUNNABLE;
    return res;
}

/* set the cpu state of a proc (should only be called from int handlers)
 * pass the real pc, not the one gotten from the interupt handler that is one byte to far
 * returns (none) */

void proc_set_cpu_state(struct proc * proc, uint16_t * regs, uint16_t pc_reg, uint8_t cond_reg){
    proc->cpu_state.pc_reg = pc_reg;
    proc->cpu_state.cond_reg = cond_reg;
    memcpy(proc->cpu_state.regs, regs, sizeof(uint16_t)*16);
}

/* set proc_begin_execute_cmp1 and cmp2 given a condition code */
void proc_set_cmp_flags(uint8_t cond_code){
    switch(cond_code){
        //equal
        case 0b00001:
            proc_begin_execute_cmp1 = 0;
            proc_begin_execute_cmp2 = 0;
            break;
        //unsigned and signed less than
        case 0b01010:
            proc_begin_execute_cmp1 = 0;
            proc_begin_execute_cmp2 = 1;
            break;
        //unsigned and signed greater than
        case 0b10100:
            proc_begin_execute_cmp1 = 1;
            proc_begin_execute_cmp2 = 0;
            break;
        //signed greater than, and unsigned less than
        case 0b10010:
            proc_begin_execute_cmp1 = 0;
            proc_begin_execute_cmp2 = -1;
            break;
        //signed less than, and unsigned greater than
        case 0b01100:
            proc_begin_execute_cmp1 = -1;
            proc_begin_execute_cmp2 = 0;
            break;


        default:
            panic(PANIC_NOT_VALID_CMP_CODE);
    }
}

/* switch execution to a process, using the proc cpu_state entry
 * if the switch works, it doesn't return
 * returns if failure (likely because the proc isn't in a runnable state) */

uint8_t proc_begin_execute(struct proc * proc){
    //check that the proc can be run
    if(proc->state != PROC_STATE_RUNNABLE){
        return 1;
    }
    //set the proc to be the one currently running
    proc_current_proc = proc;

    //set ptb
    mmu_set_ptb(proc->mmu_index << PROC_MMU_SHIFT);
    //load value from cpu_state into cpu_begin_execute variables so that the asm routine can use them
    memcpy(proc_begin_execute_regs, proc->cpu_state.regs, sizeof(uint16_t)*16);
    proc_begin_execute_pc_reg = proc->cpu_state.pc_reg;
    proc_begin_execute_cond_reg = proc->cpu_state.cond_reg;
    //find values to compare to get proper condition code
    proc_set_cmp_flags(proc_begin_execute_cond_reg);

    //call the asm routine that will start up the right context from the proc_begin_execute vars, and jump to the function. It expects the ptb and all proc_begin_execute vars to be set;
    proc_finish_execute();

    //something went wrong -
    panic(PANIC_CONTEXT_SWITCH_FAILURE);
}

/* release a process from the process table, clearing its memory and other resources
 * returns (none) */

void proc_put(struct proc * proc){
    //mark as not in_use
    proc->in_use = 0;
    //set state
    proc->state = PROC_STATE_DEAD;
    //clear memory map
    proc_put_memory(proc);

    //TODO: deallocate other resources
}

/* release the memory map associated with a process, freeing all pages - doesn't clear the pages
 * returns (none) */

/* TODO: move this into palloc_free, and keep refs there */

void proc_put_memory(struct proc * proc){
    unsigned int i;
    for(i = 0; i < PROC_MMU_PAGES; ++i){
        //only palloc release if the page had been allocd
        if(proc->mem_map[i] & 0b10000000){
            palloc_free(proc->mem_map[i]);
            proc->mem_map[i] = 0;
        } else {
            //mark it as clear for mmu anyway
            proc->mem_map[i] = 0;
        }
    }
    mmu_proc_table_out(proc->mem_map, (proc->mmu_index) << PROC_MMU_SHIFT);
}