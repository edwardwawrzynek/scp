;   Assembly support for userspace to kernel syscalls
;   This file just implements the bare argument passing and int'ind to syscalls
;   The nessesary wrappers for blocking syscalls, etc., are in syscall_lib.c
;   syscall.h declares what regs args are loaded into, so no need to do that

    .text

;   Yield CPU time for current time block
;   Called by wrappers when waiting on blocking file,
;   Or for others. This triggers the same int as the timer,
;   so the cpu thinks the proc used all its time
    .align
_yield:
    .global _yield
;   Int (same as timer)
    int.i.n r1
    ret.n.sp sp

;   Test Syscall
    .align
_test_syscall:
    .global _test_syscall
;   Load syscall number
    ld.r.i re 0
;   Int
    int.i.n r7
    ret.n.sp sp

;   getpid - return process id (non blocking)
    .align
_getpid:
    .global _getpid
;   Load syscall number
    ld.r.i re 1
;   Int
    int.i.n r7
    ret.n.sp sp

;   getppid - return parent process id (non blocking)
    .align
_getppid:
    .global _getppid
;   Load syscall number
    ld.r.i re 2
;   Int
    int.i.n r7
    ret.n.sp sp

;   fork - create child proccess (non blocking)
    .align
_fork:
    .global _fork
;   Load syscall number
    ld.r.i re 3
;   Int
    int.i.n r7
    ret.n.sp sp

;   open - oepn/create a file (non blocking)
    .align
_open:
    .global _open
;   Load syscall number
    ld.r.i re 4
;   Int
    int.i.n r7
    ret.n.sp sp

;   read_nb - read from a file (needs blocking wrapper)
    .align
_read_nb:
    .global _read_nb
;   Load syscall number
    ld.r.i re 5
;   Int
    int.i.n r7
    ret.n.sp sp

;   write_nb - write to a file (needs blocking wrapper)
    .align
_write_nb:
    .global _write_nb
;   Load syscall number
    ld.r.i re 6
;   Int
    int.i.n r7
    ret.n.sp sp

;   close - close a file (non blocking)
    .align
_close:
    .global _close
;   Load syscall number
    ld.r.i re 7
;   Int
    int.i.n r7
    ret.n.sp sp

;   dup - duplicate fd (non blocking)
    .align
_dup:
    .global _dup
;   Load syscall number
    ld.r.i re 8
;   Int
    int.i.n r7
    ret.n.sp sp

;   dup2 - duplicate fd (non blocking)
    .align
_dup2:
    .global _dup2
;   Load syscall number
    ld.r.i re 9
;   Int
    int.i.n r7
    ret.n.sp sp

;   creat - create file (non blocking)
    .align
_creat:
    .global _creat
;   Load syscall number
    ld.r.i re 10
;   Int
    int.i.n r7
    ret.n.sp sp

;   execv - replace proc (non blocking)
    .align
_execv:
    .global _execv
;   Load syscall number
    ld.r.i re 11
;   Int
    int.i.n r7
    ret.n.sp sp

;   chdir - change current dir (non blocking)
    .align
_chdir:
    .global _chdir
;   Load syscall number
    ld.r.i re 12
;   Int
    int.i.n r7
    ret.n.sp sp

;   chroot - change current root dir (non blocking)
    .align
_chroot:
    .global _chroot
;   Load syscall number
    ld.r.i re 13
;   Int
    int.i.n r7
    ret.n.sp sp

;   exit - exit from a proc (non blocking)
    .align
_exit:
    .global _exit
;   Load syscall number
    ld.r.i re 14
;   Int
    int.i.n r7
    ret.n.sp sp

;   wait - wait for a child to die (needs blocking wrapper)
    .align
_wait_nb:
    .global _wait_nb
;   Load syscall number
    ld.r.i re 15
;   Int
    int.i.n r7
    ret.n.sp sp

;   link - create new link to file (nonblocking)
    .align
_link:
    .global _link
;   Load syscall number
    ld.r.i re 16
;   Int
    int.i.n r7
    ret.n.sp sp

;   unlink - remove a file (nonblocking)
    .align
_unlink:
    .global _unlink
;   Load syscall number
    ld.r.i re 17
;   Int
    int.i.n r7
    ret.n.sp sp

;   mkdir - make a directory (nonblocking)
    .align
_mkdir:
    .global _mkdir
;   Load syscall number
    ld.r.i re 18
;   Int
    int.i.n r7
    ret.n.sp sp

;   rmdir - remove a directory (nonblocking)
    .align
_rmdir:
    .global _rmdir
;   Load syscall number
    ld.r.i re 19
;   Int
    int.i.n r7
    ret.n.sp sp

;   lseek - seek to a position in a file (nonblocking)
    .align
_lseek:
    .global _lseek
;   Load syscall number
    ld.r.i re 20
;   Int
    int.i.n r7
    ret.n.sp sp

;   ioctl - set io params on dev file (nonblocking)
    .align
_ioctl:
    .global _ioctl
;   Load syscall number
    ld.r.i re 21
;   Int
    int.i.n r7
    ret.n.sp sp

;   stat - get info on file (nonblocking)
    .align
_stat:
    .global _stat
;   Load syscall number
    ld.r.i re 22
;   Int
    int.i.n r7
    ret.n.sp sp

;   fstat - get info on file (nonblocking)
    .align
_fstat:
    .global _fstat
;   Load syscall number
    ld.r.i re 23
;   Int
    int.i.n r7
    ret.n.sp sp

;   chmod - change permissions on file (nonblocking)
    .align
_chmod:
    .global _chmod
;   Load syscall number
    ld.r.i re 24
;   Int
    int.i.n r7
    ret.n.sp sp

;   fchmod - change permissions on file (nonblocking)
    .align
_fchmod:
    .global _fchmod
;   Load syscall number
    ld.r.i re 25
;   Int
    int.i.n r7
    ret.n.sp sp

;   mknod - make regular, dev, or named pipe (nonblocking)
    .align
_mknod:
    .global _mknod
;   Load syscall number
    ld.r.i re 26
;   Int
    int.i.n r7
    ret.n.sp sp