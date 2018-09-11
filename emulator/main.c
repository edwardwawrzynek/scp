#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
//Opcode definitions
#include "opcodes.c"
//cycles per cmd definitions
#include "cycles.c"

//sdl (for graphics)
#include "SDL2/SDL.h"

//speed throtling (set by cmds, this is just default)
uint8_t limit_speed = 1;
//limit in mhz
double speed_limit = 35.0;
//print the speed
uint8_t print_speed = 0;

//io subsystem
#include "io.c"

uint8_t WARNINGS = 1;

uint8_t DEBUG = 0;

unsigned long EVENT_CHECK_FREQ = 100000;


//cpu state structure
struct cpu {
    //Primary Registers
    uint16_t reg_a;
    uint16_t reg_b;
    //Program Counter
    uint16_t reg_pc;
    //Stack pointer
    uint16_t reg_sp;
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

//main cpu
struct cpu c;
//window
SDL_Window *window;
SDL_Surface *windowSurface;
SDL_Event window_event;

//Read from machine memory
uint8_t cpu_read_mem(struct cpu * cpu, uint16_t addr){
    uint16_t high_addr, low_addr;
    //Get low addr from addr
    low_addr = addr & 0x7ff;
    high_addr = (addr & 0xf800) >> 11;
    //get real high_addr through mmu_table
    high_addr = cpu->mmu_table[(cpu->reg_priv ? (cpu->reg_ptb & 0x7ff) : 0) + high_addr];
    return cpu->memory[(high_addr << 11) + low_addr];
}

//Write to machine memory
void cpu_write_mem(struct cpu * cpu, uint16_t addr, uint8_t val){
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
    uint16_t addr;
    size_t n_read;

    uint8_t buf[256];

    fp = fopen(file_path, "r");
    if(fp == NULL){
        printf("No such file: %s\n", file_path);
        exit(1);
    }
    addr = 0;
    
    do{
        n_read = fread(buf, 1, 256, fp);
        memcpy(cpu->memory + addr, buf, n_read);
        addr += 256;
    } while(n_read == 256);
    fclose(fp);
}

//Init the cpu state to that of scp on power on
void cpu_init(struct cpu * cpu){
    //Create mmu_table (only first proc's addr space is inited)
    for(uint16_t i = 0; i < 32; i++){
        cpu->mmu_table[i] = i;
    }
}

//run a cpu cycle, returning the number of cpu cycles the instruction took
uint8_t cpu_cycle(struct cpu * cpu){
    uint8_t opcode;
    uint8_t val8;
    uint16_t val16;
    uint8_t pc_inc;

    pc_inc = 1;

    //fetch the opcode
    opcode = cpu_read_mem(cpu, cpu->reg_pc);
    //fetch the values after the opcode
    val8 = cpu_read_mem(cpu, cpu->reg_pc+1);
    val16 = val8 + (cpu_read_mem(cpu, cpu->reg_pc+2)<<8);
    if(DEBUG){
        printf("Addr: %x, opcode: %x, val8: %x, val16: %x,\n", cpu->reg_pc, opcode, val8, val16);
        printf("dasm: %s", cmds + (opcode*5));
        if(CMD_LENS[opcode]){
            printf(" 0x%x (#%i)", CMD_LENS[opcode] == 1 ? val8 : val16, CMD_LENS[opcode] == 1 ? (int16_t)val8 : (int16_t)val16);
        }
        printf("\n");
        printf("A: 0x%x, B: 0x%x, PC: 0x%x, SP:m0x%x, PTB: 0x%x, priv_lv: %u\n", cpu->reg_a, cpu->reg_b, cpu->reg_pc, cpu->reg_sp, cpu->reg_ptb, cpu->reg_priv);
    }
    //giant switch for opcodes (seperate out?)
    switch(opcode){
    case NOP:
        break;
    case LBIA:
        cpu->reg_a = val8;
        break;
    case LBIB:
        cpu->reg_b = val8;
        break;
    case LWIA:
        cpu->reg_a = val16;
        break;
    case LWIB:
        cpu->reg_b = val16;
        break;

    case LBPA:
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_a);
        break;
    case LBPB:
        cpu->reg_b = cpu_read_mem(cpu, cpu->reg_a);
        break;
    case LWPA:
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_a) + (cpu_read_mem(cpu, cpu->reg_a+1) << 8);
        break;
    case LWPB:
        cpu->reg_b = cpu_read_mem(cpu, cpu->reg_a) + (cpu_read_mem(cpu, cpu->reg_a+1) << 8);
        break;

