#include "include/defs.h"
#include <lib/string.h>
#include "kernel/mmu.h"
#include "kernel/mmu_asm.h"
#include "kernel/context_switch.h"
#include "kernel/context_vars.h"
#include "kernel/palloc.h"
#include "fs/file.h"
#include "kernel/kernel.h"
#include "kernel/panic.h"
#include "include/panic.h"
#include "kernel/proc.h"
#include "kernel/shed.h"
#include "lib/brk_loc/end.h"
#include <lib/kstdio_layer.h>
#include "kernel/proc.h"

/* process table */

struct proc proc_table[PROC_TABLE_ENTRIES];

//current pid assignment - incremented with each new process - a process likely won't still hold a reference once the pid loops around
pid_t proc_current_pid_alloc = 0;

//the currently executing process (or NULL if a process hasn't been inited)
struct proc * proc_current_proc;

pid_t proc_alloc_pid(){
    while(proc_get(proc_current_pid_alloc) || proc_current_pid_alloc == 0 || proc_current_pid_alloc == 1){
        proc_current_pid_alloc++;
    }

    return proc_current_pid_alloc;
}

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

/* go thorugh the proc list, and fill the passed array with all children (indexes of children,
 * not the pids) of the given pid
 * the passed array should be of size PROC_TABLE_ENTRIES
 * does include zombie children
 * returns number of children found - only these entries in pid_list are valid */
uint16_t proc_find_children(pid_t parent, pid_t * pid_list){
    uint16_t found = 0;
    /* Don't check that parent is invalid - we may be searching for parents of a proc we just killed */
    for(uint16_t i = 0; i < PROC_TABLE_ENTRIES; ++i){
        if(proc_table[i].parent == parent && proc_table[i].in_use){
            pid_list[found++] = i;
        }
    }

    return found;
}

/* return true if a process is a zombie */
uint16_t proc_is_zombie(struct proc * proc){
    if(proc->state == PROC_STATE_RUNNABLE || proc->state == PROC_STATE_WAITING){
        return 0;
    }
    return 1;
}

/* write a proc's mmu map to the mmu_table */
void proc_write_mem_map(struct proc * proc){
    mmu_proc_table_out(proc->mem_map, (proc->mmu_index) << PROC_MMU_SHIFT);
}

/* init the kernel entry in the process table
 * mark as in use, set pid, set parent to NULL, set state, and create a memory map,
 * allocating the pages with palloc_new() (marks them in page table)
 * also enables text write protection on kernel
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
    entry->pid = 0;
    //no parent
    entry->parent = NULL;
    //make the sheduler and related ignore the kernel
    entry->state = PROC_STATE_IS_KERNEL;
    /* allocate memory
     * note: mark the pages that have already been allocated to us as in use
     * this is the current configuration on startup - this won't mess it up
     * palloc_new() is used just to properly mark them as in use in the palloc use table 
     * also enable text seg protection (not enabled at startup) */
    /* read from the kernel header to get page sizes (very hacky) */
    uint16_t seg0_entry = *((uint16_t *)0);
    uint16_t seg1_entry = *((uint16_t *)2);
    //calculate info
    uint16_t seg0_size = (seg0_entry >> 5) & 0b11111;
    uint16_t seg0_offset = (seg0_entry) & 0b11111;
    uint16_t seg1_size = (seg1_entry >> 5) & 0b11111;
    uint16_t seg1_offset = (seg1_entry) & 0b11111;
    if(seg0_offset != 0 || seg1_offset != seg0_size || (((uint16_t)(&_BRK_END)-1)>>MMU_PAGE_SIZE_SHIFT)+1 != seg1_offset + seg1_size){
        panic(PANIC_KERNEL_HEADER_FORMAT_ERROR);
    }
    for(page = 0; page < seg1_offset + seg1_size; page++){
        entry->mem_map[page] = palloc_new();
    }
    entry->mem_struct.instr_pages = seg0_size;
    entry->mem_struct.data_pages = seg1_size;
    entry->mem_struct.stack_pages = 1;
    while(page < 30){
        entry->mem_map[page++] = MMU_UNUSED;
    }
    //alloc stack page (has to be page 31, we already have stuff in it)
    entry->mem_map[31] = palloc_alloc(31);
    //enable write protect
    proc_enable_text_write_protect(entry);
    //write out memory map
    proc_write_mem_map(entry);
}

/**
 * expand, if needed, the mem_map for the kernel, given a new brk */
