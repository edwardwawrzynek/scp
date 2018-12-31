/* This file was automatically generated.  Do not edit! */
uint16_t dir_name_inum(uint16_t dir_inum,uint8_t *name);
uint16_t dir_next_entry(struct file_entry *file,uint8_t *name);
uint16_t dir_delete_file(uint16_t dir_inum,uint8_t *name);
uint16_t dir_make_dir(uint16_t dir_inum,uint8_t *name);
uint16_t dir_make_file(uint16_t dir_inum,uint8_t *name,uint16_t dev_num,uint8_t flags);
