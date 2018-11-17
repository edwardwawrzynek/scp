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

; wait for a byte
wait:
  in.r.p r2 #2
  ld.r.i r3 #0
  cmp.r.f r2 r3
  jmp.c.j e wait

  ret.n.sp sp

; load a byte into r1
load:
  in.r.p r1 #1
  out.r.p r0 #1

  ret.n.sp sp

main:
  call.j.sp sp wait
  call.j.sp sp load
  call.j.sp sp send
  jmp.c.j LGlge main