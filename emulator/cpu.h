#include <cstdint>
#include "io/io.h"

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
    /* the memory managment unit page table
        128 pages (256k memory) * 32 pages (64k) per process */
    uint8_t page_table[4096];
    /* the machine's memory - some will be device mapped memory*/
    uint8_t mem[262144];

    /* the instruction register - the last loaded instruction */
    uint16_t instr_reg;
    /* the imeddiate register - last loaded immediate */
    uint16_t imd_reg;

    /* the machine's io subsystem */
    IO io;

    private:
    /* get the real physical addr in memory from a 16bit addr */
    uint32_t hard_addr(uint16_t addr);
    /* read from memory */
    uint8_t read_byte(uint16_t addr);
    uint16_t read_word(uint16_t addr);
    /* write to memory */
    void write_byte(uint16_t addr, uint8_t val);
    void write_word(uint16_t addr, uint16_t val);

    /* preform an alu operation on two operands */
    uint16_t alu(uint8_t opcode, uint16_t a, uint16_t b);
    /* compare a and b, and set flags appropriatley */
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
    void init_io(bool serial_en, bool gfx_en, bool disk_en, char * serial_port, char * disk_file);
    /* update the machine's io */
    void update_io();
    /* read a binary file into memory */
    void read_file(const char * path);
    /* run a single cpu instruction cycle */
    void run_instr();
    /* request an int */
    void do_int(uint8_t irq_line);
};