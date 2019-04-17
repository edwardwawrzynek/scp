#ifndef __SYSCALL_INCL
#define __SYSCALL_INCL

/**
 * System Call Mechanism:
 * system calls use int #7
 * Args are passed in (no syscall uses more than four args):
 * arg1: ra
 * arg2: rb
 * arg3: rc
 * arg4: rd
 * system call number: re
 * system call return: re
 */

#include <stdint.h>
#include <stddef.h>
#include <errno.h>

/* make vscode intelisense happy */
#ifndef __SCP__
    #define __reg(a)
    #define __regsused(a)
#endif

int16_t test_syscall(__reg("ra") uint8_t *a0, uint16_t __reg("rb") a1, __reg("rc") uint16_t a2, uint16_t __reg("rd") a3);

int16_t getpid();
int16_t getppid();
int16_t fork();

#define O_RDONLY 1 /* read only mode */
#define O_WRONLY 2 /* write only mode */
#define O_RDWR 3   /* read and write mode */
#define O_APPEND 4 /* start at end of file for writing */
#define O_CREAT 8  /* create file if it doesn't exist (don't do anything if it already does) */
#define O_TRUNC 16 /* truncate file to length 0 */
#define O_EXCL 32  /* fail if O_CREAT is set and file already exists */

#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

 int16_t open(__reg("ra") char * name, __reg("rb") uint16_t flags);

 int16_t read_nb(__reg("ra") uint16_t fd, __reg("rb") uint8_t * buf, __reg("rc") uint16_t bytes, __reg("rd") uint8_t * eof);

 int16_t write_nb(__reg("ra") uint16_t fd, __reg("rb") uint8_t * buf, __reg("rc") uint16_t bytes, __reg("rd") uint8_t * eof);

int16_t read(uint16_t fd, uint8_t * buffer, uint16_t bytes);

int16_t write(uint16_t fd, uint8_t * buffer, uint16_t bytes);

 int16_t dup(__reg("ra") uint16_t fd);

 int16_t dup2(__reg("ra") uint16_t old, __reg("rb") uint16_t new);

 int16_t close(__reg("ra") uint16_t fd);

 int16_t creat(__reg("ra") uint8_t *name);

 int16_t yield();

 int16_t execv(__reg("ra") uint8_t *path, __reg("rb") uint8_t **argv);

 int16_t chdir(__reg("ra") uint8_t *path);

 int16_t fchdir(__reg("ra") uint16_t fd);

 int16_t chroot(__reg("ra") uint8_t *path);

 int16_t exit(__reg("ra") uint16_t return_value);

 int16_t wait_nb(__reg("ra") uint8_t *ret_val);

 int16_t wait(__reg("ra") uint8_t *ret_val);

 int16_t link(__reg("ra") uint8_t *old_path, __reg("rb") uint8_t *new_path);

 int16_t unlink(__reg("ra") uint8_t *path);

 int16_t mkdir(__reg("ra") uint8_t *path);

 int16_t rmdir(__reg("ra") uint8_t *path);

/* directory entry structure */
struct dirent {
    /* inode number of file */
    uint16_t inum;
    /* file name (including null) */
    uint8_t name[14];
};

int16_t readdir(uint16_t fd, struct dirent * dirp);

/* open and close directory fd's (opendir and closedir operate on fds, not DIRP* as in posix) */
int16_t opendir(uint8_t *path);
int16_t closedir(uint16_t fd);

#ifndef SEEK_SET
#define SEEK_SET 1
#endif

#ifndef SEEK_CUR
#define SEEK_CUR 2
#endif

#ifndef SEEK_END
#define SEEK_END 3
#endif

int16_t lseek(__reg("ra") uint16_t fd, __reg("rb") uint16_t pos, __reg("rc") uint16_t whence);

#ifndef __TERMIOS_STRUCT
#define __TERMIOS_STRUCT 1
/* Termios struct */
struct termios {
    /* flags */
    uint16_t flags;
};
#endif

/* ioctl tty requests */
#define TCGETA 0
#define TCSETA 1

/* termios flags */
/* echo input */
#define TERMIOS_ECHO    0b00000001
/* canonical / raw mode */
#define TERMIOS_CANON   0b00000010
/* handle key codes such as ctrl+c, ctrl+d, etc - only handled in CANON mode */
#define TERMIOS_CTRL    0b00000100

/* complete raw mode */
#define TERMIOS_RAW 0

 int16_t ioctl(__reg("ra") uint16_t fd, __reg("rb") uint16_t cmd, __reg("rc") void * arg);

/* stat structure */
struct stat {
    /* file device info (major number in low byte, minor in high) */
    uint16_t st_dev;
    /* file mode (different from flags in inode. Set based on them, also includes pipe flag) */
    uint16_t st_mode;
    /* inode number */
    uint16_t st_ino;
    /* number of links */
    uint16_t st_nlinks;
    /* file size */
    uint16_t st_size;

};

/* stat macros */
#define S_IFMT (~0)

#define S_IFDIR 1
#define S_IEXEC 2
#define S_IFREG 4
#define S_IFIFO 8
#define S_IFDEV 16

#define S_ISDIR(mode) (mode & S_IFDIR)
#define S_ISEXEC(mode) (mode & S_IEXEC)
#define S_ISREG(mode) (mode & S_IFREG)
#define S_ISFIFO(mode) (mode & S_IFIFO)
#define S_ISDEV(mode) (mode & S_IFDEV)

/* dev macros */
#define makedev(maj, min) ((maj) + ((min)<<8))
#define major(dev) ((dev) & 0xff)
#define minor(dev) ((dev) >> 8)

 int16_t stat(__reg("ra") uint8_t *path, __reg("rb") struct stat *stat);
 int16_t fstat(__reg("ra") uint16_t fd, __reg("rb") struct stat *stat);

 int16_t chmod(__reg("ra") uint8_t *path, __reg("rb") uint16_t mode);
 int16_t fchmod(__reg("ra") uint16_t fd, __reg("rb") uint16_t mode);

 int16_t mknod(__reg("ra") uint8_t *path, __reg("rb") uint16_t mode, __reg("rc") uint16_t dev);

 int16_t pipe(__reg("ra") uint16_t *pipefds);

int16_t mkfifo(uint8_t *path);

 int16_t brk(__reg("ra") uint8_t *brk);

 uint8_t * sbrk(__reg("ra") uint16_t inc);

int16_t isatty(uint16_t fd);

extern char * optarg;
extern int optind;
extern int optopt;
extern int opterr;

int getopt(int argc, char **argv, char *optstr);

#endif