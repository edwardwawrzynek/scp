/* This file was automatically generated.  Do not edit! */
balloc_free(uint16_t blk);
balloc_get(uint16_t first_blk,uint8_t *num_blks);
balloc_put(uint16_t *blocks);
balloc_alloc();
extern uint16_t balloc_get_buf[129];
extern uint16_t balloc_buffer[256];
/* This file was automatically generated.  Do not edit! */
buffer_flush_all();
buffer_put(struct buffer_header *buf);
buffer_get(uint16_t blk);
buffer_alloc(uint16_t blk);
extern struct buffer_header buffer_table[BUFFER_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
dir_name_inum(uint16_t dir_inum,uint8_t *name);
dir_next_entry(struct file_entry *file,uint8_t *name);
dir_delete_file(uint16_t dir_inum,uint8_t *name);
dir_make_dir(uint16_t dir_inum,uint8_t *name);
dir_make_file(uint16_t dir_inum,uint8_t *name,uint16_t dev_num,uint8_t flags);
/* This file was automatically generated.  Do not edit! */
disk_write(unsigned int blk,unsigned char *addr);
disk_read(unsigned int blk,unsigned char *addr);
disk_init();
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
/* This file was automatically generated.  Do not edit! */
fs_close();
fs_init();
fs_path_to_inum(uint8_t *name,uint16_t cwd);
extern uint8_t fs_global_buf[DISK_BLK_SIZE];
/* This file was automatically generated.  Do not edit! */
inode_delete(uint16_t inum);
inode_new(uint16_t dev_num,uint8_t flags);
inode_truncate(struct inode *ind);
inode_add_blk(struct inode *ind);
inode_put_all();
inode_put(struct inode *in);
inode_get(uint16_t inum);
inode_write(struct inode *in,uint16_t inum);
inode_load(struct inode *in,uint16_t inum);
inode_force_put(struct inode *in);
inode_alloc();
extern struct inode inode_table[INODE_TABLE_ENTRIES];
/* This file was automatically generated.  Do not edit! */
superblock_read();
extern struct superblock superblk;
