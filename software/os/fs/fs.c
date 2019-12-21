#include "include/defs.h"
#include <lib/string.h>

#include "fs/superblock.h"
#include "fs/disk.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include "fs/file.h"
#include "fs/dir.h"
#include <lib/kstdio_layer.h>
#include "lib/inout.h"

//Just defines fs_global_buf
uint8_t fs_global_buf[DISK_BLK_SIZE];

#define PATH_BUF_SIZE 256
/* buffer for path to inode conversions */
static uint8_t fs_path_buf[PATH_BUF_SIZE];

/* convert a filesystem path to an inode number, given a name and cwd inum,
 * and a root inum (probably a process root) to start / paths at
 * returns (uint16_t) the inum , or 0 if not found */

uint16_t fs_path_to_inum(uint8_t * path, uint16_t cwd, uint16_t croot){
    strncpy(fs_path_buf, path, PATH_BUF_SIZE);
    uint8_t * name = fs_path_buf;
    //temporary value only to allow the while loop to run once - gets set after
    uint8_t *i;
    //If name starts with /, start searching at root
    while(name[0] == '/'){
        ++name;
        cwd = croot;
    }
    //Loop
    while(cwd){
        //exit if a final slash has been hit, and already converted to a null
        if(!name[0]){break;}
        //change / to a null character
        i = strchr(name, '/');
        if(i){
            *i = '\0';
        }
        //load new cwd from dir_name_inode
        cwd = dir_name_inum(cwd, name);
        //update name to after /
        name = i+1;
        //if multiple slashes were next to each other, move past them
        while(*name == '/') {name++;}
        //if i is 0, meaning no more slashes were found, the the loop will exit
        if(!i){
            break;
        }
    }
    return cwd;
}

/* convert a filesystem path into the inum of the directory containing it
 * it doesn't matter wheather the last part of the path exists -
 * this just returns directory above it
 * also, copy name of file (not path) over to file_name
 * returns 0 if a directory at some point doesn't exist */
uint16_t fs_path_to_contain_dir(uint8_t *path, uint16_t cwd, uint16_t croot, uint8_t * file_name){
    strncpy(fs_path_buf, path, PATH_BUF_SIZE);
    uint8_t * name = fs_path_buf;
    /* cut off last / from path */
    uint16_t len = strlen(name);
    /* search for / backwards */
    int16_t index = -1;
    for(int16_t i = len; i >= 0; i--){
        if(name[i] == '/'){
            index = i;
            break;
        }
    }
    /* if no / found, return cwd */
    if(index == -1){
        strcpy(file_name, name);
        return cwd;
    }
    /* make sure / wasn't last thing in path */
    if(index == len -1){
	    return 0;
    }
    name[index] = '\0';
    /* copy from index+1 to len */
    strcpy(file_name, name + index + 1);
    return fs_path_to_inum(name, cwd, croot);
}

/* init the filesystem
 * returns (none) */
void fs_init(){
    disk_init();
    superblock_read();
}

/* close the filesystem, writing everything to disk
 * returns (none) */
void fs_close(){
    file_put_all();
    inode_put_all();
    buffer_flush_all(1);
}
