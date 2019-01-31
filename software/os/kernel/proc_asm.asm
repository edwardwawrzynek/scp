;   Asm support for the proc.c file
;   Provides the lowest level routines needed to handle the condition code
;   register, and to setup the env to run a process

;   Given all needed variables (see proc.c) loaded into proc_begin_execute
;   vars, and the ptb already set, setup the cpu state and run the process
;   This is called in sys priv_lv(0) from the kernel, and ends in the
;   process in sys usr priv_lv(1)

    .text
    .align
_proc_finish_execute:
    .global _proc_finish_execute
;   Do cmp
    ld.r.m.w r0 _proc_begin_execute_cmp1
    ld.r.m.w r1 _proc_begin_execute_cmp2
    cmp.r.f r0 r1

;   Load pc into ipc reg
    ld.r.m.w r0 _proc_begin_execute_pc_reg
    mov.r.ipc r0

;   Load regs
    ld.r.m.w r0 _proc_begin_execute_regs+0
    ld.r.m.w r1 _proc_begin_execute_regs+2
    ld.r.m.w r2 _proc_begin_execute_regs+4
    ld.r.m.w r3 _proc_begin_execute_regs+6
    ld.r.m.w r4 _proc_begin_execute_regs+8
    ld.r.m.w r5 _proc_begin_execute_regs+10
    ld.r.m.w r6 _proc_begin_execute_regs+12
    ld.r.m.w r7 _proc_begin_execute_regs+14
    ld.r.m.w r8 _proc_begin_execute_regs+16
    ld.r.m.w r9 _proc_begin_execute_regs+18
    ld.r.m.w ra _proc_begin_execute_regs+20
    ld.r.m.w rb _proc_begin_execute_regs+22
    ld.r.m.w rc _proc_begin_execute_regs+24
    ld.r.m.w rd _proc_begin_execute_regs+26
    ld.r.m.w re _proc_begin_execute_regs+28
    ld.r.m.w rf _proc_begin_execute_regs+30

;   Go to proc
    reti.ipc.n
;   Flow won't reach here - if it does, we have lost the stack pointer anyway, so jump to panic
    jmp.c.j elgLG _panic

    .extern _panic




;   External variables from proc.c
    .extern _proc_begin_execute_regs
    .extern _proc_begin_execute_pc_reg
    .extern _proc_begin_execute_cmp1
    .extern _proc_begin_execute_cmp2
