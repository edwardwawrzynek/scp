; Serial echo demo
  jmp.c.j LGlge main

; send - wait for tx to be done, and transmit the byte in r1
send:
  ; wait for tx_busy to go low
  in.r.p r2 #4
  ld.r.i r3 #0
  cmp.r.f r2 r3
  jmp.c.j g send
  ; send
  out.r.p r1 #3

  ret.n.sp sp

; wait for a key to be pressed
wait:
  in.r.p r2 #8
  ld.r.i r3 #0
  cmp.r.f r2 r3
  jmp.c.j e wait

  ret.n.sp sp

; load a byte into r1
load:
  in.r.p r1 #7
  out.r.p r0 #7

  ret.n.sp sp

main:
  call.j.sp sp wait
  call.j.sp sp load
; check that it isn't a release
  ld.r.i r2 #256
  alu.r.r band r2 r1
  cmp.r.f r2 r5
  jmp.c.j g main

  call.j.sp sp send
  jmp.c.j LGlge main