void proc_kernel_expand_brk(uint8_t *brk){
    /*uint16_t page_in_kernel = ((uint16_t)brk >> MMU_PAGE_SIZE_SHIFT);
    for(int page = 0; page <= page_in_kernel; page++){
        if(IS_MMU_UNUSED(proc_table[0].mem_map[page])){
            proc_table[0].mem_map[page] = palloc_new();
        }
    }
    proc_write_mem_map(&proc_table[0]);*/
    if(proc_set_brk(&proc_table[0], brk)) {
        panic(0);
    }
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
        /* write protect is set after text is written by kernel into page */
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

/* make a proc's text segment write protected */
void proc_enable_text_write_protect(struct proc * proc) {
    for(int i = 0; i < (proc->mem_struct.instr_pages); ++i){
        /* write protect is set after text is written by kernel into page */
        proc->mem_map[i] |= MMU_TEXT_FLAG;
    }
    proc_write_mem_map(proc);
}

/* make a proc's text segment not write protected (for loading mem) */
void proc_disable_text_write_protect(struct proc * proc){
    for(int i = 0; i < (proc->mem_struct.instr_pages); ++i){
        /* write protect is set after text is written by kernel into page */
        proc->mem_map[i] &= MMU_CLEAR_TEXT;
    }
}

/* reset proc's cpu state
 * needed for a blank execution */
void proc_reset_cpu(struct proc * proc){
    //set cpu state for execution
    memset(proc->cpu_state.regs, 0, sizeof(uint16_t) * 16);
    proc->cpu_state.pc_reg = 0;
    //start with a valid state
    proc->cpu_state.cond_reg = COND_REG_INIT;
}

/* creates a new process entry from a parent pid
 * doesn't init memory contents or memory layout
 * returns (struct proc *) the process entry */

struct proc * proc_new_entry(pid_t parent, uint16_t cwd, uint16_t croot){
    struct proc * res;
    //get a new entry
    res = proc_alloc();
    //mark as in use
    res->in_use = 1;
    //get an id
    res->pid = proc_alloc_pid();
    //set parent
    res->parent = parent;
    //set directory info
    res->cwd = cwd;
    res->croot = croot;
    //return info
    res->has_retd = 0;
    res->ret_val = 0;

    //set cpu state for execution
    proc_reset_cpu(res);

    //clear file table
    memset(res->files, 0, sizeof(struct file_entry *) * PROC_NUM_FILES);

    //put in an init'd state
    res->state = PROC_STATE_INIT;

    return res;
}

/* read the header of a binary file into the proc_mem struct, or return 1 on failure */
uint16_t proc_bin_get_sizes(struct file_entry * file, struct proc_mem * mem){
    uint8_t c;
    uint16_t segs[4];
    file_seek(file, 0, SEEK_SET);
    for(int i = 0; i < 4; i++){
        segs[i] = 0;
        if(file_read(file, &c, 1) != 1){
            return 1;
        }
        segs[i] |= c;
        if(file_read(file, &c, 1) != 1){
            return 1;
        }
        segs[i] |= (c<<8);
    }
    file_seek(file, 0, SEEK_SET);
    /* get seg info */
    uint16_t cur_page = 0;
    for(int i = 0; i < 4; i++){
        uint16_t offset = segs[i]&0b11111;
        if(offset != cur_page){
            return 1;
        }
        uint16_t size = (segs[i]>>5)&0b11111;
        cur_page += size;
        if(i == 0){
            mem->instr_pages = size;
        } else if (i == 1){
            mem->data_pages = size;
        }

    }
    return 0;
}

/* load the memory, create a memory layout, and write the memory for a process from a binary
 * returns (uint16_t) - 0 on success, a true value on failure */
uint16_t proc_load_mem(struct proc * proc, struct file_entry * file){
    uint8_t * mapped_in;
    uint8_t * addr;
    uint16_t bytes_read;
    //get size, and set the number of pages appropriately
    /* Read sizes out of binary header */
    if(proc_bin_get_sizes(file, &(proc->mem_struct))){
        return -1;
    }
    //proc->mem_struct.instr_pages = 0;
    //proc->mem_struct.data_pages = (file->ind->size >> MMU_PAGE_SIZE_SHIFT) + 1;
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
            return -2;
        };
        bytes_read = file_read(file, mapped_in, MMU_PAGE_SIZE);
        addr += bytes_read;
    } while(bytes_read == MMU_PAGE_SIZE);
    //set proc brk to end of memory
    proc->mem_struct.brk = addr;
    //write protect text seg
    proc_enable_text_write_protect(proc);
    //only return success if whole file was loaded
    return ((uint16_t)addr != file->ind->size);
}

