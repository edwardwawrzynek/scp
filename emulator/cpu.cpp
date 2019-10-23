#include <fstream>
#include <iostream>
#include <iomanip>

#include <cstdint>

#include "cpu.h"
#include "opcodes.h"

void clean_exit(void);

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
    for(int i = 0; i < 2048; i++) {
        if(i < 32){
            page_table[i] = MMU_ASSIGN_FLAG + i;
        } else {
            page_table[i] = 0;
        }
    }

    /* set int vectors */
    for(int i = 0; i < 8; i++){
        int_vectors[i] = (i*0x4)+0x8;
    }

    time_till_clock_int = -1;
}

/**
 * start the machine's io subsytem
 * just calls io.init */
void CPU::init_io(bool serial_en, bool gfx_en, bool disk_en, char * serial_port, char * disk_file){
    io.init(serial_en, gfx_en, disk_en, serial_port, disk_file);
}

/**
 * update io - calls io.update */
void CPU::update_io(){
    io.update();
}

/**
 * calculate the physical addr from a 16 bit addr
 * basically just does a page lookup */
uint32_t CPU::hard_addr(uint16_t addr, uint8_t is_write) {
    uint32_t res;
    uint16_t real_ptb, low_addr, high_addr;

    /* if sys(0) priv_lv, 0 is ptb */
    real_ptb = (priv_lv ? ptb : 0);
    /* ptb */
    real_ptb = real_ptb & MMU_PTB_MASK;
    /* get low and high parts of addr */
    low_addr = addr & 0b0000011111111111;
    high_addr = addr >> 11;

    /* page lookup */
    /* check for unassigned mmu access */
    if(!(page_table[high_addr + real_ptb] & MMU_ASSIGN_FLAG)){
        /* TODO: segfault interupt */
        std::cerr << std::dec;
        std::cerr << "scpemu: warning: unassigned mmu access\n";
        std::cerr << "attempted to access page " << (high_addr + real_ptb) << "\n";
        fprintf(stderr, "ptb: 0x%02x, page index in entry: 0x%02x, entry value: 0x%04x\n", real_ptb, high_addr, page_table[high_addr+real_ptb]);
        fprintf(stderr, "pointer dereferenced: 0x%x\n", addr);
        fprintf(stderr, "priv_lv: %u\n", priv_lv);
        fprintf(stderr, "pc at fault: 0x%x\n", pc);
        std::cerr << "current sp page (in proc): " << (uint16_t)(regs[15] >> 11) << "\n";
	    nop_debug(16);
        std::cerr << "Unassigned MMU Page Attempted Access\n";
	    //exit(1);
        while(1);
    }
    /* check for write restricted page violation */
    if(((page_table[high_addr + real_ptb] & MMU_TEXT_FLAG)) && is_write){
        /* TODO: segfault interupt */
        std::cerr << std::dec;
        std::cerr << "scpemu: warning: text-write protection mmu access\n";
        std::cerr << "attempted to write page " << (high_addr + real_ptb) << "\n";
        fprintf(stderr, "ptb: 0x%02x, page index in entry: 0x%02x, entry value: 0x%04x\n", real_ptb, high_addr, page_table[high_addr+real_ptb]);
        fprintf(stderr, "pointer dereferenced: 0x%x\n", addr);
        fprintf(stderr, "priv_lv: %u\n", priv_lv);
        fprintf(stderr, "pc at fault: 0x%x\n", pc);
        std::cerr << "current sp page (in proc): " << (uint16_t)(regs[15] >> 11) << "\n";
	    nop_debug(16);
        std::cerr << "Text Segment MMU Restriction Violation\n";
	    //exit(1);
        while(1);
    }
    res = (page_table[high_addr + real_ptb] & MMU_PAGE_MASK) << 11;
    res += low_addr;

    return res;
}

/**
 * read a byte from memory
 * no alignment needed */
uint8_t CPU::read_byte(uint16_t addr) {
    return mem[hard_addr(addr, 0)];
}

/**
 * read a word from memory
 * the word must be 2 byte aligned
 * if the addr isn't aligned, the aligned word at (addr & 0xfffe) is read anyway */
uint16_t CPU::read_word(uint16_t addr){
    /* align */
    uint32_t real_addr = hard_addr(addr, 0) & ((~0) - 1);
    /* read */
    return mem[real_addr] + (mem[real_addr + 1] << 8);
}

/**
 * write a byte to memory
 * no alignment needed */
void CPU::write_byte(uint16_t addr, uint8_t val){
    mem[hard_addr(addr, 1)] = val;
}

/**
 * write a word to memory
 * must be 2 byte aligned
 * if not aligned, will be written on the aligned barrier anyway */
