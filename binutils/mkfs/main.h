/* This file was automatically generated.  Do not edit! */
int main(int argc,char **argv);
void print_usage();
void run(FILE *out);
void write_superblock(FILE *out);
void init_superblk(uint16_t boot_img_present);
extern struct superblock superblk;
void write_block_ll(FILE *out);
void init_block_ll();
void write_bytes(FILE *out,uint8_t *bytes,size_t size);
void write_word(FILE *out,uint16_t word);
void write_byte(FILE *out,uint8_t byte);
extern uint32_t block_ll_index;
extern uint16_t block_ll[DISK_NUM_BLKS];
