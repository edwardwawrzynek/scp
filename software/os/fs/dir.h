/* This file was automatically generated.  Do not edit! */
dir_name_inum(uint16_t dir_inum,uint8_t *name);
dir_next_entry(struct file_entry *file,uint8_t *name);
dir_delete_file(uint16_t dir_inum,uint8_t *name);
dir_make_dir(uint16_t dir_inum,uint8_t *name);
dir_make_file(uint16_t dir_inum,uint8_t *name,uint16_t dev_num,uint8_t flags);
