/* This file was automatically generated.  Do not edit! */
void output_word(uint16_t word);
void output_byte(uint8_t val);
void reset_file();
int read_byte();
void error(char *msg);
extern uint8_t do_debug;
extern FILE *debug_file;
extern FILE *out_file;
extern int cur_in_file;
extern FILE *in_files[MAX_FILES];
extern int lptr;
extern char line[LINE_SIZE];
