#include "disasm.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>


void usage(){
  printf("Usage: " BIN_NAME " [options] file\
        \nOptions:\
        \n-o\tout.dasm\t:set output file\
        \n-D\tdebug\t\t:use a symbol debug file from the linker\
        \n-h\t\t\t:print usage\n");
  exit(1);
}

FILE * in_file;
FILE * out_file;
FILE * debug_file;
uint8_t do_debug = 0;

typedef struct {
  uint16_t seg_sizes[4];
  uint16_t seg_starts[4];
  uint16_t address;
  // we read 4 bytes ahead of what we are currently printing
  uint8_t byte_buf[4];
  uint16_t word_buf[2];
} disasm_state;

disasm_state state;

int read_byte(FILE *f, uint8_t * res) {
  int val = fgetc(f);
  if(val == EOF) {
    return 1;
  }
  *res = (uint8_t)val;
  return 0;
}

int read_word(FILE *f, uint16_t * res) {
  int r1 = fgetc(f);
  int r2 = fgetc(f);
  if(r1 == EOF || r2 == EOF) {
    return 1;
  }
  *res = (uint8_t)r1;
  *res += (((uint8_t)r2)<<8);
  return 0;
}

void read_headers(FILE * file, disasm_state * state) {
  for(int i = 0; i < 4; i++) {
    uint16_t val;
    if(read_word(file, &val)) {
      fprintf(stderr, "malformed header\n");
      exit(1);
    }
    state->seg_sizes[i] = ((val>>5)&0b11111)*2048;
    state->seg_starts[i] = (val&0b11111)*2048;
  }
}

int find_current_seg(disasm_state * state) {
  for(int i = 1; i < 4; i++) {
    if((state->address-4) < state->seg_starts[i]) {
      return i-1;
    }
  }
  return 3;
}

void shift_buffers(disasm_state * state) {
  for(int i = 0; i < 3; i++) {
    state->byte_buf[i] = state->byte_buf[i+1];
  }
  if(state->address % 2 == 0) {
    state->word_buf[0] = state->word_buf[1];
  }
}

int read_byte_into_buf(FILE *f, disasm_state * state) {
  shift_buffers(state);
  uint8_t data;
  if(read_byte(f, &data)) return 1;
  state->byte_buf[3] = data;
  if(state->address % 2 == 0) state->word_buf[1] = (data&0x00ff);
  else                        state->word_buf[1] += (data&0xff)<<8;

  state->address++;

  return 0;
}

void init_buffer(FILE * file, disasm_state * state) {
  for(int i = 0; i < 3; i++) {
    read_byte_into_buf(file, state);
  }
}

struct instr_encoding * lookup_opcode(uint16_t instr_bin) {
  for(int i = 0; instructions[i].name != NULL; i++) {
    struct instr_encoding * instr = &instructions[i];
    /* get length of opcode */
    int n=0;
    while(instr->encoding[n] == '0') n++;
    uint16_t opcode = (instr_bin>>(16-n));
    if(opcode == instr->opcode) {
      return instr;
    }
  }
  return NULL;
}

/* print an argument given its type */
void print_arg(FILE *f, uint16_t arg_val, enum arg_type type) {
  switch(type) {
    case reg:
      if(arg_val == 15) fprintf(f, " sp");
      else fprintf(f, " r%01x", arg_val);
      break;
    case alu:
      if(arg_val < 16) {
      fprintf(f, " %s", alu_ops[arg_val]);
      } else {
        fprintf(f, " op_unknwn");
      }
      break;
    case cond:
      fputc(' ', f);
      if(arg_val & 0b00001) fputc('e', f);
      if(arg_val & 0b00010) fputc('l', f);
      if(arg_val & 0b00100) fputc('g', f);
      if(arg_val & 0b01000) fputc('L', f);
      if(arg_val & 0b10000) fputc('G', f);
      break;
    case cnst:
      fprintf(f, " %i", arg_val);
      break;
    case label:
      fprintf(f, " (pc + %i)", arg_val);
      break;
    default:
      fprintf(f, " fasd");
  }
}

/* decode instruction (and print) 
 * return true if instr had immediate */
int decode_instr(FILE * f, uint16_t instr_bin, uint16_t imd) {
  struct instr_encoding * instr = lookup_opcode(instr_bin);
  if(instr == NULL) {
    fprintf(f, "; invalid opcode\n");
    return 0;
  } 
  /* print opcode */
  fprintf(out_file, "; %s", instr->name);
  /* decode arguments */
  int arg_i = 0;
  while(instr->types[arg_i] != end_arg) {
    /* find last index in arg string and size */
    int16_t index = -1, size = 0;
    for(int n = 0; n < 16; n++) {
      if(instr->encoding[n] == (arg_i + '1')) {
        size++;
        index = n;
      }
    }
    uint16_t arg_val;
    if(instr->imd_field == (arg_i+1)) arg_val = imd;
    else arg_val = (instr_bin >> (16-index-1)) & ((1<<size)-1);
    print_arg(out_file, arg_val, instr->types[arg_i]);
    arg_i++;
  }
  fprintf(out_file, "\n");
  return instr->imd_field;
}

int had_imd = 0;

void run_disasm(FILE * file, FILE * out_file, disasm_state * state) {
  init_buffer(file, state);
  while(!read_byte_into_buf(file, state)) {
    int addr = (state->address-4);
    int cur_seg = find_current_seg(state);
    /* text seg - do disasm */
    if(cur_seg == 0) {
      if(state->address % 2 == 0) {
        if (had_imd) had_imd = 0;
        else had_imd = decode_instr(out_file, state->word_buf[0], state->word_buf[1]);
      }
    }
    /* print raw data */
    fprintf(out_file, "%04x: %02x\t: %3i |%c|", addr, state->byte_buf[0], state->byte_buf[0], isprint(state->byte_buf[0]) ? state->byte_buf[0] : ' ');
      if(addr % 2 == 0) {
        fprintf(out_file, "\t:\t%04x (%4i)", state->word_buf[0], state->word_buf[0]);
      }
      fprintf(out_file, "\n");
  }
}



int main(int argc, char *argv[]){
  char * outfile = "out.dasm";
  char * debugfile = NULL;
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:D:h")) != -1) {
    switch(opt){
      case 'o':
        outfile = optarg;
        break;
      case 'D':
        debugfile = optarg;
        do_debug = 1;
        break;
      case '?':
      case 'h':
      default:
        usage();
    }
  }
  
  /* open files */
  out_file = fopen(outfile, "w");
  if(do_debug == 1) {
    debug_file = fopen(debugfile, "r");
    if(debug_file == NULL) {
      fprintf(stderr, BIN_NAME ":can't open file %s", debugfile);
      perror(" ");
      exit(1);
    }
  }
  if(optind >= argc) {
    usage();
  }
  in_file = fopen(argv[optind], "r");
  if(in_file == NULL) {
    fprintf(stderr, BIN_NAME ":can't open file %s", argv[optind]);
      perror(" ");
      exit(1);
  }

  read_headers(in_file, &state);
  fseek(in_file, 0, SEEK_SET);

  run_disasm(in_file, out_file, &state);
}