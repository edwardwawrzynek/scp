#ifndef _DEFS_H
#define _DEFS_H

#ifdef SCP
#define BIN_NAME "mkfs"
#endif

#ifndef BIN_NAME
#define BIN_NAME "scpmkfs"
#endif

#include <unistd.h>
#include <sys/types.h>
#include <stdint.h>

/**
 * see /software/os/include/fs.h for filesystem layout information 
 */

//superblock struct - stored on disk
struct superblock {
    //Number of inodes in fs
    uint16_t num_inodes;
    //First block allocated for data storage
    uint16_t first_blk;
    //Disk name - 8 chars
    char name[9];
    //If a bootable image is present in the OS image segment
    uint16_t is_boot_disk;
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
    //device minor number (only used if dev_num is non zero)
    uint8_t dev_minor;
};

//Number of bytes in a disk block
#define DISK_BLK_SIZE 512
#define DISK_BLK_SIZE_EXP 9
#define DISK_BLK_SIZE_MASK 511

//disk size
#define DISK_NUM_BLKS 65536
#define DISK_SIZE (DISK_NUM_BLKS * DISK_BLK_SIZE)

//superblock blk number
#define SUPERBLOCK_ADDR 383

//start of inode table
#define INODE_TABLE_ADDR 384

//Inode mode flags
#define INODE_FLAG_DIR 1
#define INODE_FLAG_EXEC 2

//With 16k inodes, the inode table takes up 256 blocks exactly (8 bytes (size of disk_inode on disk)*16384)/DISK_BLK_SIZE)
#define NUMBER_OF_INODES 16384
#define DISK_NAME "SCP_DISK"

//size of inode on disk
#define DISK_INODE_SIZE 8
#define INODE_TABLE_BLKS ((DISK_INODE_SIZE*NUMBER_OF_INODES)/DISK_BLK_SIZE)
#define FIRST_DATA_BLK (INODE_TABLE_ADDR + INODE_TABLE_BLKS)

/* Special scp files prefix */
#define SCP_SPECIAL_FILE_PREFIX "__SCP__"

/* name of file to be written to os area on disk (__SCP__OS_IMAGE) */
#define SCP_OS_FILE_NAME (SCP_SPECIAL_FILE_PREFIX "OS_IMAGE")

/* information we need for files from fd */
struct host_file {
    char name[14]; /* file name */
    /* device files (pipes are major number 3) */
    uint8_t is_dev;
    uint8_t dev_major;
    uint8_t dev_minor;
    /* 1 if exec flag was set */
    uint8_t exec_flag;
    /* used for making hard links */
    ino_t inode_num;

};

#endif