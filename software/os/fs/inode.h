/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
uint16_t inode_new(uint16_t dev_num,uint8_t flags,uint8_t dev_minor);
void inode_truncate(struct inode *ind);
void inode_add_blk(struct inode *ind);
void inode_put_all();
void inode_delete(uint16_t inum);
void inode_force_put(struct inode *in);
void inode_put(struct inode *in);
struct inode *inode_get(uint16_t inum);
void inode_write(struct inode *in,uint16_t inum);
void inode_load(struct inode *in,uint16_t inum);
struct inode *inode_alloc();
extern struct inode inode_table[INODE_TABLE_ENTRIES];
