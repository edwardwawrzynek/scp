;   This is a test program
    .set_label start #8
    .module
    alu.r.r bneg r1 r1
    alu.r.i add r2 #23
    mov.r.r r0 r2
    ld.r.mw r1 start
    .db #123
    .align
    .dw #65535