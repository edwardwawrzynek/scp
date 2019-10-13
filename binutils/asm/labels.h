/* This file was automatically generated.  Do not edit! */
void remove_defined_externs();
void labels_write_out(struct obj_file *o);
void labels_get_num(uint16_t *defined,uint16_t *external);
struct label *find_label(char *name,int16_t module,uint8_t no_extern);
struct label *add_label(char *name,int16_t module,uint16_t addr,int8_t seg);
void expand_labels();
void reset_segs_and_module();
extern uint16_t cur_module;
extern uint16_t seg_pos[4];
extern uint8_t cur_seg;
extern unsigned int labels_cur;
extern unsigned int labels_allocd;
extern struct label *labels;