void CPU::write_word(uint16_t addr, uint16_t val){
    /* align */
    uint32_t real_addr = hard_addr(addr, 1) & ((~0) - 1);
    /* write */
    mem[real_addr] = val & 0x00ff;
    mem[real_addr + 1] = val >> 8;
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
        exit(1);
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

#define HEX( x ) std::setw(4) << std::setfill('0') << std::hex << (uint16_t)( x ) << std::dec

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

            /* if specific value are encoded in the nop, run debug outputs */
            //nop_debug(imd);
            //don't do this - causing issues with file headers triggering it
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
            val = pc;
            /* adjust stack pointer */
            regs[reg_secd] -= 2;
            /* write pc - (with pc adjusted over immediate) */
            write_word(regs[reg_secd], pc + 2);
            /* set pc */
            pc = pc + imd;
            /* debug */
            if(debug_enabled && priv_lv == 0) {
                std::cout << "call.j.sp from 0x" << HEX(val) << " to 0x" << HEX(pc);
                std::string * name = debug_tables[0]->findName(pc);
                std::string * from_name = debug_tables[0]->findNameInBody(val);
                if(name != nullptr && from_name != nullptr) {
                    std::cout << "(" << *(from_name) << " -> " << *(name) << ")";
                } else {
                    std::cout << "(not in symbol tables)";
                }
                std::cout << "\n";
            }
            break;

        case CALL_R_SP: /* call.r.sp sp addr - call a non pc-relative address in a reg*/
            val = pc;
            /* adjust stack pointer */
            regs[reg_secd] -= 2;
            /* write pc */
            write_word(regs[reg_secd], pc);
            /* set pc */
            pc = regs[reg_prim];
            if(debug_enabled && priv_lv == 0) {
                std::cout << "call.r.sp from 0x" << HEX(val) << " to 0x" << HEX(pc);
                std::string * name = debug_tables[0]->findName(pc);
                std::string * from_name = debug_tables[0]->findNameInBody(val);
                if(name != nullptr && from_name != nullptr) {
                    std::cout << "(" << *(from_name) << " -> " << *(name) << ")";
                } else {
                    std::cout << "(not in symbol tables)";
                }
                std::cout << "\n";
            }
            break;

        case RET_N_SP: /* ret.n.sp - return from a subroutine */
            val = pc;
            /* adjust stack pointer */
            regs[reg_secd] += 2;
            /* read pc from stack */
            pc = read_word(regs[reg_secd] - 2);
            if(debug_enabled && priv_lv == 0) {
                std::cout << "ret.n.sp  from 0x" << HEX(val) << " to 0x" << HEX(pc);
                std::string * name = debug_tables[0]->findNameInBody(pc);
                std::string * from_name = debug_tables[0]->findNameInBody(val-2);
                if(name != nullptr && from_name != nullptr) {
                    std::cout << "(" << *(name) << " <- " << *(from_name) << ")";
                } else {
                    std::cout << "(not in symbol tables)";
                }
                std::cout << "\n";
            }
            break;

        case OUT_R_P: /* out.r.p - write to an io port */
            /* check for clock int pulse time set */
            if(imd == 0xff){
                time_till_clock_int = regs[reg_prim] << 12;
            } else {
                /* port number is in immediate */
                io.io_write(imd, regs[reg_prim]);
            }
            break;

        case IN_R_P: /* in.r.p - read from an io port */
            /* port number is in immediate */
            regs[reg_prim] = io.io_read(imd);
            break;

        case INT_I_N: /* int.i.n - do a software int on the given vector */
            do_int(reg_prim & 0b0111);
            break;

        case MMU_R_R: /* mmu.r.r - set page_table */
            priv_lv = 0;
            /* add ptb - in real imp, priv_lv is set to 1 during instruction to allow this
             * shifting 11 accounts for page selection method in mmu*/
            page_table[(regs[reg_secd] >> 11) + ptb] = regs[reg_prim];
            break;

        case PTB_R_N: /* ptb.r.n - set ptb */
            ptb = regs[reg_prim];
            break;

        case RETI_IPC_N: /* reti.ipc.n - return from int */
            pc = ipc_reg;
            priv_lv = 1;
            break;

        case MOV_R_IPC: /* copy reg to ipc reg */
            ipc_reg = regs[reg_prim];
            break;

        case MOV_IPC_R: /* copy ipc reg to reg */
            regs[reg_prim] = ipc_reg;
            break;

        case HLT_N_N: /* hlt.n.n - stop the machine */
            printf("scp stopped by hlt.n.n instruction\n");
            printf("main returned: %u\n", regs[0xe]);
            clean_exit();
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
        /* run clock int pulse */
    if(time_till_clock_int > 0){
        time_till_clock_int--;
    } else if (time_till_clock_int == 0){
        do_int(1);
        time_till_clock_int = -1;
    }
    /* check interupts */
    check_ints();
    /* set instr and imd reg */
    instr_reg = read_word(pc);
    imd_reg = read_word(pc + 2);
    /* increment program counter */
    pc = pc + 2;

    /* execute */
    execute(instr_reg, imd_reg);



}

/**
 * request an interrupt on the given irq line */
void CPU::do_int(uint8_t irq_line){
    if(irq_line >= 8){
        std::cerr << "scpemu: no such interupt irq line\n";
    }
    irq_req[irq_line] = 1;
}

/**
 * check if there are ints and we can do them */
void CPU::check_ints(){
    //make sure priv_lv is user
    if(!priv_lv){
        return;
    }
    //go through each irq line
    for(uint8_t irq = 0; irq < 8; irq++){
        //handle request, and return
        if(irq_req[irq]){
            irq_req[irq] = 0;
            //raise priv_lv
            priv_lv = 0;
            //save pc
            ipc_reg = pc;
            //set pc
            pc = int_vectors[irq];
            return;
        }
    }
}

/* do a nop debug */
void CPU::nop_debug(uint16_t instr){
    switch(instr){
        case 255:
            for(int i = 0; i < 2048; i++){
                if(i % 32 == 0){
                    printf("\nProc %02x|", i / 32);
                }
                printf("%04x ", page_table[i]);
            }
            printf("\nPTB: %u\n", ptb);
            break;
        default:
            break;
    }
}
/* set debug files */
void CPU::set_debug_files(int num_files, char ** file_names) {
    memset(debug_tables, 0, sizeof(void *) * 128);
    for(int i = 0; i < num_files; i++) {
        debug_tables[i] = new DebugFileInfo(std::string(file_names[i]));
        debug_enabled = 1;
    }
}