/* expand the proc's brk to a new value, allocating and mapping in new memory if needed
 * return 0 on success, 1 on failure (new brk would collide with stack) */
uint16_t proc_set_brk(struct proc *proc, uint8_t *brk){
    uint16_t old_brk = (uint16_t)proc->mem_struct.brk;
    /* check for collision with stack */
    if(((uint16_t)brk)>>MMU_PAGE_SIZE_SHIFT >= (32 - proc->mem_struct.stack_pages)){
        return 1;
    }
    /* make sure brk is clear of text pages */
    if(((uint16_t)brk)>>MMU_PAGE_SIZE_SHIFT < proc->mem_struct.instr_pages){
        return -1;
    }
    /* allocate new memory */
    uint16_t new_max_page = ((uint16_t)brk >> MMU_PAGE_SIZE_SHIFT);
    for(int page = 0; page <= new_max_page; page++){
        if(IS_MMU_UNASSIGNED(proc->mem_map[page])){
            proc->mem_map[page] = palloc_new();
            proc->mem_struct.data_pages++;
        }
    }
    /* if we need to, free old memory */
    if((uint16_t)brk < old_brk){
        uint16_t old_max_page = old_brk >> MMU_PAGE_SIZE_SHIFT;
        for(int page = old_max_page; page > new_max_page; page--){
            if(IS_MMU_ASSIGNED(proc->mem_map[page])){
                palloc_free(proc->mem_map[page]);
                proc->mem_map[page] = MMU_UNUSED;
                proc->mem_struct.data_pages--;
            }
        }
    }

    /* set brk */
    proc->mem_struct.brk = brk;

    proc_write_mem_map(proc);

    return 0;
}

/* create a new process in a ready to run state from a parent pid, a binary file inode number
 * used just to start up os, proc_new_entry is used for fork, etc
 * returns (struct proc *) - the process, or NULL on failure */

