#include "include/defs.h"
#include "fs/incl.h"
extern unsigned char * brk;
extern int _MEM_END;
/*  Creates a filesystem on disk, clearing all contents
    mkfs might sometimes require a completely clean disk to operate, but shouldn't
 */

//Number of inodes to create in the filesystem

/* ---- Configuration Vars ---- */
//With 16k inodes, the inode table takes up 256 blocks exactly ((sizeof(struct disk_inode)*16384)/DISK_BLK_SIZE)
uint16_t NUMBER_OF_INODES = 16384;
char NAME[9] = "SCP_DISK";

/* ---- Prgm Vars ---- */
uint8_t mkfs_buf[DISK_BLK_SIZE];
//Second copy to check if a write is really nessesary
uint8_t mkfs_buf2[DISK_BLK_SIZE];
struct superblock mkfs_sb;

uint16_t blks_written = 0;

/* write to disk, but only if nessesary */
mkfs_disk_write(uint16_t blk, uint8_t * data){
    //disk_read(blk, mkfs_buf2);
    //if(memcmp(data, mkfs_buf2, DISK_BLK_SIZE) != 0){
        disk_write(blk, data);
        ++blks_written;
    //}
}

/* setup superblock structure */
mkfs_set_sb(){
    memcpy(mkfs_sb.name, NAME, 9);
    mkfs_sb.num_inodes = NUMBER_OF_INODES;
    //Blk LL (256) + Boot (127) + Superblock (1) + (NUMBER_OF_INODES/INODES_PER_BLK)
    mkfs_sb.first_blk = ((NUMBER_OF_INODES/INODES_PER_BLK) + INODE_TABLE_ADDR);
}

/* write superblock structure */
mkfs_write_sb(){
    memcpy(mkfs_buf, mkfs_sb, sizeof(struct superblock));
    mkfs_disk_write(SUPERBLOCK_ADDR, mkfs_buf);
}

/* clear mkfs_buf */
mkfs_clear_buf(){
    uint16_t i;
    for(i = 0; i < DISK_BLK_SIZE; ++i){
        mkfs_buf[i] = 0;
    }
}

/* 0xfff out block ll for blocks not availible */
mkfs_write_ll(uint16_t blks){
    uint16_t index;
    mkfs_clear_buf();
    for(index = 0; index<65535; ++index){
        mkfs_buf[(index&0xff)*2] = index < blks ? 0xff : 0x00;
        mkfs_buf[(index&0xff)*2+1] = index < blks ? 0xff : 0x00;
        if((index & 0xff) == 0xff){
            mkfs_disk_write(index>>8, mkfs_buf);
            mkfs_clear_buf();
            if((index&0xfff) == 0xfff){
                putchar('.');
            }
        }
    }
    disk_write(index>>8, mkfs_buf);
    putchar('\n');
}

/* clear inode table (sets all in_uses to 0) */
mkfs_clear_inode_table(){
    uint16_t i, blks;
    blks = NUMBER_OF_INODES/INODES_PER_BLK;
    mkfs_clear_buf();
    for(i = 0; i < blks; ++i){
        mkfs_disk_write(INODE_TABLE_ADDR+i, mkfs_buf);
        if((i&0x00f) == 0x00f){
            putchar('.');
        }
    }
    putchar('\n');
}

/* create the zero and one inode */

mkfs_create_inodes(){
    struct inode ind;
    //clear buf
    mkfs_clear_buf();
    //clear disk_inode's fields
        ind.links = 0;
        ind.flags = 0;
        ind.dev_num = 0;
        ind.size = 0;
        ind.disk_blk = 0;
        ind.in_use = 0;
    //zero inode
    ind.in_use = 1;
    ind.links = 1;
    //copy to buffer
    memcpy(mkfs_buf, &ind, sizeof(struct disk_inode));
    //1 inode
    ind.in_use = 1;
    ind.links = 1;
    ind.disk_blk = SUPERBLOCK_ADDR;
    memcpy(mkfs_buf + sizeof(struct disk_inode), &ind, sizeof(struct disk_inode));
    //write to disk
    mkfs_disk_write(INODE_TABLE_ADDR, mkfs_buf);
    return;
}

/* create root inode */

mkfs_create_root(){
    struct inode * ind;
    ind = inode_get(inode_new(0, INODE_FLAG_DIR));
    //clear to remove all left over data present in file
    mkfs_clear_buf();
    mkfs_buf[0] = '.';
    mkfs_buf[14] = 2;
    mkfs_buf[15] = 0;
    mkfs_buf[16] = '.';
    mkfs_buf[17] = '.';
    mkfs_buf[30] = 2;
    mkfs_buf[31] = 0;
    mkfs_disk_write(*(ind->blks), mkfs_buf);
    ind->size = 32;
    ind->dev_num = 0;
    ind->flags = INODE_FLAG_DIR;
    ind->links = 2;
    ind->in_use = 1;
    inode_put(ind);
}

main(){
    brk = &_MEM_END;
    printf("----- MaKeFileSystem -----\n\nTo be written:\nDisk Name: %s\nInodes: %u\n\n", NAME, NUMBER_OF_INODES);
    mkfs_set_sb();
    printf("Writing Superblock\n");
    mkfs_write_sb();
    printf("Writing Block Linked List\n");
    mkfs_write_ll(mkfs_sb.first_blk);
    printf("Clearing Inode Table\n");
    mkfs_clear_inode_table();
    printf("Creating 0 and 1 inode\n");
    mkfs_create_inodes();
    printf("Creating Root inode\n");
    superblock_read();
    mkfs_create_root();
    printf("Dumping All changes\n");
    fs_close();
    printf("mkfs finished\n");
    while(1){};
}
