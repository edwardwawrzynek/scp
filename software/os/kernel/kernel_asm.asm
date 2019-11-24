; Load buffer pointed to by ra into bootloader block, and jump to it
  .text
  .align
_kernel_load_bootloader_block:
  .global _kernel_load_bootloader_block
; r0 is pointer to location in mem
  ld.r.i r0 65024
lbootload_write:
  ld.r.p.b r1 ra
  st.r.p.b r1 r0
  alu.r.i add r0 1
  alu.r.i add ra 1
  ld.r.i r2 0
  cmp.r.f r0 r2
  jmp.c.j lgLG lbootload_write
; bootloader is loaded, jump to it
  ld.r.i r0 65024
  jmp.c.r elgLG r0