#include <iostream>
#include <cstdint>

#include "cpu.h"

#define SCREEN_UPDATE_FREQ 1000000

using namespace std;

/* main cpu object */
CPU cpu;

/* print out debug information */
void debug(CPU *cpu){
    std::cout << "\n---\nPC: " << cpu->pc << "\n";
    std::cout << "Regs:\n";
    for(int i = 0; i < 16; i++){
        std::cout << i << ":" << cpu->regs[i] << "\n";
    }
}

int main(int argc, char ** argv){
    if(argc < 3){
        std::cerr << "Usage: scpemu [bin file] [serial port]\n";
        exit(1);
    }
    cpu.reset();
    cpu.read_file(argv[1]);
    cpu.init_io(argv[2]);
    long long count = 0;
    while(true){
        //debug(&cpu);
        cpu.run_instr();
        count++;
        if(count > SCREEN_UPDATE_FREQ){
            count = 0;
            cpu.update_io();
        }
    }
}