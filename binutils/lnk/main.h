/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void run_sym_debug_out();
void run_lnk_obj();
void run_lnk_bin();
int main(int argc,char *argv[]);
uint8_t add_obj(char *name);
extern int in_objs_index;
extern int do_out_ar;
extern int do_dep_opt;
extern FILE *sym_debug_file;
extern char *sym_debug_out;
extern int do_sym_debug;
extern char lib_buf[256];
extern int lib_path_index;
extern char *lib_path[NUM_LIBS];
extern int lib_search_dirs_index;
extern char *lib_search_dirs[NUM_DIRS];
extern uint8_t do_pages;
extern uint8_t do_head;
void run_lnk(void);
void run_lnk();
void usage();
