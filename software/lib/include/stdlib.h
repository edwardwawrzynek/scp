#ifndef __STDLIB_INCL
#define __STDLIB_INCL 1

#define NULL 0
typedef unsigned int size_t;

char *itoa(int value,char *buffer,int base);
int abs(int val);

int strtol(const char *nptr, char **endptr, register int base);

/* malloc functions */
void *calloc(size_t nmeb,size_t meb_size);
void *realloc(void *ptr,size_t size);
void free(void *ptr);
void *malloc(size_t size);

#endif
