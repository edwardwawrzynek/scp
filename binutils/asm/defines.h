/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
struct def *find_def(char *name);
struct def *add_def(char *name,uint16_t val);
void expand_defs();
extern unsigned int defs_cur;
extern unsigned int defs_allocd;
extern struct def *defs;
