#include <cstdint>
#include "io/io.h"
#include "debug.h"

#define MMU_ASSIGN_FLAG 0x8000
#define MMU_TEXT_FLAG   0x4000
#define MMU_PAGE_MASK   0x3fff

#define MMU_PTB_MASK    0xffff

#define pages_installed 256

class CPU {
    public:
    /* regfile */
    uint16_t regs[16];
    /* program counter */
    uint16_t pc;
    /* int pc copy reg */
    uint16_t ipc_reg;
    /* system privilage reg */
    uint8_t priv_lv;
    /* page table base reg*/
    uint16_t ptb;
    /* flags reg */
    uint8_t flags;
    /* interrupt request line - set high until int is handled */
    uint8_t irq_req[8];
    /* interrupt addresses */
    uint16_t int_vectors[8];
    /* countdown (in number of instructions executed) till next clock pulse int */
    int32_t time_till_clock_int;
    /* clock ticks (total) */
    uint64_t clock_ticks;
    /* the memory managment unit page table
        64 procs max * 32 pages (64k) per process */
    uint16_t page_table[2048];
    /* the machine's memory - some will be device mapped memory
        2048 pages x 2048 bytes per page
    */
    uint8_t mem[pages_installed * 2048];

    /* the instruction register - the last loaded instruction */
    uint16_t instr_reg;
    /* the imeddiate register - last loaded immediate */
    uint16_t imd_reg;

    /* if debug is enabled */
    bool debug_enabled;
    /* debug files */
    DebugFileInfo * debug_tables[128];

    /* the machine's io subsystem */
    IO io;

    private:
    /* get the real physical addr in memory from a 16bit addr */
    uint32_t hard_addr(uint16_t addr, uint8_t is_write);
    /* read from memory */
    uint8_t read_byte(uint16_t addr);
    uint16_t read_word(uint16_t addr);
    /* write to memory */
    void write_byte(uint16_t addr, uint8_t val);
    void write_word(uint16_t addr, uint16_t val);

    /* preform an alu operation on two operands */
    uint16_t alu(uint8_t opcode, uint16_t a, uint16_t b);
    /* compare a and b, and set flags appropriately */
    void alu_cmp(uint16_t a, uint16_t b);
    /* sign extend a value */
    uint16_t sign_extend(uint16_t val);

    /* execute an instruction */
    void execute(uint16_t instr, uint16_t imd);

    /* check and handle ints */
    void check_ints();

    /* do a nop debug instr */
    void nop_debug(uint16_t instr);


    public:
    /* init the machine to startup state (not counting memory), or io */
    void reset();
    /* start up the machine's io */
    void init_io(bool serial_en, bool gfx_en, bool disk_en, char * serial_port, char * disk_file, uint16_t clock_speed);
    /* update the machine's io */
    void update_io();
    /* read a binary file into memory */
    void read_file(const char * path);
    /* run a single cpu instruction cycle */
    void run_instr();
    /* request an int */
    void do_int(uint8_t irq_line);
    /* set debug file info */
    void set_debug_files(int num_files, char ** file_names);
};