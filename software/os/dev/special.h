/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
extern uint16_t rand_m;
extern uint16_t rand_c;
extern uint16_t rand_a;
extern uint16_t rand_val;
int _zero_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
int _null_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
int _random_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
