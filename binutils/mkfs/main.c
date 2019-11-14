#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include "defs.h"
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

/* block linked list to be written to disk */
uint16_t block_ll[DISK_NUM_BLKS];
/* current assignment index in linked list */
uint32_t block_ll_index = 0;

/* util (force little endian writing) */
void write_byte(FILE * out, uint8_t byte) {
  fputc(byte, out);
}

void write_word(FILE * out, uint16_t word) {
  fputc(word & 0x00ff, out);
  fputc((word >> 8) & 0x00ff, out);
}

void write_bytes(FILE * out, uint8_t * bytes, size_t size) {
  while(size--) {
    fputc(*bytes++, out);
  }
}

/* zero out linked list, then set entries to 0xffff if they can't be assigned */
void init_block_ll() {
  /* zero */
  memset(block_ll, BLOCK_LL_FREE, sizeof(block_ll));
  for(uint16_t i = 0; i < FIRST_DATA_BLK; i++) {
    block_ll[i] = BLOCK_LL_RESERVED;
  }
  block_ll_index = FIRST_DATA_BLK;
}

/* write out block linked list */
void write_block_ll(FILE * out) {
  fseek(out, 0, SEEK_SET);
  for(uint32_t i = 0; i < DISK_NUM_BLKS; i++) {
    write_word(out, block_ll[i]);
  }
}

/**
 * assign n blocks from the block ll
 * return a malloc'd list of block numbers
 * and write to block ll
 */
uint16_t * alloc_blocks(size_t n) {
  uint16_t * res = calloc(n, sizeof(uint16_t));
  for(size_t i = 0; i < n; i++) {
    res[i] = block_ll_index;
    if(i == n-1) {
      block_ll[block_ll_index] = BLOCK_LL_END;
    } else {
      block_ll[block_ll_index] = block_ll_index+1;
    }
    block_ll_index++;
  }

  return res;
}

/**
 * write os image to disk */
void write_os_image(FILE * out, FILE * img) {
  fseek(out, OS_IMG_FIRST_BLK * DISK_BLK_SIZE, SEEK_SET);
  fseek(img, 0, SEEK_SET);
  while(1) {
    int c = fgetc(img);
    if(c == EOF) break;
    fputc(c, out);
  }
}

/* handle superblock */
struct superblock superblk;

void init_superblk(uint16_t boot_img_present) {
  superblk.num_inodes = NUMBER_OF_INODES;
  strncpy(superblk.name, DISK_NAME, 8);
  superblk.name[8] = '\0';
  superblk.first_blk = FIRST_DATA_BLK;
  superblk.is_boot_disk = boot_img_present;
}

void write_superblock(FILE * out) {
  fseek(out, SUPERBLOCK_ADDR * DISK_BLK_SIZE, SEEK_SET);
  write_word(out, superblk.num_inodes);
  write_word(out, superblk.first_blk);
  write_bytes(out, (uint8_t *) superblk.name, 9);
  write_word(out, superblk.is_boot_disk);
}

/* list of files */
struct host_inode * host_inodes = NULL;
size_t host_inodes_size = 0;
size_t host_inodes_index = 0;

#define HOST_INODES_INC 64

/* disk inode alloc number (0 is unused, 1 is superblk, 2 is root) */
size_t disk_inode_index = 2;

/**
 * Add a new host_inode entry to the list, expanding it if needed, and return a pointer to it */
struct host_inode * new_host_inode() {
  if(host_inodes == NULL) {
    host_inodes = malloc(sizeof(struct host_inode) * HOST_INODES_INC);
    host_inodes_size = HOST_INODES_INC;
  }
  if(host_inodes_index >= host_inodes_size) {
    host_inodes_size += HOST_INODES_INC;
    host_inodes = realloc(host_inodes, sizeof(struct host_inode) * host_inodes_size);
  }

  return &host_inodes[host_inodes_index++];
}

/**
 * lookup host_inode with the given inode num, and return */
struct host_inode * find_by_inum(ino_t inum) {
  for(size_t i = 0; i < host_inodes_index; i++) {
    if(host_inodes[i].host_inum == inum) return &host_inodes[i];
  }
  return NULL;
}

struct host_inode * create_host_inode(uint8_t is_dir, uint8_t is_exec, uint8_t is_dev, uint16_t dev_major, uint16_t dev_minor, size_t file_size, ino_t host_inum, char * host_path) {
  struct host_inode * res = new_host_inode();
  res->host_inum = host_inum;
  res->host_path = host_path;
  if(is_dev) {
    res->disk_inode.dev_num = dev_major;
    res->disk_inode.dev_minor = dev_minor;
  } else {
    res->disk_inode.dev_num = 0;
    res->disk_inode.dev_minor = 0;
  }
  res->disk_inode.flags = 0;
  if(is_dir) res->disk_inode.flags |= 1;
  if(is_exec) res->disk_inode.flags |= 2;
  res->disk_inode.size = file_size;
  res->disk_inum = disk_inode_index++;
  res->written_to_disk = 0;
  res->disk_inode.links = 0;

