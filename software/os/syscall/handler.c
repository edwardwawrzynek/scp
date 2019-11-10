#include "include/defs.h"

#include "kernel/proc.h"
#include "kernel/context_vars.h"
#include "kernel/shed.h"

#include "syscall/getpid.h"
#include "syscall/fork.h"
#include "syscall/files.h"
#include "syscall/exec.h"
#include "syscall/chdir.h"
#include "syscall/exit.h"
#include "syscall/dir.h"
#include "syscall/brk.h"

/* syscall table (all syscalls take four args, regardless of if they use them or not *) */
uint16_t (*syscalls[])(uint16_t, uint16_t, uint16_t, uint16_t) = {
    NULL,
    _getpid,
    _getppid,
    _fork,
    _open,
    _read_nb,
    _write_nb,
    _close,
    _dup,
    _dup2,
    _creat,
    _execv,
    _chdir,
    _chroot,
    _exit,
    _wait_nb,
    _link,
    _unlink,
    _mkdir,
    _rmdir,
    _lseek,
    _ioctl,
    _stat,
    _fstat,
    _chmod,
    _fchmod,
    _mknod,
    _pipe,
    _brk,
    _sbrk,
    _fchdir,
};

/* Passed Args and syscall number */
static uint16_t arg0, arg1, arg2, arg3;
static uint16_t syscall_num;

void syscall_handler_run(){
    /* save cpu status */
    proc_set_cpu_state(proc_current_proc, context_switch_regs, context_switch_pc_reg, context_switch_cond_reg);
    /* set syscall args */
    arg0 = context_switch_regs[0xa];
    arg1 = context_switch_regs[0xb];
    arg2 = context_switch_regs[0xc];
    arg3 = context_switch_regs[0xd];
    syscall_num = context_switch_regs[0xe];
    /* call syscall */
    uint16_t result = syscalls[syscall_num](arg0, arg1, arg2, arg3);

    /* set return reg in proc */
    context_switch_regs[0xe] = result;
    proc_set_cpu_state(proc_current_proc, context_switch_regs, context_switch_pc_reg, context_switch_cond_reg);

    /* shedule */
    shed_shedule();
}