struct proc * proc_create_new(uint16_t inum, pid_t parent, uint16_t cwd, uint16_t croot){
    struct proc * res;
    struct file_entry * file;
    res = proc_new_entry(parent, cwd, croot);
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
    proc_reset_cpu(res);
    /* add errno (argc and argv are null) */
    uint16_t errno_default = 0;
    proc_add_to_stack(res, (uint8_t *)(&errno_default), 2);
    uint16_t data = 0;
    proc_add_to_stack(res, (uint8_t *)(&data), 2);
    proc_add_to_stack(res, (uint8_t *)(&data), 2);
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

/* set context_switch_cmp1 and cmp2 given a condition code */
void proc_set_cmp_flags(uint8_t cond_code){
    switch(cond_code){
        //equal
        case 0b00001:
            context_switch_cmp1 = 0;
            context_switch_cmp2 = 0;
            break;
        //unsigned and signed less than
        case 0b01010:
            context_switch_cmp1 = 0;
            context_switch_cmp2 = 1;
            break;
        //unsigned and signed greater than
        case 0b10100:
            context_switch_cmp1 = 1;
            context_switch_cmp2 = 0;
            break;
        //signed greater than, and unsigned less than
        case 0b10010:
            context_switch_cmp1 = 0;
            context_switch_cmp2 = -1;
            break;
        //signed less than, and unsigned greater than
        case 0b01100:
            context_switch_cmp1 = -1;
            context_switch_cmp2 = 0;
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
    memcpy(context_switch_regs, proc->cpu_state.regs, sizeof(uint16_t)*16);
    context_switch_pc_reg = proc->cpu_state.pc_reg;
    context_switch_cond_reg = proc->cpu_state.cond_reg;
    //find values to compare to get proper condition code
    proc_set_cmp_flags(context_switch_cond_reg);

    //call the asm routine that will start up the right context from the context_switch vars, and jump to the function. It expects the ptb and all context_switch vars to be set;
    context_switch_run_state();

    //something went wrong -
    panic(PANIC_CONTEXT_SWITCH_FAILURE);
}

/**
 * handle the return from a proc from an int, and shedule a new proc to run */
void proc_finish_return(){
    proc_set_cpu_state(proc_current_proc, context_switch_regs, context_switch_pc_reg, context_switch_cond_reg);
    shed_shedule();
}

/**
 * fork a process's system resources - only copy resources,
 * not state or other information. That is handled in fork system calls.
 * This needs to copy file descriptors, copy memory, copy cpu state
 * This writes new mem map */
void proc_fork_resources(struct proc * parent, struct proc * child){
    /* copy over file descriptors */
    memcpy(&child->files, &parent->files, sizeof(struct file_entry *) * PROC_NUM_FILES);
    /* inc refs on file descriptors */
    for(uint16_t i = 0; i < PROC_NUM_FILES; i++){
        if(child->files[i]){
            file_inc_refs(child->files[i]);
        }
    }

    /* copy over mem layout */
    memcpy(&child->mem_struct, &parent->mem_struct, sizeof(struct proc_mem));
    /* alloc pages TODO: use shared text segments */
    proc_init_mem_map(child);
    proc_write_mem_map(child);

    /* copy over pages */
    for(uint16_t i = 0; i < child->mem_struct.instr_pages + child->mem_struct.data_pages; i++){
        uint8_t * parent_page = kernel_map_in_mem_aligned_0(i, parent);
        uint8_t * child_page = kernel_map_in_mem_aligned_1(i, child);
        /* copy */
        memcpy(child_page, parent_page, MMU_PAGE_SIZE);
    }
    /* copy stack */
    uint16_t page = 31;
    for(uint16_t i = 0; i < (child->mem_struct.stack_pages); ++i){
        uint8_t * parent_page = kernel_map_in_mem_aligned_0(page, parent);
        uint8_t * child_page = kernel_map_in_mem_aligned_1(page, child);
        /* copy */
        memcpy(child_page, parent_page, MMU_PAGE_SIZE);
        page--;
    }

    proc_enable_text_write_protect(child);
    /* copy cpu state */
    memcpy(&child->cpu_state, &parent->cpu_state, sizeof(struct proc_cpu_state));

}

/* get next open file descriptor, and set it to file
 * return fd, or panic if non left */
uint16_t proc_set_next_open_fd(struct proc * proc, struct file_entry *file){
    for(uint16_t i = 0; i < PROC_NUM_FILES; i++){
        if(!proc->files[i]){
            proc->files[i] = file;
            return i;
        }
    }

    panic(PANIC_NO_FREE_FD);
}

/* release a process from the process table, clearing its memory and other resources
 * doesn't handle orphan or zombie processes - exit system call handles those
 * returns (none) */

void proc_put(struct proc * proc){
    //cean up resources - if the process is zombie, this has already been done
    if(proc->state != PROC_STATE_ZOMBIE){
        proc_release_resources(proc);
    }
    //mark as not in_use
    proc->in_use = 0;
    //set state
    proc->state = PROC_STATE_DEAD;
}

/* deallocate all resources associated with a process except its proc table entry
 * called by proc_put, and used to clean up zombie processes before their parent
 * calls wait on them */
void proc_release_resources(struct proc * proc){
    /* Realease memory */
    proc_put_memory(proc);
    /* Release open file descriptors */
    for(uint16_t i = 0; i < PROC_NUM_FILES; i++){
        if(proc->files[i]){
            file_put(proc->files[i]);
        }
    }
}

/* release the memory map associated with a process, freeing all pages - doesn't clear the pages
 * returns (none) */

void proc_put_memory(struct proc * proc){
    unsigned int i;
    for(i = 0; i < PROC_MMU_PAGES; ++i){
        //only palloc release if the page had been allocd
        if(proc->mem_map[i] & MMU_ASSIGN_FLAG){
            palloc_free(proc->mem_map[i]);
            proc->mem_map[i] = MMU_UNUSED;
        } else {
            //mark it as clear for mmu anyway
            proc->mem_map[i] = MMU_UNUSED;
        }
    }
    mmu_proc_table_out(proc->mem_map, (proc->mmu_index) << PROC_MMU_SHIFT);
}

/* add an aligned (multiple of two) amount of data to a proc's stack
 * used for passing argv, etc
 * shouldn't be used once a proc is running, as it cause issues
 * returns (uint8_t *) - the location of the memory on the stack*/
void * proc_add_to_stack(struct proc *proc, uint8_t * memory, uint16_t bytes){
    /* align */
    if(bytes&1){
        bytes++;
    }
    uint8_t *cur_sp = (uint8_t *)proc->cpu_state.regs[15];
    uint8_t * location = cur_sp - bytes;

    uint8_t * mem = kernel_map_in_mem(location, proc);
    memcpy(mem, memory, bytes);

    proc->cpu_state.regs[15] -= bytes;

    return location;
}
