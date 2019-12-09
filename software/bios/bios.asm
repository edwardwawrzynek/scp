; SCP BIOS
; Basically, this just loads a boot image from disk and transfers control over to it
; This runs entirely in a rom, so no stack or memory writing is done

; We have to manually fill bios image with zeros so that it is positioned at end of memory

  .text
  .align
_START:
  .global _START
; ---- clear regs -----
  ld.r.i r0 0
  ld.r.i r1 0
  ld.r.i r2 0
  ld.r.i r3 0
  ld.r.i r4 0
  ld.r.i r5 0
  ld.r.i r6 0
  ld.r.i r7 0
  ld.r.i r8 0
  ld.r.i r9 0
  ld.r.i ra 0
  ld.r.i rb 0
  ld.r.i rc 0
  ld.r.i rd 0
  ld.r.i re 0
  ld.r.i rf 0
; ---- clear memory ----
  ld.r.i r1 65024
lmemclear:
  st.r.p.b rf r0
  alu.r.i add r0 1
  cmp.r.f r0 r1
  jmp.c.j l lmemclear
; ---- clear screen ----
lbootclearscrn:
  out.r.p r0 5
  out.r.p r1 6
  alu.r.i add r0 1
  cmp.r.f r0 r1
  jmp.c.j GLgl lbootclearscrn
; ---- print bootloader message ----
  ld.r.ra r0 lbootmsg
  ld.r.i r3 993
lbootmsgprint:
  ld.r.p.b r1 r0
  ld.r.i r2 0
  cmp.r.f r1 r2
  jmp.c.j e lbootmsgprint_end
  out.r.p r3 5
  out.r.p r1 6
  alu.r.i add r0 1
  alu.r.i add r3 1
  jmp.c.j LGlge lbootmsgprint
lbootmsgprint_end:
; ----- init disk hardware -----
  ld.r.i r0 0
  out.r.p r0 13
  ld.r.i r0 1
  out.r.p r0 13
ldiskreset_wait:
  in.r.p r0 13
  ld.r.i r1 0
  cmp.r.f r0 r1
  jmp.c.j GLgl ldiskreset_wait
; make sure we didn't get an error
  in.r.p r0 14
  ld.r.i r1 0
  cmp.r.f r0 r1

  ld.r.ra r0 ldiskerrormsg
  ld.r.i r1 1075
  jmp.c.j GLgl lerror_hang

; ---- load superblock -----
; wait for disk to not be busy
lsuperwait:
  in.r.p r0 13
  ld.r.i r1 0
  cmp.r.f r0 r1
  jmp.c.j GLgl lsuperwait
; set block addr
  ld.r.i r0 383
  out.r.p r0 14
; start read
  ld.r.i r0 1
  out.r.p r0 16
  ld.r.i r0 0
  out.r.p r0 16
; wait for disk to not be busy
lsuperwait1:
  in.r.p r0 13
  ld.r.i r1 0
  cmp.r.f r0 r1
  jmp.c.j GLgl lsuperwait1
; read until we get to the bootable byte (13th byte)
  ld.r.i r3 14
lsuperread:
  in.r.p r0 15
  ld.r.i r1 0
  out.r.p r1 15
  alu.r.i sub r3 1
  ld.r.i r1 0
  cmp.r.f r1 r3
  jmp.c.j GLgl lsuperread
; bootable byte is in r0, test it
  ld.r.i r1 0
  cmp.r.f r0 r1

  ld.r.ra r0 lnotbootablemsg
  ld.r.i r1 1072
  jmp.c.j e lerror_hang
; we know disk is bootable, so start loading so image from it
; register allocations:
; ra address in memory being written
; rb current block index
; r0-r3 temps

  ld.r.i ra 0
  ld.r.i rb 256

; wait for disk to not be busy
lreadimgwait:
  in.r.p r0 13
  ld.r.i r1 0
  cmp.r.f r0 r1
  jmp.c.j GLgl lreadimgwait
; set block addr
  out.r.p rb 14
; trigger read
  ld.r.i r0 1
  out.r.p r0 16
  ld.r.i r0 0
  out.r.p r0 16
; wait for read to be done
lreadimgwait1:
  in.r.p r0 13
  ld.r.i r1 0
  cmp.r.f r0 r1
  jmp.c.j GLgl lreadimgwait1
; read data from disk into memory
lreadloop:
; read byte
  in.r.p r0 15
; write to memory
  st.r.p.b r0 ra
  alu.r.i add ra 1
; inc disk hardware addr for next read
  ld.r.i r3 0
  out.r.p r3 15
; test if we hit end of buffer
  in.r.p r3 16
  ld.r.i r2 0
  cmp.r.f r2 r3
  jmp.c.j GLgl lreadloop
; we hit end of buffer, so inc buffer index and loop
  alu.r.i add rb 1
; check if we reached end of os image
  ld.r.i r0 383
  cmp.r.f rb r0
  jmp.c.j GLgl lreadimgwait
; ---- clear screen ----
lbootclearscrn1:
  out.r.p r7 5
  out.r.p r8 6
  alu.r.i add r7 1
  cmp.r.f r7 r8
  jmp.c.j GLgl lbootclearscrn1

; transfer control to os
  ld.r.i r0 0
  jmp.c.r GLgle r0

lhang:
  jmp.c.j GLgle lhang

; Print an error message and hang (pointer to msg is in r0, location on screen in r1)
  .text
  .align
lerror_hang:
  ld.r.p.b r2 r0
  ld.r.i r3 0
  cmp.r.f r2 r3
  jmp.c.j e lerror_hang_hang
  out.r.p r1 5
  out.r.p r2 6
  alu.r.i add r1 1
  alu.r.i add r0 1
  jmp.c.j GLgle lerror_hang
lerror_hang_hang:
  jmp.c.j GLgle lerror_hang_hang


; SCP Bootloader message (just used to show something is working)
  .rodata
  .align
lbootmsg:
  .dc.b 83 
  .dc.b 67 
  .dc.b 80 
  .dc.b 32 
  .dc.b 66 
  .dc.b 111 
  .dc.b 111 
  .dc.b 116 
  .dc.b 108 
  .dc.b 111 
  .dc.b 97 
  .dc.b 100 
  .dc.b 101 
  .dc.b 114
  .dc.b 0

; Disk error message
  .rodata
  .align
ldiskerrormsg:
  .dc.b 68 
  .dc.b 105 
  .dc.b 115 
  .dc.b 107 
  .dc.b 32 
  .dc.b 69 
  .dc.b 114 
  .dc.b 114 
  .dc.b 111 
  .dc.b 114
  .dc.b 0

; Disk not bootable message
  .rodata
  .align
lnotbootablemsg:
  .dc.b 68 
  .dc.b 105 
  .dc.b 115 
  .dc.b 107 
  .dc.b 32 
  .dc.b 78 
  .dc.b 111 
  .dc.b 116 
  .dc.b 32 
  .dc.b 66 
  .dc.b 111 
  .dc.b 111 
  .dc.b 116 
  .dc.b 97 
  .dc.b 98 
  .dc.b 108 
  .dc.b 101
  .dc.b 0
