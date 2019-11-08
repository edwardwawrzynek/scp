#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "defs.h"

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
  memset(block_ll, 0, sizeof(block_ll));
  for(uint16_t i = 0; i < FIRST_DATA_BLK; i++) {
    block_ll[i] = 0xffff;
  }
  block_ll_index = FIRST_DATA_BLK;
}

/* write out block linked list */
void write_block_ll(FILE * out) {
  fseek(out, 0, SEEK_SET);
  for(uint32_t i = 0; i < DISK_NUM_BLKS; i++) {
    fwrite(&block_ll[i], sizeof(uint16_t), 1, out);
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
  write_bytes(out, superblk.name, 9);
  write_word(out, superblk.is_boot_disk);
}

void run(FILE * out) {
  /* setup block linked list */
  init_block_ll();
  write_block_ll(out);
  /* TODO: check if we have a boot image */
  init_superblk(1);
  write_superblock(out);
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

  run(out_file);
}