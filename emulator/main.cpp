#include <iostream>
#include <cstdint>

#include "cpu.h"

using namespace std;

/* main cpu object */
CPU cpu;

int main(int argc, char ** argv){
    if(argc < 2){
        std::cerr << "Usage: scpemu [bin file]\n";
        exit(1);
    }
    cpu.reset();
    cpu.read_file(argv[1]);
    while(true){
        std::cin.ignore();
        cpu.run_instr();
        std::cout << cpu.regs[0] << " PC: " << cpu.pc;
    }
}