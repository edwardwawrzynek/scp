; Asm implementation of standard library setjmp and longjmp

; ==== setjmp =====

; Save all current registers (except re), and save return address
; Pointer to buffer is in ra (function argument)

  .text
  .align
_setjmp:
  .global _setjmp

  st.r.p.off.w r0 ra 0
  st.r.p.off.w r1 ra 2
  st.r.p.off.w r2 ra 4
  st.r.p.off.w r3 ra 6
  st.r.p.off.w r4 ra 8
  st.r.p.off.w r5 ra 10
  st.r.p.off.w r6 ra 12
  st.r.p.off.w r7 ra 14
  st.r.p.off.w r8 ra 16
  st.r.p.off.w r9 ra 18
  st.r.p.off.w ra ra 20
  st.r.p.off.w rb ra 22
  st.r.p.off.w rc ra 24
  st.r.p.off.w rd ra 26
; no need to save re (function return), we will set it manually
; returning will add 2 to stack pointer
; copy it to re, add 2, store
  mov.r.r re rf
  alu.r.i add re 2
  st.r.p.off.w re ra 28

; save return address (on stack)
; first, load address into re
  ld.r.p.w re sp
; then save
  st.r.p.off.w re ra 30

; zero function return value and return
  ld.r.i re 0
  ret.n.sp sp

; ==== Longjmp ====
; buffer is in ra, return value in re
  .text
  .align
_longjmp:
  .global _longjmp
; first, check if value == 0, if so, make it one
; we are about to set it any way, so use r0 as scratch
  ld.r.i r0 0
  cmp.r.f r0 re
  jmp.c.j lgLG longjump_load
  ld.r.i re 1
longjump_load:
; load return address into r0
  ld.r.p.off.w r0 ra 30
; copy to ipc
  mov.r.ipc r0
; re is now set properly, so load regs
  ld.r.p.off.w r0 ra 0
  ld.r.p.off.w r1 ra 2
  ld.r.p.off.w r2 ra 4
  ld.r.p.off.w r3 ra 6

  ld.r.p.off.w r4 ra 8
  ld.r.p.off.w r5 ra 10
  ld.r.p.off.w r6 ra 12
  ld.r.p.off.w r7 ra 14

  ld.r.p.off.w r8 ra 16
  ld.r.p.off.w r9 ra 18
; load ra at the end
  ld.r.p.off.w rb ra 22

  ld.r.p.off.w rc ra 24
  ld.r.p.off.w rd ra 26
; we don't load re
  ld.r.p.off.w rf ra 28

; load ra - after this, we don't have access to the buffer
  ld.r.p.off.w ra ra 20

; run reti.pc.n - we are already in usermode, so we just jump
  reti.ipc.n

; something went wrong