  return res;
}

/**
 * just write inode to disk, don't write data associated with it
 */
void write_inode_to_disk(struct host_inode * inode, FILE * out) {
  fseek(out, (INODE_TABLE_ADDR)*DISK_BLK_SIZE+(inode->disk_inum)*DISK_INODE_SIZE, SEEK_SET);

  write_byte(out, inode->disk_inode.links);
  write_byte(out, inode->disk_inode.flags);
  write_byte(out, inode->disk_inode.dev_num);
  write_word(out, inode->disk_inode.size);
  write_word(out, inode->disk_inode.disk_blk);
  write_byte(out, inode->disk_inode.dev_minor);

  inode->written_to_disk = 1;
}

/**
 * write all inodes to disk
 */
void write_inodes(FILE * out) {
  for(size_t i = 0; i < host_inodes_index; i++) {
    write_inode_to_disk(&host_inodes[i], out);
  }
}

/**
 * write file associated with it to disk */
void write_file_to_disk(struct host_inode * inode, FILE * out, FILE * in) {
  /* allocate blocks from disk */
  size_t blocks = (inode->disk_inode.size / DISK_BLK_SIZE) + 1;

  uint16_t * blks = alloc_blocks(blocks);
  inode->disk_inode.disk_blk = blks[0];
  /* write data */
  uint16_t current_blk = blks[0];
  size_t block_index = 0;
  for(size_t i = 0; i < inode->disk_inode.size; i++) {
    if(i % DISK_BLK_SIZE == 0) {
      current_blk = blks[block_index++];
      fseek(out, current_blk*DISK_BLK_SIZE, SEEK_SET);
    }

    int c = fgetc(in);
    assert(c != EOF);
    fputc(c, out);
  }

  free(blks);
}

/**
 * create and write inodes 0 and 1 to disk
 * 0 is null inode
 * 1 is superblock inode */
void write_0_1_inodes(FILE * out) {
  struct disk_inode ind = {
    .links = 1, .flags = 0, .size = 0, .dev_num = 0, .dev_minor = 0, .disk_blk = 0,
  };
  struct host_inode hind = {
    .disk_inode = ind, .disk_inum = 0, .host_inum = 0, .host_path = NULL
  };
  write_inode_to_disk(&hind, out);
  hind.disk_inode.disk_blk = SUPERBLOCK_ADDR;
  hind.disk_inum = 1;
  write_inode_to_disk(&hind, out);
}

/* make disk image a whole 32 mb */
void expand_disk(FILE * out) {
  fseek(out, (DISK_BLK_SIZE * DISK_NUM_BLKS)-1, SEEK_SET);
  int c = fgetc(out);
  if(c == EOF) c = 0;
  fseek(out, (DISK_BLK_SIZE * DISK_NUM_BLKS)-1, SEEK_SET);
  fputc(c, out);
}

/**
 * test if file name is a special file to not include in fs */
uint8_t is_scp_file_dont_include(char * name) {
  if(!strcmp(name, SCP_OS_FILE_NAME)) return 1;
  return 0;
}

/**
 * return the real name of a file, given a name that may include a dev prefix
 * returned string is not malloc'd
 */
char * scp_file_get_real_name(char * name) {
  if(!strncmp(name, SCP_DEV_FILE_PREFIX, strlen(SCP_DEV_FILE_PREFIX))) {
    /* format __SCP__DEV_mm_nn_name where mm is major number in hes, nn is minor */
    return name + SCP_DEV_PREFIX_LENGTH; 
  } else {
    return name;
  }
}

/**
 * test if a file is a dev file and set values if it is 
 * return 1 if file is dev, 0 otherwise*/
uint8_t scp_test_dev(char * name, uint16_t *dev_major, uint16_t *dev_minor) {
  if(!strncmp(name, SCP_DEV_FILE_PREFIX, strlen(SCP_DEV_FILE_PREFIX))) {
    /* format __SCP__DEV_mm_nn_name where mm is major number in hes, nn is minor */
    unsigned int maj;
    unsigned int min;
    sscanf(name, "__SCP__DEV_%x_%x_", &maj, &min);
    *dev_major = maj;
    *dev_minor = min;
    return 1;
  } else {
    *dev_major = 0;
    *dev_minor = 0;
    return 0;
  }
}

/**
 * recursively explore the file system, generate + write inodes, and write file contents to disk 
 * host_path is the directory to open
 * out is disk image
 * disk_parent_inum is the scp inum of the parent of this directory 
 * host_inum is the inum index of this directory
 * 
 * return the scp inum of the directory file created */
