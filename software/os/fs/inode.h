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
