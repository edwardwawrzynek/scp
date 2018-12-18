#include "include/stdint.h"

//Number of bytes in a disk block
#define DISK_BLK_SIZE 512
#define DISK_BLK_SIZE_EXP 9
#define DISK_BLK_SIZE_MASK 511

//superblock blk number
#define SUPERBLOCK_ADDR 383

//start of inode table
#define INODE_TABLE_ADDR 384

//Size of directory entry
#define DIR_ENTRY_SIZE 16

//Inode flags
#define INODE_FLAG_DIR 1
#define INODE_FLAG_EXEC 2

//inode structures
struct inode {
    /* ---- In Disk Values ---- */
    //number of links to this inode
    uint8_t links;
    //flag byte
    uint8_t flags;
    //dev number (0 if normal file)
    uint8_t dev_num;
    //file size
    uint16_t size;
    //first blk - disk block linked list pointer
    uint16_t disk_blk;
    //if the inode is in use
    uint8_t in_use;
    /* ---- In Core only values ---- */
    //inode number - on disk, this is just the inode's addr in the table
    uint16_t inum;
    //references to this inode structure
    uint8_t refs;
    //pointer to malloc'd list of blocks
    uint16_t * blks;
    //number of blks (not counting the trailing zero) in blks
    uint8_t num_blks;
};

//inode on disk
struct disk_inode {
    /* ---- In Disk Values ---- */
    //number of links to this inode
    uint8_t links;
    //flag byte
    uint8_t flags;
    //dev number (0 if normal file)
    uint8_t dev_num;
    //file size
    uint16_t size;
    //first blk - disk block linked list pointer
    uint16_t disk_blk;
    //if the inode is in use
    uint8_t in_use;
};

#define INODES_PER_BLK 64

#define INODES_PER_BLK_EXP 6

#define INODES_PER_BLK_MASK 63

//buffer table struct
struct buffer_header {
    //Pointer to buffer
    uint8_t * buf;
    //Block number
    uint16_t blk;
    //Number of refrences to the buffer
    uint8_t refs;
};

//file table entry
struct file_entry {
    //inode
    struct inode * ind;
    //buffer currently being operated on - disk blk is stored in buffer_header
    struct buffer_header * buf;
    //position in file
    uint16_t pos;
    //file mode
    uint8_t mode;
    //refs to file entry
    uint8_t refs;
};

//file table mode flags
#define FILE_MODE_READ 1
#define FILE_MODE_WRITE 2
#define FILE_MODE_TRUNCATE 4
#define FILE_MODE_APPEND 8

#define SEEK_SET 1
#define SEEK_CUR 2
#define SEEK_END 3

//superblock struct - stored on disk
struct superblock {
    //Number of inodes in fs
    uint16_t num_inodes;
    //First block allocated for data storage
    uint16_t first_blk;
    //Disk name - 8 chars
    char name[9];
};

/* -------- Disk Format --------
 *
 * | Block LL | Boot Area | Super Block | Inode Table | Data Blocks         ...
 * | 256 blks | 127 blks  | 1 blk       | var. size   | rest of disk ~32 mb ...
 *
 * Areas
 * ---- Block LL (linked list) ----
 * This area contains a two byte entry for each blk in the disk. The entry is
 * the block number of the next block in the file to which the block is a part
 * of, or a zero if the blk is not part of any file. The last blk in a file has
 * an entry of 1. Unusable blks (those covering the block ll, boot, super block,
 * and inode table) have an entry of 0xffff.
 * ---- Boot Area ----
 * This area contains the boot code (63.5 kb) to be loaded by the bootloader.
 * The bootloader starts off in memory in the last 512 bytes of the addr space.
 * ---- Super Block ----
 * This area contains information about the disk, such as the number of inodes,
 * the first usable disk block, disk name, etc. See (struct superblock).
 * ---- Inode Table ----
 * This area contains an array of (struct disk_inode). The number of inodes is
 * variable. Each inode has a disk_blk value, which points to the first block of
 * the file in the Block LL. Inodes 0 and 1 don't refernce a file, and the root
 * directory is inode 2.
 * ---- Data Blocks ----
 * The remainder of the disk is allocated to data blocks for file information.
 */

/* -------- Directory Format --------
 * A directory is a normal file, containing a list of filenames and associated
 * inodes. A directory has the directory flag set in its inode.
 *
 * Each file in a directory uses 16 bytes. The first 14 bytes are the filename,
 * and the last two bytes of an entry are its inode number, in little endian. A entry with an
 * inode number of 0 indicates that the entry is unallocated - it is likely a
 * file that has been deleted
 */
/*
extern struct superblock superblk;

extern int some_value;

extern struct buffer_header buffer_table[BUFFER_TABLE_ENTRIES];
extern struct inode inode_table[INODE_TABLE_ENTRIES];
extern struct file_entry file_table[FILE_TABLE_ENTRIES];

//Global general purpose buffer - used in function calls that only need the
//buffer to keep its data within the call
extern uint8_t fs_global_buf[DISK_BLK_SIZE];
*/