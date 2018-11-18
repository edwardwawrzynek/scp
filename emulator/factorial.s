main:
  ld.r.i r1 #8
  push.r.sp r1 rf
  call.j.sp rf factorial

end:
  jmp.c.j elgLG end

; Factorial - Recursive
;
; factorial(x){
; if(x <= 1){
;   return 1;
; }
; return factorial(x-1) * x;
; }
;

factorial:
  ; Load Arg
  ld.r.pw.off r0 rf #2

  ;Check for return
  ld.r.i r1 #1
  cmp.r.f r0 r1

  jmp.c.j g skip

  ld.r.i r0 #1
  ret.n.sp rf

skip:
  ;Copy r0 into r1
  mov.r.r r1 r0
  ;Dec r1
  alu.r.i sub r1 #1

  ;Call factorial on r1
  push.r.sp r1 rf
  call.j.sp rf factorial
  pop.r.sp re rf

  ; Load Arg
  ld.r.pw.off r1 rf #2

  ;Mult
  alu.r.r mul r0 r1

  ret.n.sp rf