#include "include/defs.h"
#include "fs/disk.h"
#include "fs/fs.h"
#include <lib/util.h>

struct superblock superblk;

void superblock_read(){
    uint8_t *buf = fs_global_buf;
    disk_read(SUPERBLOCK_ADDR, fs_global_buf);
    superblk.num_inodes = _read_word(&buf);
    superblk.first_blk = _read_word(&buf);

    _read_bytes(&buf, superblk.name, 9);

}
