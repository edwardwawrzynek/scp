/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void sym_out_write_symbols(FILE *file);
void obj_out_write_symbols();
uint16_t extern_get_addr(int i,uint32_t index);
int find_defined_symbol_file(char *name);
struct obj_symbol_entry *find_extern(int i,uint32_t index,int *file);
void symbol_read_in_tables();
extern uint32_t extern_size[MAX_FILES];
extern uint32_t defined_size[MAX_FILES];
extern struct obj_symbol_entry *extern_tables[MAX_FILES];
extern struct obj_symbol_entry *defined_tables[MAX_FILES];
