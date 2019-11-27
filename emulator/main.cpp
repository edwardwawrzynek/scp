#include <iostream>
#include <cstdint>
#include <ctime>
#include <ratio>
#include <chrono>

#include <unistd.h>

#include "cpu.h"

#define SCREEN_UPDATE_FREQ 300000

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

/* exit and close down io */
void clean_exit(){
    cpu.io.close();
    exit(0);
}

void usage(){
    std::cerr << "Usage: scpemu [options] [bin file]\nOptions:\n-g\t\t:enable the graphics io subsytem\n-s [serial_dev]\t:enable serial output on serial_dev\n-d [disk_file]\t:enable disk io on disk_file\n-D [debug file]\t:enable debugging output given sym debug file. multiple invocations supply debugs for multiple procs\n-f [freq]\t:throttle to freq mhz\n";
    exit(1);
}

int main(int argc, char ** argv){
    uint8_t serial_en = 0, gfx_en = 0, disk_en = 0;
    char * serial_file = NULL;
    char * disk_file = NULL;

    double throttle_freq = 0.0;
    uint8_t do_throttle = 0;

    char *debug_files[128];
    int debug_file_num = 0;

    int opt;

    /* set options */
    while((opt = getopt(argc, argv, "D:s:d:gf:")) != -1){
        char * mem;
        switch(opt){
            case 's':
                serial_en = 1;
                serial_file = optarg;
                break;
            case 'g':
                gfx_en = 1;
                break;
            case 'd':
                disk_en = 1;
                disk_file = optarg;
                break;
            case 'D':
                mem = new char[strlen(optarg) + 1];
                debug_files[debug_file_num++] = strcpy(mem, optarg);
                break;
            case 'f':
                do_throttle = 1;
                throttle_freq = atof(optarg);
                break;
            case '?':
            default:
                usage();
        }
    }
    if(!argv[optind]){
        usage();
    }
    if(debug_file_num > 0) {
        cpu.set_debug_files(debug_file_num, debug_files);
    }

    cpu.reset();
    cpu.read_file(argv[optind]);
    cpu.init_io(serial_en, gfx_en, disk_en, serial_file, disk_file);
    long long count = 0;
    std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    while(true){
        cpu.run_instr();
        count++;
        if(count > SCREEN_UPDATE_FREQ){
            count = 0;
            cpu.update_io();

            if(do_throttle) {
                /* we just ran SCREEN_UPDATE_FREQ instruction cycles
                   this is 3*SCREEN_UPDATE_FREQ clock ticks (3 clocks per instr) */
                double target_millis = ((double)(3*SCREEN_UPDATE_FREQ))/(throttle_freq * 1000.0);

                uint8_t done_cycle = 0;
                while(1){
                    std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();

                    std::chrono::duration<double, std::milli> time_span = now - start_time;
                    if(time_span.count() >= target_millis) {
                        if(!done_cycle) {
                            fprintf(stderr, "scpemu: didn't meet throttle frequency of %lf mhz\n", throttle_freq);
                        }
                        break;
                    }
                    done_cycle = 1;
                }

                /* reset clock */
                start_time = std::chrono::high_resolution_clock::now();
            }

        }
    }
}