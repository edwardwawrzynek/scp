  .text
  .align
_START:
  .global _START
  .extern _main
  call.j.sp sp _main
  out.r.p re 0
lhang:
  jmp.c.j LGlge lhang

; put char c(rc) on screen at position x(ra), y(rb)
  .text
  .align
_put_char:
  .global _put_char
  alu.r.i mul rb 80
  alu.r.r add ra rb
  out.r.p ra 5
  out.r.p rc 6
  ret.n.sp sp