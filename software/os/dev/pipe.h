/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
int _pipe_ioctl(int minor,int req_code,uint8_t *arg,struct inode *ind);
int _pipe_write(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *ind);
int _pipe_read(int minor,uint8_t *buf,size_t bytes,uint8_t *eof,struct inode *ind);
int _pipe_close(int minor,struct inode *ind);
int _pipe_open(int minor,struct inode *ind);
