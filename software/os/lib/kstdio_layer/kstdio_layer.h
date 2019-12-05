#include <stdarg.h>
#include <stdint.h>
void printf(char *format,...);
void vprintf(char *format,va_list args);
void _uprintn(unsigned int number,unsigned int radix);
void _sprintn(int number,int radix);
char *gets(char *buf);
int puts(char *str);
int getchar(void);
int putchar(int c);
void kstdio_set_output_dev(int dev_index);
void kstdio_layer_init(int dev_index);
int kstdio_up();
void kstdio_ioctl(int req_code, uint16_t arg);
