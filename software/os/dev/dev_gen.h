/* This file was automatically generated.  Do not edit! */
int no_ioctl(int minor,int req_code,uint8_t *arg,struct inode *file);
int no_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
int no_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
int no_close(int minor,struct inode *file);
int no_open(int minor,struct inode *file);
int _dev_tty_gen_ioctl(int minor,int req_code,uint8_t *arg,tty_dev_t *tty_dev_access);
int _dev_tty_gen_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*putc)(char),tty_dev_t *termios);
int _dev_tty_gen_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*getc)(),int(*putc)(char),tty_dev_t *termios);
uint8_t _dev_tty_write_into_buf(uint8_t *buf,uint8_t c,uint8_t *ind,uint8_t echo,int(*putc)(char),uint8_t last_write_end,tty_dev_t *tty_dev);
int _tty_getc(tty_dev_t *tty_dev,int(*getc)());
int _tty_putc(tty_dev_t *tty_dev,int(*putc)(char),char c);
int _dev_gen_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*getc)());
int _dev_gen_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,int(*putc)(char));
