#include "include/stdint.h"

/* mmu layout
 * -- Virtual Memory Addr to Physical --
 * The high 5 bits of an addr are the page, low 11 addr in that page (2k pages)
 * The PTB register is added to the high 5 bits, and used as addr in page table
 * -- MMU Table Layout --
 * 2k pages, 128k total memory
 * 2^11 Entries on the table, each being composed of {(1 bit - page enabled),(6 bits - page(of 64 physical pages))}
 * Each process can access 2^5 pages - proc 0 (kenel) is entries 0-31, proc 1 entries 32-63, proc 2 64-47
 * Therefore, the high 6 bits of entry addr is the proc, the low 5 bits the page
 *
 */

#define pid_t uint8_t

#define MMU_NUM_PROCS 64
#define MMU_PAGE_SIZE 2048
#define MMU_PAGE_SIZE_SHIFT 11
#define MMU_PAGE_SIZE_MASK 2047

#define PROC_MMU_SHIFT 5
#define PROC_MMU_PAGES 32

//a value for the mmu table that marks a page as not used
//the top bit marks it as not used, rest being ones choosen to be distinct
#define MMU_UNUSED 0b1111111

/* Process State */

//a dead process - used in conjunction with in_use=0
#define PROC_STATE_DEAD 0
//a process able to be sheduled
#define PROC_STATE_RUNNABLE 1
//a process waiting for something (waiting currently not implemented)
#define PROC_STATE_WAITING 2
//a process waiting partway thorugh init (probably needs memory to be read in, file entries set)
//the process will have at least the in_use flag set
#define PROC_STATE_INIT 3
//the kernel process - sheduler shouldn't run on it (it is just used for resource allocation for the kernel)
#define PROC_STATE_IS_KERNEL 255

/* Process Table entries */

/* process memory object struct
 * this represents the memory bindings for the process, but not its mmu table - that is kept in struct proc
 * this struct keeps track of what the pages are, not what their allocation is */
/* proc memory layout (starting from low page)
 * :A number of instruction pages -\ Currently, as binaries don't have seperate instr and data pages,
 * :A number of data pages        -/ both of these are kept in the data pages
 * :unassigned
 * :A number of stack pages (may be just one, or more allocated specificly)
 */
struct proc_mem{
    //number of instruction pages - this is fixed after loading
    uint8_t instr_pages;
    //number of data pages - this is init'd on loading, but can change via sbrk or similair
    uint8_t data_pages;
    //number of stack pages, starting at the highest memory addr - starts at PROC_DEFAULT_STACK_PAGES
    uint8_t stack_pages;
};

/* process cpu state struct. describes the following:
 * a, b, sp, and pc regs
 * the ptb reg doesn't have to be stored - it is always proc.mmu_index << PROC_MMU_SHIFT
 * the priv reg doesn't need to be stored - it is always usr priv (1)
 */

struct proc_cpu_state {
    uint16_t A_reg;
    uint16_t B_reg;
    uint16_t SP_reg;
    uint16_t PC_reg;
};

//process entry struct
struct proc {
    //If this entry is in use
    uint8_t in_use;
    //The process id number (NOT the index in the table)
    pid_t pid;
    //The processes parent
    pid_t parent;
    //the processes state
    uint8_t state;
    //the processes current cpu state
    struct proc_cpu_state cpu_state;

    //the memory table for the process - the proc's memory map starts at its index in the table << PROC_MMU_SHIFT
    //a value > 0b10000000 indicates an assigned page (low 7 bytes being mmu entry), a zero unassigned
    //-mmu entries are 7 bits, so high bit doesn't matter to mmu - in this, it marks assigned.
    uint8_t mem_map[PROC_MMU_PAGES];
    //the proc_mem struct for the process - keeps track of which pages are which
    struct proc_mem mem_struct;

    //pointers to file_entry in file_table
    //file descripter 0 coresponds to the 0 entry in this array, etc
    unsigned int files[PROC_NUM_FILES];

    //this proc's mmu number (also its index in the proc_table) - THIS SHOULD NOT BE WRITTEN after proc_init_table
    uint8_t mmu_index;
};