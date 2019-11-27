#ifndef __ERRNO_INCL
#define __ERRNO_INCL 1

/* os creates errno in last word in mem */
#define errno (*((volatile uint16_t *)(0xfffe)))

#define ENOENT 1 /* no such file or directory */
#define EBADF 2 /* bad file descriptor */
#define EEXIST 3 /* file exists */

#define ECHILD 4 /* proc doesn't have any unwaited for children */

#define EUMEM 5 /* couldn't map userspace mem into kernel (probably invalid pointer from userspace) */

#define ENOTDIR 6 /* not a directory */
#define EISDIR 7 /* is a directory */

#define ENOTEMPTY 8 /* directory not empty */

#define ENOMEM 9 /* no memory (or out of bounds on sbrk) */

#define ENOTEX 10 /* not an executable */

#define EARG 11 /* invalid args to syscall */

#define ENOTTY 12 /* improper ioctl for file */

#define EVMOD 13 /* violation of file mode */

#define ENOEXEC 14  /* exec format error */

#define ENOINTRP 15 /* bad interpreter */

#define __ERRNO_LEN 16

#endif