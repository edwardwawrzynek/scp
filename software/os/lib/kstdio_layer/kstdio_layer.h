#include <stdarg.h>
void printf(char *format,...);
void vprintf(char *format,va_list args);
void _uprintn(unsigned int number,unsigned int radix);
void _sprintn(int number,int radix);
char *gets(char *buf);
int puts(char *str);
int getchar(void);
int putchar(int c);
void kstdio_set_output_dev(int dev_index);
