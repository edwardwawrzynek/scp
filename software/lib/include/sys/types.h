#ifndef __SYS_TYPES_INCL
#define __SYS_TYPES_INCL

#include <stddef.h>
#include <stdint.h>

#ifndef PIDT_DEF
#define PIDT_DEF 1
typedef int16_t pid_t;
#endif

typedef uint16_t blkcnt_t;
typedef uint16_t blksize_t;
typedef uint8_t dev_t;
typedef uint16_t ino_t;

/* TODO: 32 bit int time */
typedef uint16_t time_t;

#endif