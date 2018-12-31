/* This file was automatically generated.  Do not edit! */
void buffer_flush_all();
void buffer_put(struct buffer_header *buf);
struct buffer_header *buffer_get(uint16_t blk);
struct buffer_header *buffer_alloc(uint16_t blk);
extern struct buffer_header buffer_table[BUFFER_TABLE_ENTRIES];
