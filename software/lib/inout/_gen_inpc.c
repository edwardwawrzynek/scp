/* generate the inp.c file containing the _inp functions needed for the inp call to work */

#include <stdio.h>
#include <stdlib.h>

/* we also need to output __inp_port_name label variants for the port names defined in inout.h. these are their names and port numbers */

struct port_name {
    char *name;
    int port;
};


struct port_name port_names[] = {
{"_serial_data_in_port", 1},
{"_serial_next_port", 1},
{"_serial_in_waiting_port", 2},
{"_serial_data_out_port", 3},
{"_serial_tx_busy_port", 4},

{"_key_in_waiting_port", 8},
{"_key_data_in_port", 7},
{"_key_next_port", 7},

{"_text_addr_port", 5},
{"_text_data_port", 6},

{"_gfx_addr_port", 9},
{"_gfx_data_port", 10},
{"_gfx_screen_en_port", 12},

{"_sound_freq_port", 11},

{"_disk_busy_port", 13},
{"_disk_reset_port", 13},
{"_disk_error_port", 14},
{"_disk_block_addr_port", 14},

{"_disk_data_in_port", 15},
{"_disk_data_in_next_port", 15},
{"_disk_data_in_rd_en_port", 16},
{"_disk_data_in_addr_port", 16},

{"_disk_data_out_port", 17},

{"_disk_data_out_wr_en_port", 18},
{"_disk_data_out_addr_port", 18},

};

int main(int argc, char ** argv){
    if(argc != 4){
        printf("Usage: _gen_inpc inp.asm __inp.h max_port_num\n");
        exit(1);
    }
    int max_port = atoi(argv[3]);

    FILE *out = fopen(argv[1], "w");
    FILE *outh = fopen(argv[2], "w");
    if(!out){
        printf("Failed to open file: %s\n", argv[1]);
        exit(1);
    }
    if(!outh){
        printf("Failed to open %s\n", argv[2]);
        exit(1);
    }

    fprintf(out, ";\tAuto-generated inp definitions for scp\n\t.text\n");

    for(int i = 0; i <= max_port; i++){
        for(int p = 0; p < (sizeof(port_names)/sizeof(struct port_name)); p++){
            if(i == port_names[p].port){
                fprintf(out, "__inp_%s:\n\t.global __inp_%s\n", port_names[p].name, port_names[p].name);
                fprintf(outh, "int _inp_%s(void);\n", port_names[p].name);
            }
        }

        fprintf(out, "__inp_%u:\n\t.global __inp_%u\n\tin.r.p re %u\n\tret.n.sp sp\n", i, i, i);
        fprintf(outh, "int _inp_%u(void);\n", i);

    }
}