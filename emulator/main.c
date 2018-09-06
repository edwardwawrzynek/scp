#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

//cpu state structure
struct cpu {
    //Primary Registers
    uint16_t reg_a;
    uint16_t reg_b;
    //Program Counter
    uint16_t reg_pc;
    //Stack pointer
    uint16_t rep_sp;
    //Machine privilage level (0=sys, 1=usr)
    uint8_t reg_priv;
    //MMU memory map (higest bit is ignored on each entry)
    /* mmu layout
     * -- Virtual Memory Addr to Physical --
     * The high 5 bits of an addr are the page, low 11 addr in that page (2k pages)
     * The PTB register is added to the high 5 bits, and used as addr in page table
     * -- MMU Table Layout --
     * 2k pages, 128k total memory
     * 2^11 Entries on the table, each being composed of {(1 bit - page enabled),(6 bits - page(of 64 physical pages))}
     * Each process can access 2^5 pages - proc 0 (kenel) is entries 0-31, proc 1 entries 32-63, proc 2 64-47
     * Therefore, the high 6 bits of entry addr is the proc, the low 5 bits the page*/
    //Page Table Base (PTB) register (only low 11 bytes used)
    uint16_t reg_ptb;
    uint8_t mmu_table[2048];
    //physical memory (128 k)
    uint8_t memory[131072];
};

//Read from machine memory
uint8_t cpu_read_mem(struct cpu * cpu, uint16_t addr){
    uint16_t high_addr, low_addr;
    //Get low addr from addr
    low_addr = addr & 0x7ff;
    high_addr = (addr & 0xf800) >> 11;
    //get real high_addr through mmu_table
    high_addr = cpu->mmu_table[(cpu->reg_priv ? cpu->reg_ptb : 0) + high_addr];
    return cpu->memory[(high_addr << 11) + low_addr];
}

//Write to machine memory
uint8_t cpu_write_mem(struct cpu * cpu, uint16_t addr, uint8_t val){
    uint16_t high_addr, low_addr;
    //Get low addr from addr
    low_addr = addr & 0x7ff;
    high_addr = (addr & 0xf800) >> 11;
    //get real high_addr through mmu_table
    high_addr = cpu->mmu_table[(cpu->reg_priv ? cpu->reg_ptb : 0) + high_addr];
    cpu->memory[(high_addr << 11) + low_addr] = val;
}

//Load and cpu's memory from a binary file (writes directly to physical memory, not based on mmu)
//Used to write startup memory
void cpu_init_mem(struct cpu * cpu, char * file_path){
    FILE * fp;
    char c;
    uint16_t addr;

    fp = fopen(file_path, "r");
    if(fp == NULL){
        printf("No such file: %s\n", file_path);
        exit(1);
    }
    addr = 0;

    while((c=fgetc(fp)) != EOF){
        cpu->memory[addr++] = c;
    }
}

//Init the cpu state to that of scp on power on
void cpu_init(struct cpu * cpu){
    //Create mmu_table (only first proc's addr space is inited)
    for(uint16_t i = 0; i < 32; i++){
        cpu->mmu_table[i] = i;
    }
}

struct cpu c;

int main(){
    cpu_init(&c);
    cpu_read_mem(&c, 0x200f);
}