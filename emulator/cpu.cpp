#include <fstream>
#include <iostream>

#include <cstdint>

#include "cpu.h"
#include "opcodes.h"

/* cpu functions */

/**
 * reset the cpu's reg, priv_lv, pc, ptb, flags reg to 1, and page_table
 * the page table is cleared, except for the first 32 entries which are set to their indexes
 * don't touch memory */
void CPU::reset() {
    for(int i = 0; i < 16; i++){
        regs[i] = 0;
    }
    pc = 0;
    priv_lv = 0;
    ptb = 0;
    /* set to 1 - at least 1 bit in flags will always be on after compares,
        and unconditional jumps rely on this - so it has to be true at startup */
    flags = 1;
    /* reset instr regs */
    instr_reg = 0;
    imd_reg = 0;

    /* clear page table, and set up memory for first process */
    for(int i = 0; i < 4096; i++) {
        if(i < 32){
            page_table[i] = i;
        } else {
            page_table[i] = 0;
        }
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
    real_ptb = real_ptb & 0b0000111111111111;
    /* get low and high parts of addr */
    low_addr = addr & 0b0000011111111111;
    high_addr = addr >> 11;

    /* page lookup */
    res = (page_table[high_addr + real_ptb] & 0b01111111) << 11;
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

/**
 * sign extend the value */
uint16_t CPU::sign_extend(uint16_t val){
    return (val & 0b10000000) ? (0xff00 | val) : (0x00ff & val);
}

/**
 * read a binary file into the machine's memory */
void CPU::read_file(const char * path){
    std::ifstream file;
    char buf[256];
    uint16_t addr;

    /* open file */
    file.open(path, std::ios::in | std::ios::binary);
    if(file.fail()) {
        std::cerr << "Error opening file: " << path << "\n";
        exit(0);
    }
    /*read into memory */
    addr = 0;
    do {
        file.read(buf, 256);
        for(int i = 0; i < file.gcount(); ++i){
            write_byte(addr++, buf[i]);
        }

    } while (! file.eof());

    file.close();
}

/**
 * execute and instruction given the immediate following it. This should only be called by run_instr. */
void CPU::execute(uint16_t instr, uint16_t imd) {
    /* load opcode (6 bits) */
    uint8_t opcode = instr >> 10;
    /* load byte/word and signed/unsigned bits used in ld and st */
    uint8_t is_byte = (instr >> 9) & 1;
    uint8_t is_signed = (instr >> 8) & 1;
    /* load regs encoded in instruction. The reg encoded in bits 3:0 is the primary reg (the one that can get written to), and the reg at 7:4 is the secondary reg (can't be written to, unless being used as a sp, in which case it can be inc'd/dec'd). */
    uint8_t reg_prim = instr & 0b1111;
    uint8_t reg_secd = (instr >> 4) & 0b1111;
    /* load the alu op out of alu instructions */
    uint8_t alu_op = (instr >> 8) & 0b1111;
    /* load the five bit condition code for conditional instructions */
    uint8_t cond_code = (instr >> 4) & 0b11111;

    /* scratch space */
    uint16_t val;

    /* actually execute */
    switch(opcode) {
        case NOP_N_N: /* nop.n.n - no operation*/
            break;

        case MOV_R_R: /* mov.r.r - copy reg to reg */
            regs[reg_prim] = regs[reg_secd];
            break;

        case CMP_R_F: /* cmp.r.f - compare regs and set flags reg */
            alu_cmp(regs[reg_prim], regs[reg_secd]);
            break;

        case ALU_R_R0: /* alu.r.r - run alu */
        case ALU_R_R1:
        case ALU_R_R2:
        case ALU_R_R3:
            regs[reg_prim] = alu(alu_op, regs[reg_prim], regs[reg_secd]);
            break;

        case ALU_R_I0: /* alu.r.i - run alu immediate */
        case ALU_R_I1:
        case ALU_R_I2:
        case ALU_R_I3:
            regs[reg_prim] = alu(alu_op, regs[reg_prim], imd);
            pc += 2;
            break;

        case LD_R_I: /* ld.r.i - load an immediate value into a register */
            regs[reg_prim] = imd;
            pc += 2;
            break;

        case LD_R_M: /* ld.r.mb/mbs/mw - load a value from a pc-relative address, sign extending if needed */

            /* load from memory */
            if(is_byte){
                val = read_byte(pc+imd);
            } else {
                val = read_word(pc+imd);
            }
            /* sign extend */
            if(is_signed){
                val = sign_extend(val);
            }

            regs[reg_prim] = val;
            pc += 2;

            break;

        case LD_R_P: /* ld.r.pb/pbs/pw - load a value pointed to be a register into memory - not pc relative */

            /* load from memory */
            if(is_byte){
                val = read_byte(regs[reg_secd]);
            } else {
                val = read_word(regs[reg_secd]);
            }
            /* sign extend */
            if(is_signed){
                val = sign_extend(val);
            }

            regs[reg_prim] = val;

            break;

        case LD_R_P_OF: /* ld.r.pb/pbs/pw.off - load a value pointed to be a register into memory plus an offset - not pc relative */

            /* load from memory */
            if(is_byte){
                val = read_byte(regs[reg_secd] + imd);
            } else {
                val = read_word(regs[reg_secd] + imd);
            }
            /* sign extend */
            if(is_signed){
                val = sign_extend(val);
            }

            regs[reg_prim] = val;
            pc += 2;

            break;

        case LD_R_RA: /* ld.r.ra - load the real address from a pc-relative addr */
            regs[reg_prim] = pc + imd;
            pc += 2;
            break;

        case ST_R_M: /* st.r.mb/mw - store a reg in a pc-relative addr */
            /* store to memory */
            if(is_byte){
                write_byte(pc+imd, regs[reg_prim]);
            } else {
                write_word(pc+imd, regs[reg_prim]);
            }
            pc += 2;
            break;

        case ST_R_P: /* st.r.pb/pw - store a reg in a non pc-relative addr pointed to be a reg */
            /* store to memory */
            if(is_byte){
                write_byte(regs[reg_secd], regs[reg_prim]);
            } else {
                write_word(regs[reg_secd], regs[reg_prim]);
            }
            break;

        case ST_R_P_OF: /* st.r.pb/pw.off - store a reg in a non pc-relative addr pointed to be a reg plus an offset*/
            /* store to memory */
            if(is_byte){
                write_byte(regs[reg_secd] + imd, regs[reg_prim]);
            } else {
                write_word(regs[reg_secd] + imd, regs[reg_prim]);
            }
            pc += 2;
            break;

        case JMP_C_J: /* jmp.c.j cond addr - do a conditional pc-relative jump */

            /* compare the condition code to flags reg */
            if(cond_code & flags){
                pc = pc + imd;
            } else {
                pc += 2;
            }
            break;

        case JMP_C_R: /* jmp.c.r - do a conditional jump to a non pc relative address in a register */

            /* compare the condition code to flags reg */
            if(cond_code & flags){
                pc = regs[reg_prim];
            }

            break;

        case PUSH_R_SP: /* push.r.sp - push a reg onto a stack */

            /* adjust stack pointer */
            regs[reg_secd] -= 2;

            /* write */
            write_word(regs[reg_secd], regs[reg_prim]);

            break;

        case POP_R_SP: /* pop.r.sp - pop a value off the stack into a reg */

            /* adjust stack pointer */
            regs[reg_secd] += 2;

            /* read from stack (-2 is because stack adjust happens first in pipeline) */
            regs[reg_prim] = read_word(regs[reg_secd]-2);
            break;

        case CALL_J_SP: /* call.j.sp sp addr - call a pc-relative address */
            /* adjust stack pointer */
            regs[reg_secd] -= 2;
            /* write pc - (with pc adjusted over immediate) */
            write_word(regs[reg_secd], pc + 2);
            /* set pc */
            pc = pc + imd;
            break;

        case CALL_R_SP: /* call.r.sp sp addr - call a non pc-relative address in a reg*/
            /* adjust stack pointer */
            regs[reg_secd] -= 2;
            /* write pc */
            write_word(regs[reg_secd], pc);
            /* set pc */
            pc = pc + regs[reg_prim];
            break;

        case RET_N_SP: /* ret.n.sp - return from a subroutine */
            /* adjust stack pointer */
            regs[reg_secd] += 2;
            /* read pc from stack */
            pc = read_word(regs[reg_secd] - 2);
            break;

        case OUT_R_P: /* out.r.p - write to an io subsystem */
            /* io port is encoded in immediate */

            break;

        default:
            /* unimplemented */
            std::cerr << "Unimplemented Op: " << std::hex << opcode << "\nIn instruction: " << instr << "\n";
            break;
    }
}

/**
 * run the next cpu instruction */
void CPU::run_instr() {
    /* execute */
    execute(instr_reg, imd_reg);

    /* set instr and imd reg */
    instr_reg = read_word(pc);
    imd_reg = read_word(pc + 2);
    /* increment program counter */
    pc = pc + 2;
}