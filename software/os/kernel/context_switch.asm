;   Asm support for the lowest levels of context switches
;   Provides the lowest level routines needed to handle the condition code
;   register, and to setup the env to run a process

;   External Variables from context_vars.c used
    .extern _context_switch_regs
    .extern _context_switch_pc_reg
    .extern _context_switch_cond_reg
    .extern _context_switch_cmp1
    .extern _context_switch_cmp2

;   Extern functions used from proc.c
    .extern _proc_finish_return

;   **************** context_switch_run_state ****************
;   Given the needed state loaded into _context_switch vars,
;   Setup the cpu state and run

    .text
    .align
_context_switch_run_state:
    .global _context_switch_run_state
;   Do cmp
    ld.r.m.w r0 _context_switch_cmp1
    ld.r.m.w r1 _context_switch_cmp2
    cmp.r.f r0 r1

;   Load pc into ipc reg
    ld.r.m.w r0 _context_switch_pc_reg
    mov.r.ipc r0

;   Load regs
    ld.r.m.w r0 _context_switch_regs+0
    ld.r.m.w r1 _context_switch_regs+2
    ld.r.m.w r2 _context_switch_regs+4
    ld.r.m.w r3 _context_switch_regs+6
    ld.r.m.w r4 _context_switch_regs+8
    ld.r.m.w r5 _context_switch_regs+10
    ld.r.m.w r6 _context_switch_regs+12
    ld.r.m.w r7 _context_switch_regs+14
    ld.r.m.w r8 _context_switch_regs+16
    ld.r.m.w r9 _context_switch_regs+18
    ld.r.m.w ra _context_switch_regs+20
    ld.r.m.w rb _context_switch_regs+22
    ld.r.m.w rc _context_switch_regs+24
    ld.r.m.w rd _context_switch_regs+26
    ld.r.m.w re _context_switch_regs+28
    ld.r.m.w rf _context_switch_regs+30

;   Go to proc
    reti.ipc.n
;   Flow won't reach here - if it does, we have lost the stack pointer anyway, so jump to panic
    jmp.c.j elgLG _panic

    .extern _panic

;   **************** context_switch_get_cond_reg ****************
;   Return the state of the cond code reg

_context_switch_get_cond_reg:
    .global _context_switch_get_cond_reg
;   Load 0 into return reg
    ld.r.i re 0
;   Go through each bit in the cond reg, check it,
;   and set it in re if it is set in cond reg

;   bit 0 - equal (e)
    jmp.c.j e lset_e
    jmp.c.j elgLG lclear_e

lset_e:
    alu.r.i bor re 1
lclear_e:

;   bit 1 - less than (l)
    jmp.c.j l lset_l
    jmp.c.j elgLG lclear_l

lset_l:
    alu.r.i bor re 2
lclear_l:

;   bit 2 - greater than (g)
    jmp.c.j g lset_g
    jmp.c.j elgLG lclear_g

lset_g:
    alu.r.i bor re 4
lclear_g:

;   bit 3 - less than (L)
    jmp.c.j L lset_L
    jmp.c.j elgLG lclear_L

lset_L:
    alu.r.i bor re 8
lclear_L:

;   bit 5 - greater than (G)
    jmp.c.j G lset_G
    jmp.c.j elgLG lclear_G

lset_G:
    alu.r.i bor re 16
lclear_G:

    ret.n.sp sp

;   **************** context_switch_save_proc_state ****************
;   Having just interrupted from a proc, save its state in context_switch
;   variables (sets cond_reg, not cmp1 and cmp2 - proc.c does that)
;   This is used as int_handler_1, and is jumped to by int vector 1
;   It calls proc_finish_return, which will finalize things and shedule
;   Shouldn't be called directly - should only be called as a int handler

    .text
    .align
_context_switch_save_proc_state:
    .global _context_switch_save_proc_state
_int_handler_1:
    .global _int_handler_1

;   Save reg state
    st.r.m.w r0 _context_switch_regs+0
    st.r.m.w r1 _context_switch_regs+2
    st.r.m.w r2 _context_switch_regs+4
    st.r.m.w r3 _context_switch_regs+6
    st.r.m.w r4 _context_switch_regs+8
    st.r.m.w r5 _context_switch_regs+10
    st.r.m.w r6 _context_switch_regs+12
    st.r.m.w r7 _context_switch_regs+14
    st.r.m.w r8 _context_switch_regs+16
    st.r.m.w r9 _context_switch_regs+18
    st.r.m.w ra _context_switch_regs+20
    st.r.m.w rb _context_switch_regs+22
    st.r.m.w rc _context_switch_regs+24
    st.r.m.w rd _context_switch_regs+26
    st.r.m.w re _context_switch_regs+28
    st.r.m.w rf _context_switch_regs+30

;   Save ipc reg
    mov.ipc.r r0
    st.r.m.w r0 _context_switch_pc_reg

;   Setup sp for function calls
    ld.r.i sp 0

;   Load cond reg
    call.j.sp sp _context_switch_get_cond_reg
    st.r.m.b re _context_switch_cond_reg

    call.j.sp sp _proc_finish_return