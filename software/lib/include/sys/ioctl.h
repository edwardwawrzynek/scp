#ifndef __SYS_IOCTL_INCL
#define __SYS_IOCTL_INCL 1

#include <stdint.h>

int16_t ioctl(__reg("ra") uint16_t fd, __reg("rb") uint16_t cmd, __reg("rc") void * arg);

#endif