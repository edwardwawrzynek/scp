int _tty_close(int minor);
int _tty_open(int minor);
int _tty_read(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);
int _tty_write(int minor, uint8_t *buf, size_t bytes, uint8_t *eof);