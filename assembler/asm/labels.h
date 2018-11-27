/* This file was automatically generated.  Do not edit! */
struct label *find_label(char *name,int16_t module);
struct label *add_label(char *name,int16_t module,uint16_t addr);
void expand_labels();
extern unsigned int labels_cur;
extern unsigned int labels_allocd;
extern struct label *labels;