    case LBQA:
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_b);
        break;
    case LBQB:
        cpu->reg_b = cpu_read_mem(cpu, cpu->reg_b);
        break;
    case LWQA:
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_b) + (cpu_read_mem(cpu, cpu->reg_b+1) >> 8);
        break;
    case LWQB:
        cpu->reg_b = cpu_read_mem(cpu, cpu->reg_b) + (cpu_read_mem(cpu, cpu->reg_b+1) >> 8);
        break;
    
    case LBMA:
        cpu->reg_a = cpu_read_mem(cpu, val16);
        break;
    case LBMB:
        cpu->reg_b = cpu_read_mem(cpu, val16);
        break;
    case LWMA:
        cpu->reg_a = cpu_read_mem(cpu, val16) + (cpu_read_mem(cpu, val16 + 1) << 8);
        break;
    case LWMB:
        cpu->reg_b = cpu_read_mem(cpu, val16) + (cpu_read_mem(cpu, val16 + 1) << 8);
        break;
    
    case SBPB:
        cpu_write_mem(cpu, cpu->reg_a, (uint8_t)cpu->reg_b);
        break;
    case SBQA:
        cpu_write_mem(cpu, cpu->reg_b, (uint8_t)cpu->reg_a);
        break;
    case SWPB:
        cpu_write_mem(cpu, cpu->reg_a, (uint8_t)cpu->reg_b);
        cpu_write_mem(cpu, cpu->reg_a+1, (uint8_t)((cpu->reg_b)>>8));
        break;
    case SWQA:
        cpu_write_mem(cpu, cpu->reg_b, (uint8_t)cpu->reg_a);
        cpu_write_mem(cpu, cpu->reg_b+1, (uint8_t)((cpu->reg_a)>>8));
        break;

    case SBMA:
        cpu_write_mem(cpu, val16, (uint8_t)cpu->reg_a);
        break;
    case SBMB:
        cpu_write_mem(cpu, val16, (uint8_t)cpu->reg_b);
        break;
    case SWMA:
        cpu_write_mem(cpu, val16, (uint8_t)cpu->reg_a);
        cpu_write_mem(cpu, val16+1, (uint8_t)((cpu->reg_a)>>8));
        break;
    case SWMB:
        cpu_write_mem(cpu, val16, (uint8_t)cpu->reg_b);
        cpu_write_mem(cpu, val16+1, (uint8_t)((cpu->reg_b)>>8));
        break;
    
    case AADD:
        cpu->reg_a = cpu->reg_b + cpu->reg_a;
        break;
    case ASUB:
        cpu->reg_a = cpu->reg_b - cpu->reg_a;
        break;
    case AMUL:
        cpu->reg_a = cpu->reg_b * cpu->reg_a;
        break;
    case ABOR:
        cpu->reg_a = cpu->reg_b | cpu->reg_a;
        break;
    case ABXR:
        cpu->reg_a = cpu->reg_b ^ cpu->reg_a;
        break;
    case ABND:
        cpu->reg_a = cpu->reg_b & cpu->reg_a;
        break;
    case ASSR:
        cpu->reg_a = (int16_t)cpu->reg_b >> (int16_t)cpu->reg_a;
        break;
    case ASHR:
        cpu->reg_a = (uint16_t)cpu->reg_b >> (uint16_t)cpu->reg_a;
        break;
    case ASHL:
        cpu->reg_a = (uint16_t)cpu->reg_b << (uint16_t)cpu->reg_a;
        break;
    case ANEG:
        cpu->reg_a = -(cpu->reg_a);
        break;
    case ALNG:
        cpu->reg_a = !(cpu->reg_a);
        break;
    case ABNG:
        cpu->reg_a = ~(cpu->reg_a);
        break;
    case ACLV:
        cpu->reg_a = (cpu->reg_a) ? 1 : 0;
        break;
    case AEQU:
        cpu->reg_a = cpu->reg_b == cpu->reg_a;
        break;
    case ANEQ:
        cpu->reg_a = cpu->reg_b != cpu->reg_a;
        break;
    case ASLT:
        cpu->reg_a = (int16_t)cpu->reg_b < (int16_t)cpu->reg_a;
        break;
    case AULT:
        cpu->reg_a = cpu->reg_b < cpu->reg_a;
        break;
    case ASLE:
        cpu->reg_a = (int16_t)cpu->reg_b <= (int16_t)cpu->reg_a;
        break;
    case AULE:
        cpu->reg_a = cpu->reg_b <= cpu->reg_a;
        break;
    case ASEX:
        cpu->reg_a = (cpu->reg_a & 0x80) ? (cpu->reg_a | 0xff00) : (cpu->reg_a & 0x00ff);
        break;
    case AAEB:
        cpu->reg_a = cpu->reg_b;
        break;

    case JMP:
        cpu->reg_pc = val16;
        pc_inc = 0;
        break;
    case JPNZ:
        if(cpu->reg_a){
            cpu->reg_pc = val16;
            pc_inc = 0;
        }
        break;
    case JPZ:
        if(!(cpu->reg_a)){
            cpu->reg_pc = val16;
            pc_inc = 0;
        }
        break;
    
    case INCA:
        cpu->reg_a++;
        break;
    case INCB:
        cpu->reg_b++;
        break;
    case DECA:
        cpu->reg_a--;
        break;
    case DECB:
        cpu->reg_b--;
        break;
    
    case XSWP:
        //use val16 as a temp
        val16 = cpu->reg_a;
        cpu->reg_a = cpu->reg_b;
        cpu->reg_b = val16;
        break;
    
    case MDSP:
        cpu->reg_sp += val16;
        break;
    case MASP:
        cpu->reg_sp = cpu->reg_a;
        break;
    case MSPA:
        cpu->reg_a = cpu->reg_sp + val16;
        break;

    //pushes write high bytes first so that it is the byte at addr+1 for 16 bit values
    case PSHA:
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)((cpu->reg_a)>>8));
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)(cpu->reg_a));
        break;
    case PSHB:
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)((cpu->reg_b)>>8));
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)(cpu->reg_b));
        break;
    case POPA:
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_sp++);
        cpu->reg_a += cpu_read_mem(cpu, cpu->reg_sp++)<<8;
        break;
    case POPB:
        cpu->reg_b = cpu_read_mem(cpu, cpu->reg_sp++);
        cpu->reg_b += cpu_read_mem(cpu, cpu->reg_sp++)<<8;
        break;

    case CALL:
        pc_inc = 0;
        //set pc to next instruction ( 3 to account for the 2 byte addr)
        cpu->reg_pc = cpu->reg_pc + 3;
        //push pc
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)((cpu->reg_pc)>>8));
        cpu_write_mem(cpu, --cpu->reg_sp, (uint8_t)(cpu->reg_pc));
        //set pc
        cpu->reg_pc = val16;
        break;
    case RET:
        pc_inc = 0;
        //pop value on stack into pc
        cpu->reg_pc = cpu_read_mem(cpu, cpu->reg_sp++);
        cpu->reg_pc += cpu_read_mem(cpu, cpu->reg_sp++)<<8;
        break;
    
    case OUTA:
        //write out to the io
        io_out((uint8_t)cpu->reg_b, cpu->reg_a);
        break;
    case INA:
        //read in from io
        cpu->reg_a = io_in((uint8_t)cpu->reg_b);
        break;
    case JMPA:
        pc_inc = 0;
        cpu->reg_pc = cpu->reg_a;
        break;
    
    case APTB:
        //set ptb to value in a
        cpu->reg_ptb = cpu->reg_a;
        break;
    case PRVU:
        //set priv to usr(1)
        cpu->reg_priv = 1;
        break;
    case PRVS:
        //set priv to sys(0)
        cpu->reg_priv = 0;
        break;
    case MMUS:
        //sets the ptb value pointed to by (the page table base + the upper five bits of b reg) to the value in a
        //sets priv to sys(0) in the process
        cpu->reg_priv = 0;
        cpu->mmu_table[(cpu->reg_ptb<<5) + (cpu->reg_b >> 11)] = (uint8_t)cpu->reg_a;
        break;

    case BSPA:
        cpu->reg_a = cpu->reg_sp + val8;
        break;
    case BDSP:
        cpu->reg_sp += val8;
        break;
    case BSPL:
        cpu->reg_a = cpu->reg_sp + val8;
        cpu->reg_a = cpu_read_mem(cpu, cpu->reg_a) + (cpu_read_mem(cpu, cpu->reg_a+1) >> 8);
        break;


    default:
        if(WARNINGS){
            printf("Warning: Unrecognized opcode: 0x%x\n", opcode);
        }
        break;
    }
    //increment the pc to the next instruction
    if(pc_inc){
        cpu->reg_pc += CMD_LENS[opcode]+1;
    }
    return cmd_cycles[opcode];
    
}

