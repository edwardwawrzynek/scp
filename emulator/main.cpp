#include <iostream>
#include <cstdint>

#include "cpu.h"

/* cpu functions */

/**
 * reset the cpu's reg, priv_lv, pc, ptb, flags reg, and page_table
 * don't touch memory */
void CPU::reset() {
    for(int i = 0; i < 16; i++){
        regs[i] = 0;
    }
    pc = 0;
    priv_lv = 0;
    ptb = 0;
    flags = 0;
    for(int i = 0; i < 4096; i++){
        page_table[i] = 0;
    }
}

/**
 * calculate the physical addr from a 16 bit addr
 * basically just does a page lookup */
uint32_t CPU::hard_addr(uint16_t addr) {
    uint32_t res;
    uint16_t real_ptb, low_addr, high_addr;

    /* if sys(0) priv_lv, 0 is ptb */
    real_ptb = (priv_lv ? ptb : 0);
    /* ptb is only twelve bits */
    real_ptb = real_ptb & 0b0001111111111111;
    /* get low and high parts of addr */
    low_addr = addr & 0b0000011111111111;
    high_addr = addr >> 1;
    /* page lookup */
    res = page_table[high_addr + real_ptb] << 11;
    res += low_addr;

    return res;
}

/**
 * read a byte from memory
 * no alignment needed */
uint8_t CPU::read_byte(uint16_t addr) {
    return mem[hard_addr(addr)];
}

/**
 * read a word from memory
 * the word must be 2 byte aligned
 * if the addr isn't aligned, the aligned word at (addr & 0xfffe) is read anyway */
uint16_t CPU::read_word(uint16_t addr){
    /* align */
    addr = hard_addr(addr) & 0b1111111111111110;
    /* read */
    return mem[addr] + (mem[addr + 1] << 8);
}

/**
 * write a byte to memory
 * no alignment needed */
void CPU::write_byte(uint16_t addr, uint8_t val){
    mem[hard_addr(addr)] = val;
}

/**
 * write a word to memory
 * must be 2 byte aligned
 * if not aligned, will be written on the aligned barrier anyway */
void CPU::write_word(uint16_t addr, uint16_t val){
    /* align */
    addr = hard_addr(addr) & 0b1111111111111110;
    /* write */
    mem[addr] = val & 0x00ff;
    mem[addr + 1] = val >> 8;
}

/**
 * run the alu on two numbers
 * perform the operation specified by opcode
 * undefined opcodes return a */
uint16_t CPU::alu(uint8_t opcode, uint16_t a, uint16_t b) {
    switch(opcode){
        case 0: return a | b;
        case 1: return a ^ b;
        case 2: return a & b;
        case 3: return a << b;
        case 4: return (uint16_t)a >> (uint16_t)b;
        case 5: return (int16_t)a >> (int16_t)b;
        case 6: return a + b;
        case 7: return a - b;
        case 8: return a * b;
        case 9: return ~a;
        case 10: return -a;
        default: return a;
    }
}

/**
 * Run the alu compare, and set flags based on the result */
void CPU::alu_cmp(uint16_t a, uint16_t b) {
    /* clear flags */
    flags = 0;
    /* set each bit */
    if(a == b) {
        flags |= 0b00001;
    }
    if((uint16_t)a < (uint16_t)b) {
        flags |= 0b00010;
    }
    if((uint16_t)a > (uint16_t)b) {
        flags |= 0b00100;
    }
    if((int16_t)a < (int16_t)b) {
        flags |= 0b01000;
    }
    if((int16_t)a > (int16_t)b) {
        flags |= 0b10000;
    }
}