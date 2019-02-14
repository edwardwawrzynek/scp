/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
int _dev_gen_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*getc)());
int _dev_gen_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*putc)(char));
uint8_t _dev_tty_write_into_buf(uint8_t *buf,uint8_t c,uint8_t *ind);
