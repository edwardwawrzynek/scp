#ifndef __STRING_INCL

#define __STRING_INCL 1

#include <stddef.h>
void *memchr(const void *s,int c,size_t n);
char *strstr(const char *s1,const char *s2);
int memcmp(const void *cs,const void *ct,size_t count);
void *memmove(void *dest,const void *src,size_t count);
void *memcpy(void *dest,const void *src,size_t count);
void *memset(void *s,int c,size_t count);
char *strpbrk(const char *cs,const char *ct);
size_t strcspn(const char *s,const char *reject);
size_t strspn(const char *s,const char *accept);
size_t strnlen(const char *s,size_t count);
size_t strlen(const char *s);
char *strnchr(const char *s,size_t count,int c);
char *strrchr(const char *s,int c);
char *strchr(const char *s,int c);
int strncmp(const char *cs,const char *ct,size_t count);
int strcmp(const char *cs,const char *ct);
char *strncat(char *dest,const char *src,size_t count);
char *strcat(char *dest,const char *src);
char *strncpy(char *dest,const char *src,size_t count);
char *strcpy(char *dest,const char *src);
char * strerror(int err);
char * strdup(char *str);

#endif
