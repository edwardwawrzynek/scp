#include "include/defs.h"
#include "fs/incl.h"
#include "lib/incl.h"

//This file contains routines for managing the directory structure

/**
 *  creates a file in a directory, given the directory's inode number and file
 * name, along with its dev number and flags (almost always 0)
 * returns (uint16_t) - the inum of the new inode, or 0 if failure */

dir_make_file(uint16_t dir_inum, uint8_t * name, uint16_t dev_num, uint8_t flags){
    struct file_entry * dir;
    uint16_t entry_i;
    uint16_t new_inum;
    //open the directory
    dir = file_get(dir_inum, FILE_MODE_READ | FILE_MODE_WRITE);
    if(!dir){
        return 0;
    }
    //find an open entry in the file, using fs_global_buf
    entry_i = -1;
    do{
        ++entry_i;
        //If no more room in dir, break
        if(file_read(dir, fs_global_buf, DIR_ENTRY_SIZE) != DIR_ENTRY_SIZE){
            break;
        }
      //Break when an zero inode is found
    } while(fs_global_buf[14] | fs_global_buf[15]);
    //seek to entry
    file_seek(dir, entry_i*DIR_ENTRY_SIZE, SEEK_SET);
    //create inode - regular file with no flags, unless a directory is created
    new_inum = inode_new(dev_num, flags);
    //clear fs_global_buf
    memset(fs_global_buf, 0, DIR_ENTRY_SIZE);
    //set name
    strcpy(fs_global_buf, name);
    //set inode number in entry
    fs_global_buf[14] = new_inum&0xff;
    fs_global_buf[15] = new_inum>>8;
    //write
    if(file_write(dir, fs_global_buf, DIR_ENTRY_SIZE) != DIR_ENTRY_SIZE){
        inode_delete(new_inum);
        file_put(dir);
        return 0;
    }
    file_put(dir);
    //new_inode already sets the links to 1
    return new_inum;
}

/**
 *  creates a directory in a directory, given the parent's inum and the new dir's
 * name. creates . and .. entries, and sets INODE_FLAG_DIR.
 * returns (uint16_t) - the inum of the new directory, or 0 if failure */

dir_make_dir(uint16_t dir_inum, uint8_t * name){
    uint16_t inum;
    struct file_entry * dir;
    inum = dir_make_file(dir_inum, name, 0, INODE_FLAG_DIR);
    //only continue if creation worked
    if(inum){
        //open dir to write . and ..
        dir = file_get(inum, FILE_MODE_WRITE);
        if(!dir){
            return 0;
        }
        //clear fs_global_buf
        memset(fs_global_buf, 0, 32);
        //. entry
        fs_global_buf[0] = '.';
        fs_global_buf[14] = inum&0xff;
        fs_global_buf[15] = inum>>8;
        //.. entry
        fs_global_buf[16] = '.';
        fs_global_buf[17] = '.';
        fs_global_buf[30] = dir_inum&0xff;
        fs_global_buf[31] = dir_inum>>8;
        //write
        if(file_write(dir, fs_global_buf, 32) != 32){
            file_put(dir);
            return 0;
        }
        //inc the link count to the directory for . entry
        ++dir->ind->links;
        //release dir
        file_put(dir);
        //inc link count for parent directory for .. entry
        dir = file_get(dir_inum, FILE_MODE_READ);
        if(!dir){
            return 0;
        }
        ++dir->ind->links;
        file_put(dir);
        return inum;
    }
    return 0;
}

/**
 * unlink an entry with the name name in the dir specified by dir_inum. This
 * sets the entry's inode to zero, and decs its link count
 * returns (uint16_t) 0 for success, or a non-0 value on failure */

dir_delete_file(uint16_t dir_inum, uint8_t *name){
    struct file_entry * dir;
    uint16_t inum;
    struct inode * ind;
    //open the directory
    dir = file_get(dir_inum, FILE_MODE_READ | FILE_MODE_WRITE);
    if(!dir){
        return 1;
    }
    //find the entry matching the specified name
    while (1){
        //If no more room in dir, error
        if(file_read(dir, fs_global_buf, DIR_ENTRY_SIZE) != DIR_ENTRY_SIZE){
            file_put(dir);
            return 1;
        }
        //compare strings
        if(!strcmp(name, fs_global_buf) && (fs_global_buf[14] || fs_global_buf[15])){
            break;
        }
    }
    //record inum
    inum = fs_global_buf[14] + (fs_global_buf[15]<<8);
    //if inum is zero, the entry has been voided, so return fail
    if(!inum){
        file_put(dir);
        return 1;
    }
    //seek to entry
    file_seek(dir, -DIR_ENTRY_SIZE, SEEK_CUR);
    //clear inode number
    fs_global_buf[14] = 0;
    fs_global_buf[15] = 0;
    if(file_write(dir, fs_global_buf, DIR_ENTRY_SIZE) != DIR_ENTRY_SIZE){
        file_put(dir);
        return 1;
    }
    //dec link count to file
    ind = inode_get(inum);
    if(!ind){
        return 1;
    }
    --ind->links;
    inode_put(ind);
    //return success
    file_put(dir);
    return 0;
}

/**
 * get the next directory entry's name in the dir pointed to by file. The name
 * is written to name.
 * returns (uint16_t) - 0 on failure, inum of file on success*/

dir_next_entry(struct file_entry * file, uint8_t * name){
    uint16_t res;
    //Read
    do {
        if(file_read(file, fs_global_buf, DIR_ENTRY_SIZE) != DIR_ENTRY_SIZE){
            return 0;
        };
    } while (!(fs_global_buf[14] | fs_global_buf[15]));
    res = fs_global_buf[14] + (fs_global_buf[15]<<8);
    memcpy(name, fs_global_buf, 14);
    return res;
}

/**
 * gets the inode number of an entry in the directory with dir_inum
 * returns (uint16_t) - the inum of the file, or 0 if not found, or other failure */

dir_name_inum(uint16_t dir_inum, uint8_t *name){
    struct file_entry * dir;
    uint16_t res;
    dir = file_get(dir_inum, FILE_MODE_READ);
    if(!dir){
        return 0;
    }
    while(file_read(dir, fs_global_buf, DIR_ENTRY_SIZE) == DIR_ENTRY_SIZE){
        //don't return deleted files (would return 0 anyway, but this clarifies)
        if(!strcmp(name, fs_global_buf) && (fs_global_buf[14] | fs_global_buf[15])){
            res = fs_global_buf[14] + (fs_global_buf[15]<<8);
            file_put(dir);
            return res;
        }
    }
    file_put(dir);
    return 0;
}
