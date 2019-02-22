#include "include/defs.h"
#include <lib/string.h>

#include "fs/superblock.h"
#include "fs/disk.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include "fs/file.h"
#include "fs/dir.h"
#include <lib/kstdio_layer.h>

//Just defines fs_global_buf
uint8_t fs_global_buf[DISK_BLK_SIZE];

/* convert a filesystem path to an inode number, given a name and cwd inum,
 * and a root inum (probably a process root) to start / paths at
 * returns (uint16_t) the inum , or 0 if not found */

uint16_t fs_path_to_inum(uint8_t * name, uint16_t cwd, uint16_t croot){
    //temporary value only to allow the while loop to run once - gets set after
    uint8_t *i;
    //If name starts with /, start searching at root
    if(name[0] == '/'){
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
        printf("Name going in: %s\n", name);
        cwd = dir_name_inum(cwd, name);
        printf("CWD: %u, Name: %s\n", cwd, name);
        //update name to after /
        name = i+1;
        printf("New name: %s\n", name);
        //if i is 0, meaning no more slashes were found, the the loop will exit
        if(!i){
            break;
        }
    }
    return cwd;
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
    buffer_flush_all();
}
