/* This file was automatically generated.  Do not edit! */
int _special_ioctl(int minor,int req_code,uint8_t *arg,struct inode *file);
int _special_close(int minor,struct inode *file);
int _special_open(int minor,struct inode *file);
int _special_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
int _special_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *file);
