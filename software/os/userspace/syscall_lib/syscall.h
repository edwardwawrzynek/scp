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

uint16_t test_syscall(__reg("ra") uint8_t *a0, uint16_t __reg("rb") a1, __reg("rc") uint16_t a2, uint16_t __reg("rd") a3);

uint16_t getpid();
uint16_t getppid();
uint16_t fork();

#define O_RDONLY 1 /* read only mode */
#define O_WRONLY 2 /* write only mode */
#define O_RDWR 3   /* read and write mode */
#define O_APPEND 4 /* start at end of file for writing */
#define O_CREAT 8  /* create file if it doesn't exist (don't do anything if it already does) */
#define O_TRUNC 16 /* truncate file to length 0 */
#define O_EXCL 32  /* fail if O_CREAT is set and file already exists */
uint16_t open(__reg("ra") char * name, __reg("rb") uint16_t flags);

uint16_t read_nb(__reg("ra") uint16_t fd, __reg("rb") uint8_t * buf, __reg("rc") uint16_t bytes, __reg("rd") uint8_t * eof);

uint16_t write_nb(__reg("ra") uint16_t fd, __reg("rb") uint8_t * buf, __reg("rc") uint16_t bytes, __reg("rd") uint8_t * eof);

uint16_t read(uint16_t fd, uint8_t * buffer, uint16_t bytes);

uint16_t write(uint16_t fd, uint8_t * buffer, uint16_t bytes);

uint16_t dup(__reg("ra") uint16_t fd);

uint16_t dup2(__reg("ra") uint16_t old, __reg("rb") uint16_t new);

uint16_t close(__reg("ra") uint16_t fd);

uint16_t creat(__reg("ra") uint8_t *name);

uint16_t yield();

uint16_t execv(__reg("ra") uint8_t *path, __reg("rb") uint8_t **argv);

uint16_t chdir(__reg("ra") uint8_t *path);

uint16_t chroot(__reg("ra") uint8_t *path);

uint16_t exit(__reg("ra") uint8_t return_value);

uint16_t wait_nb(uint8_t *ret_val);

uint16_t wait(__reg("ra") uint8_t *ret_val);

uint16_t link(__reg("ra") uint8_t *old_path, __reg("rb") uint8_t *new_path);

uint16_t unlink(__reg("ra") uint8_t *path);

uint16_t mkdir(__reg("ra") uint8_t *path);

uint16_t rmdir(__reg("ra") uint8_t *path);

/* directory entry structure */
struct dirent {
    /* inode number of file */
    uint16_t inum;
    /* file name (including null) */
    uint8_t name[14];
};

uint16_t readdir(uint16_t fd, struct dirent * dirp);
