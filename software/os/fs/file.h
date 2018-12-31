/* This file was automatically generated.  Do not edit! */
uint16_t file_tell(struct file_entry *file);
uint16_t file_seek(struct file_entry *file,int16_t offset,uint8_t mode);
uint16_t file_read(struct file_entry *file,uint8_t *buffer,uint16_t bytes);
uint16_t file_write(struct file_entry *file,uint8_t *buffer,uint16_t bytes);
void file_set_buf(struct file_entry *file);
void file_put_all();
void file_put(struct file_entry *file);
struct file_entry *file_get(uint16_t inum,uint8_t mode);
struct file_entry *file_alloc();
extern struct file_entry file_table[FILE_TABLE_ENTRIES];