//run the cpu
void cpu_run(struct cpu * cpu){
    unsigned long i;
    unsigned long cyc;
    while(1){
        cyc = 0;
        for(i = 0; i < EVENT_CHECK_FREQ; ++i){
            cyc += cpu_cycle(cpu);
        }
        sdl_check_events(cyc);
    }
}

void usage(){
    printf("Usage: scpemu [options] [bin file] [disk file]\nOptions:\n-n\t\t:don't throttle the emulator\n-w (speed)\t:throttle the emulator to speed in mhz\n-d\t\t:print debugging information on each instruction executed\n-w\t\t:don't print warnings\n-s\t\t:print the speed the emulator is operating at\n");
}

int main(int argc, char ** argv){
    int argv_off;
    argv_off = 0;
    if(argc < 2){
        usage();
        exit(1);
    }
    while(argv[1+argv_off][0] == '-'){
        switch(argv[1+argv_off][1]){
        case 'n':
            limit_speed = 0;
            argv_off += 1;
            //update less often - no smothing with waits needed
            EVENT_CHECK_FREQ = 1000000;
            break;
        case 't':
            limit_speed = 1;
            speed_limit = atof(argv[2+argv_off]);
            argv_off += 2;
            break;
        case 'd':
            argv_off++;
            DEBUG = 1;
            break;
        case 'w':
            argv_off++;
            WARNINGS = 0;
            break;
        case 's':
            print_speed = 1;
            argv_off++;
            break;
        default:
            usage();
            printf("scpemu: no such option: %s\n", argv[1+argv_off]);
            exit(1);
            argv_off++;
            break;
        }
    }
    if(argc-argv_off < 3){  
        usage();
        exit(1);
    }
    init_sdl(argv[1+argv_off]);
    init_disk(argv[2+argv_off]);
    cpu_init(&c);
    cpu_init_mem(&c, argv[1+argv_off]);
    cpu_run(&c);
}
