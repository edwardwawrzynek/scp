; screen fill demo
; fill each pixel with an increasing color
  ld.r.i r0 #0
  ld.r.i r1 #0
loop:
  ; Write out
  out.r.p r0 #9
  out.r.p r1 #10
  alu.r.i add r0 #1
  alu.r.i add r1 #1
  jmp.c.j lgeLG loop