#include "include/defs.h"
#include "fs/incl.h"
#include "lib/incl.h"

struct superblock superblk;

void superblock_read(){
    disk_read(SUPERBLOCK_ADDR, fs_global_buf);
    memcpy(superblk, fs_global_buf, sizeof(struct superblock));
}
