/* This file was automatically generated.  Do not edit! */
void obj_write_extern_offset(struct obj_file *o,uint16_t index,uint8_t pc_rel);
void obj_write_offset(struct obj_file *o,uint16_t offset,uint8_t seg,uint8_t pc_rel);
void obj_write_const_word(struct obj_file *o,uint16_t val);
void obj_write_const_byte(struct obj_file *o,uint8_t val);
void obj_set_seg(struct obj_file *obj,uint8_t seg);
struct obj_symbol_entry *obj_find_defined_symbol(struct obj_file *obj,char *name,struct obj_symbol_entry *syms);
struct obj_symbol_entry *obj_get_extern(struct obj_file *obj);
struct obj_symbol_entry *obj_get_defined(struct obj_file *obj);
uint32_t obj_write_extern(struct obj_file *obj,char *name,uint16_t off);
void obj_write_defined(struct obj_file *obj,char *name,uint8_t seg,uint16_t off);
void obj_expand_extern(struct obj_file *obj,uint32_t extern_symbols);
void obj_create_header(struct obj_file *obj,uint32_t seg0,uint32_t seg1,uint32_t seg2,uint32_t seg3,uint32_t defined_symbols,uint32_t extern_symbols);
void obj_init(struct obj_file *obj);
void obj_read_header(struct obj_file *obj);
void obj_write_header(struct obj_file *obj);
