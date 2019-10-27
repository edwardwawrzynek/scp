/* This file was automatically generated.  Do not edit! */
int main(int argc,char *argv[]);
extern FILE *out_file;
extern disasm_state state;
void run_disasm(FILE *file,FILE *out_file,disasm_state *state);
struct instr_encoding *lookup_opcode(uint16_t instr_bin);
void init_buffer(FILE *file,disasm_state *state);
int read_byte_into_buf(FILE *f,disasm_state *state);
void shift_buffers(disasm_state *state);
int find_current_seg(disasm_state *state);
void read_headers(FILE *file,disasm_state *state);
int read_word(FILE *f,uint16_t *res);
int read_byte(FILE *f,uint8_t *res);
extern uint8_t do_debug;
extern FILE *debug_file;
extern FILE *in_file;
void usage();
