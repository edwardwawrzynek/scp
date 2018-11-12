; Main section
  ld.r.i r0 #123

; Push arg
  ld.r.i r1 #2
  push.r.sp r1 rf
  call.j.sp rf func
  pop.r.sp r1 rf

; Signal End
  ld.r.i r0 #65535
end:
  jmp.c.j elgLG end

  .ds #100
; Adds the passed value to r0
func:
  ;Load arg
  ld.r.pw.off r3 rf #2
  alu.r.r add r0 r3

; If greater than 150, return
  ld.r.i r1 #150
  cmp.r.f r0 r1
  jmp.c.j g return

  ld.r.i r1 #2
  push.r.sp r1 rf
  call.j.sp rf func
  pop.r.sp r1 rf

return:
  ret.n.sp rf