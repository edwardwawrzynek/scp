#include <iostream>
#include <cstdint>

#include <unistd.h>

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

void usage(){
    std::cerr << "Usage: scpemu [options] [bin file]\nOptions:\n-g\t\t:enable the gui\n-s [serial_dev]\t:enable serial output on serial_dev\n";
    exit(1);
}

int main(int argc, char ** argv){
    uint8_t serial_en = 0, gfx_en = 0;
    char * serial_file = NULL;

    int opt;

    /* set options */
    while((opt = getopt(argc, argv, "s:g")) != -1){
        switch(opt){
            case 's':
                serial_en = 1;
                serial_file = optarg;
                break;
            case 'g':
                gfx_en = 1;
                break;
            case '?':
            default:
                usage();
        }
    }
    if(!argv[optind]){
        usage();
    }

    cpu.reset();
    cpu.read_file(argv[optind]);
    cpu.init_io(serial_en, gfx_en, serial_file);
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