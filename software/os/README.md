# SCP OS
The operating system for scp, featuring a full filesystem, multitasking, and memory managment.

## Filesystem
The filesystem is located in `/fs`, and contains the following files:<br>
`disk.c` - disk reading and writing routines<br>
`buffer.c` - buffer allocation and release for individual disk block<br>
`superblock.c` - superblock reading and writing <br>
`balloc.c` - allocation of unused disk blocks, and managing block linked lists<br>
`inode.c` - managment of on disk inodes and loading and release of in memory inodes<br>
`file.c` - abstraction of disk blocks to continous files from inodes, with high level use methods<br>
`dir.c` - methods for managment of directories<br>
`fs.c` - filesystem initing, and release, along with pathname resolution.