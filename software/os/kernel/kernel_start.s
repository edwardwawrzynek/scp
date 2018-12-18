; Start the kernel, and set interupt locations
; This is the first thing in the kernel binary
; Start by calling main
  call  main
; Now fill up the addr space till 0x10, where interupts start
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .db #0
; Interupt addrs, each four bytes apart
; Very important that these jump to the handlers and not call, else they would change the sp
  jmp   _int0_handler
  .db #0
  jmp   _int1_handler
  .db #0
  jmp   _int2_handler
  .db #0
  jmp   _int3_handler
  .db #0
  jmp   _int4_handler
  .db #0
  jmp   _int5_handler
  .db #0
; Done