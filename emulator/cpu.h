#include <cstdint>

class CPU {
    /* regfile */
    uint16_t regs[16];
    /* program counter */
    uint16_t pc;
    /* system privilage reg */
    uint8_t priv_lv;
    /* page table base reg*/
    uint16_t ptb;
    /* flags reg */
    uint8_t flags;
    /* the memory managment unit page table
        128 pages (256k memory) * 32 pages (64k) per process */
    uint8_t page_table[4096];
    /* the machine's memory - some will be device mapped memory*/
    uint8_t mem[262144];

    private:
    /* get the real physical addr in memory from a 16bit addr */
    uint32_t hard_addr(uint16_t addr);

    /* preform an alu operation on two operands */
    uint16_t alu(uint8_t opcode, uint16_t a, uint16_t b);
    /* comoare a and b, and set flags appropriatley */
    void alu_cmp(uint16_t a, uint16_t b);

    public:
    /* init the machine to startup state (not counting memory) */
    void reset();
    /* read from memory */
    uint8_t read_byte(uint16_t addr);
    uint16_t read_word(uint16_t addr);
    /* write to memory */
    void write_byte(uint16_t addr, uint8_t val);
    void write_word(uint16_t addr, uint16_t val);
};