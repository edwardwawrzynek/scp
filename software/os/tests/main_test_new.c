#include <lib/kstdio_layer.h>
#include <lib/kmalloc.h>
#include "include/defs.h"

#include "fs/superblock.h"
#include "fs/buffer.h"
#include "fs/inode.h"
#include "fs/fs.h"

#include <lib/util.h>

extern int _BRK_END;

int main(){
    kstdio_set_output_dev(0);

    printf("Testing\nNumber: %i, Hex: %x\nChar: %c\nString: %s\n", -2, 0xffa, 'H', "Hello, World!");

    printf("brk end: %x\n", (int)(&_BRK_END));

    int * var = kmalloc(0x100);
    printf("Addr 0: %x\n", (int)var);
    kfree(var);
    var = kmalloc(0x50);
    printf("Addr 1: %x\n", (int)var);
    var = kmalloc(0x50);
    printf("Addr 3: %x\n", (int)var);


    superblock_read();

    printf("Num Inodes: %u, First Blk: %u, Name: %s\n", superblk.num_inodes, superblk.first_blk, superblk.name);


    struct inode *in = inode_get(3);
    printf("Inode: %u\n", (unsigned int)in);
    printf("Links: %u, Flags: %u, Dev: %u, Size: %u, disk_blk: %u, in_use: %u, Inum: %u, refs: %u, blks: %u, num_blks: %u\n", (unsigned int)in->links, (unsigned int)in->flags, (unsigned int)in->dev_num, (unsigned int)in->size, (unsigned int)in->disk_blk, (unsigned int)in->in_use, (unsigned int)in->inum, (unsigned int)in->refs, (unsigned int)in->blks, (unsigned int)in->num_blks);


    fs_close();

    while(1){
        putchar(getchar());
    }

}