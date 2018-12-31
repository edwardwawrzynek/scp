/* This file was automatically generated.  Do not edit! */
void balloc_free(uint16_t blk);
uint16_t *balloc_get(uint16_t first_blk,uint8_t *num_blks);
void balloc_put(uint16_t *blocks);
uint16_t balloc_alloc();
extern uint16_t balloc_get_buf[129];
extern uint16_t balloc_buffer[256];
