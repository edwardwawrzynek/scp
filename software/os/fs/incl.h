/* This file was automatically generated.  Do not edit! */
void balloc_free(uint16_t blk);
uint16_t *balloc_get(uint16_t first_blk,uint8_t *num_blks);
void balloc_put(uint16_t *blocks);
uint16_t balloc_alloc();
extern uint16_t balloc_get_buf[129];
extern uint16_t balloc_buffer[256];
/* This file was automatically generated.  Do not edit! */
void buffer_flush_all();
void buffer_put(struct buffer_header *buf);
struct buffer_header *buffer_get(uint16_t blk);
struct buffer_header *buffer_alloc(uint16_t blk);
extern struct buffer_header buffer_table[BUFFER_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
uint16_t dir_name_inum(uint16_t dir_inum,uint8_t *name);
uint16_t dir_next_entry(struct file_entry *file,uint8_t *name);
uint16_t dir_delete_file(uint16_t dir_inum,uint8_t *name);
uint16_t dir_make_dir(uint16_t dir_inum,uint8_t *name);
uint16_t dir_make_file(uint16_t dir_inum,uint8_t *name,uint16_t dev_num,uint8_t flags);
/* This file was automatically generated.  Do not edit! */
void disk_write(unsigned int blk,unsigned char *addr);
void disk_read(unsigned int blk,unsigned char *addr);
uint16_t disk_init();
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
/* This file was automatically generated.  Do not edit! */
void fs_close();
void fs_init();
uint16_t fs_path_to_inum(uint8_t *name,uint16_t cwd);
extern uint8_t fs_global_buf[DISK_BLK_SIZE];
/* This file was automatically generated.  Do not edit! */
void inode_delete(uint16_t inum);
uint16_t inode_new(uint16_t dev_num,uint8_t flags);
void inode_truncate(struct inode *ind);
void inode_add_blk(struct inode *ind);
void inode_put_all();
void inode_put(struct inode *in);
struct inode *inode_get(uint16_t inum);
void inode_write(struct inode *in,uint16_t inum);
void inode_load(struct inode *in,uint16_t inum);
void inode_force_put(struct inode *in);
struct inode *inode_alloc();
extern struct inode inode_table[INODE_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
void superblock_read();
extern struct superblock superblk;