uint16_t recurse_host_fs(char * host_path, FILE *out, ino_t host_inum, uint16_t disk_parent_inum) {
  DIR * dir = opendir(host_path);
  if(dir == NULL) {
    fprintf(stderr, BIN_NAME ": failed to open directory %s: ", host_path);
    perror(NULL);
    exit(1);
  }
  /* count number of files (including . and ..) */
  size_t num_files = 0;
  struct dirent * entry;
  while((entry = readdir(dir)) != NULL) {
    if(!is_scp_file_dont_include(entry->d_name)) num_files++;
  }
  rewinddir(dir);

  /* create directory entry */
  struct host_inode * inode = create_host_inode(1, 0, 0, 0, 0, num_files * DIRECTORY_ENTRY_SIZE, host_inum, host_path);
  /* link from parent and from . entry */
  inode->disk_inode.links = 2;
  /* allocate space */
  uint16_t * blks = alloc_blocks((inode->disk_inode.size / DISK_BLK_SIZE) + 1);
  inode->disk_inode.disk_blk = blks[0];

  char name[14];
  size_t index = 0;
  while((entry = readdir(dir)) != NULL) {
    if(is_scp_file_dont_include(entry->d_name)) continue;
    fseek(out, blks[0]*DISK_BLK_SIZE + index*DIRECTORY_ENTRY_SIZE, SEEK_SET);

    /* write nanem */
    memset(name, 0, 14);
    char * file_name = scp_file_get_real_name(entry->d_name);
    strncpy(name, file_name, 14);
    write_bytes(out, (uint8_t *)name, 14);
    if(!strcmp(name, ".")) write_word(out, inode->disk_inum);
    else if(!strcmp(name, "..")) write_word(out, disk_parent_inum);
    else {
      /* check if we already wrote this inode to disk */
      struct host_inode * prev_inode = find_by_inum(entry->d_ino);
      if(prev_inode != NULL) {
        /* this is a hard link, just inc links and write inum */
        prev_inode->disk_inode.links++;
        write_word(out, prev_inode->disk_inum);
      } else {
        /* we have to create the file on disk */
        /* make path */
        char * path = malloc(strlen(host_path) + strlen(entry->d_name) + 2);
        sprintf(path, "%s/%s", host_path, entry->d_name);
        /* get file information */
        struct stat file_stat;
        stat(path, &file_stat);
        if(S_ISDIR(file_stat.st_mode)) {
          /* file is directory, so it will have a .. entry that links back to us. inc link count */
          inode->disk_inode.links++;
          uint16_t disk_inum = recurse_host_fs(path, out, entry->d_ino, inode->disk_inum);
          fseek(out, blks[0]*DISK_BLK_SIZE + index*DIRECTORY_ENTRY_SIZE + 14, SEEK_SET);
          write_word(out, disk_inum);
        } else {
          /* create file */
          uint16_t dev_major = 0;
          uint16_t dev_minor = 0;
          uint8_t is_dev = scp_test_dev(entry->d_name, &dev_major, &dev_minor);
          struct host_inode * file_inode = create_host_inode(0, file_stat.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH), is_dev, dev_major, dev_minor, file_stat.st_size, entry->d_ino, path);
          FILE * file = fopen(path, "r");
          if(file == NULL) {
            fprintf(stderr, BIN_NAME ": can't open file %s: ", path);
            perror(NULL);
            exit(1);
          }
          file_inode->disk_inode.links = 1;
          write_file_to_disk(file_inode, out, file);
          fseek(out, blks[0]*DISK_BLK_SIZE + index*DIRECTORY_ENTRY_SIZE + 14, SEEK_SET);
          write_word(out, file_inode->disk_inum);
        }

        free(path);
      }
    }

    index++;
  }

  closedir(dir);

  free(blks);

  return inode->disk_inum;
  
}

void run(FILE * out, char * fs_path) {
  /* test for os image */
  char * os_img_path = malloc(strlen(fs_path) + strlen(SCP_OS_FILE_NAME) + 2);
  sprintf(os_img_path, "%s/%s", fs_path, SCP_OS_FILE_NAME);
  FILE * os_img = fopen(os_img_path, "r");
  uint8_t do_os_img = os_img != NULL;
  free(os_img_path);

  /* setup block linked list */
  init_block_ll();

  init_superblk(do_os_img);

  recurse_host_fs(fs_path, out, 0, 2);

  write_block_ll(out);
  write_superblock(out);
  write_0_1_inodes(out);
  write_inodes(out);
  if(do_os_img) {
    write_os_image(out, os_img);
  }
  expand_disk(out);
}

void print_usage() {
  fprintf(stderr, "usage: " BIN_NAME " filesys_dir out.img\n");
  exit(1);
}

int main(int argc, char ** argv) {
  if(argc < 3) {
    print_usage();
  }
  /* set file to 32 mb */
  truncate(argv[2], 0);
  truncate(argv[2], DISK_SIZE);
  /* open for writing */
  FILE * out_file = fopen(argv[2], "w");
  if(out_file == NULL) {
    perror(BIN_NAME "error opening output file");
  }

  char * fs_path = argv[1];

  if(fs_path[strlen(fs_path) -1] == '/') {
    fs_path[strlen(fs_path) -1] = '\0';
  }

  run(out_file, fs_path);

  return 0;
}
