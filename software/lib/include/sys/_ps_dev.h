#ifndef __PS_DEV_INCL
#define __PS_DEV_INCL

#include <unistd.h>

/* max length of command string */
#define ps_proc_cmd_max_len 128

/* proccess states */
enum ps_proc_state {RUNNING, INIT, DEAD, KERNEL};

/* structure passed to userspace that contains process information */
struct ps_proc_info {
  pid_t pid;                /* process id */
  pid_t parent;             /* parent process id */
  uint8_t mem_data_pages;   /* number data pages */
  uint8_t mem_text_pages;   /* number text pages */
  uint8_t mem_stack_pages;  /* number stack pages */
  uint8_t mem_total_pages;  /* total pages in use */

  enum ps_proc_state state; /* current process state */

  uint16_t cwd_inum;        /* current working directory (inode index) */
  uint16_t croot_inum;      /* current root directory (inode index) */

  uint8_t cmd[ps_proc_cmd_max_len]; /* command used to invoke the program */
};

#endif