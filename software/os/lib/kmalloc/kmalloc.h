#include <stddef.h>
void kfree(void *ptr);
void * krealloc(void *ptr, size_t size);
void * kcalloc(size_t nmeb, size_t meb_size);
void * kmalloc(size_t size);
