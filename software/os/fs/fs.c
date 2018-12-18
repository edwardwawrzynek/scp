#include "include/defs.h"
#include "fs/incl.h"
#include "lib/incl.h"

//Just defines fs_global_buf
uint8_t fs_global_buf[DISK_BLK_SIZE];

/* convert a filesystem path to an inode number, given a name and cwd inum
 * returns (uint16_t) the inum , or 0 if not found */

fs_path_to_inum(uint8_t * name, uint16_t cwd){
    uint8_t *i;
    //If name starts with /, start searching at root
    if(*name == '/'){
        ++name;
        cwd = 2;
    }
    //Loop
    while(cwd && i){
        //exit if a final slash has been hit, and already converted to a null
        if(!*name){break;}
        //change / to a null character
        i = strchr(name, '/');
        if(i){
            *i = '\0';
        }
        //load new cwd from dir_name_inode
        cwd = dir_name_inum(cwd, name);
        //update name to after /
        name = i+1;
        //if i is 0, meaning no more slashes were found, the the loop will exit
    }
    return cwd;
}

/* init the filesystem
 * returns (none) */
fs_init(){
    disk_init();
    superblock_read();
}

/* close the filesystem, writing everything to disk
 * returns (none) */
fs_close(){
    file_put_all();
    inode_put_all();
    buffer_flush_all();
}
