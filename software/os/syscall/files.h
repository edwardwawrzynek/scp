/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
uint16_t _pipe(uint16_t fds,uint16_t a1,uint16_t a2,uint16_t a3);
uint16_t _fchmod(uint16_t fd,uint16_t mode,uint16_t a2,uint16_t a3);
uint16_t _chmod(uint16_t name,uint16_t mode,uint16_t a2,uint16_t a3);
uint16_t _fstat(uint16_t fd,uint16_t stat_struct,uint16_t a2,uint16_t a3);
uint16_t _stat(uint16_t name,uint16_t stat_struct,uint16_t a2,uint16_t a3);
uint16_t _lseek(uint16_t fd,uint16_t pos,uint16_t whence,uint16_t a3);
uint16_t _unlink(uint16_t name,uint16_t a1,uint16_t a2,uint16_t a3);
uint16_t _link(uint16_t old,uint16_t new,uint16_t a2,uint16_t a3);
uint16_t _write_nb(uint16_t fd,uint16_t buf,uint16_t bytes,uint16_t eof);
uint16_t _read_nb(uint16_t fd,uint16_t buf,uint16_t bytes,uint16_t eof);
uint16_t _dup2(uint16_t old,uint16_t new,uint16_t a2,uint16_t a3);
uint16_t _dup(uint16_t fd,uint16_t a1,uint16_t a2,uint16_t a3);
uint16_t _ioctl(uint16_t fd,uint16_t cmd,uint16_t arg,uint16_t a3);
uint16_t _close(uint16_t fd,uint16_t a1,uint16_t a2,uint16_t a3);
uint16_t _mknod(uint16_t name,uint16_t mode,uint16_t dev,uint16_t a3);
uint16_t _creat(uint16_t name,uint16_t a1,uint16_t a2,uint16_t a3);
uint16_t create_file(uint8_t *name,uint16_t dev_num,uint16_t dev_minor);
uint16_t _open(uint16_t name,uint16_t flags,uint16_t a2,uint16_t a3);
extern uint8_t file_name_buf[17];
