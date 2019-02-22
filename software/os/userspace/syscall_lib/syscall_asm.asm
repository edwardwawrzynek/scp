;   Assembly support for userspace to kernel syscalls
;   This file just implements the bare argument passing and int'ind to syscalls
;   The nessesary wrappers for blocking syscalls, etc., are in syscall_lib.c
;   syscall.h declares what regs args are loaded into, so no need to do that

    .text

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
