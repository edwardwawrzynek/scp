/* This file was automatically generated.  Do not edit! */
file_tell(struct file_entry *file);
file_seek(struct file_entry *file,int16_t offset,uint8_t mode);
file_read(struct file_entry *file,uint8_t *buffer,uint16_t bytes);
file_write(struct file_entry *file,uint8_t *buffer,uint16_t bytes);
file_set_buf(struct file_entry *file);
file_put_all();
file_put(struct file_entry *file);
file_get(uint16_t inum,uint8_t mode);
file_alloc();
extern struct file_entry file_table[FILE_TABLE_ENTRIES];
