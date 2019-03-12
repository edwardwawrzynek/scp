int _serial_ioctl(int minor,int req_code,uint8_t *val);
int _serial_close(int minor);
int _serial_open(int minor);
int _serial_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
int _serial_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
