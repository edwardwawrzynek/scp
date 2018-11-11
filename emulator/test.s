;   This is a test program
    alu.r.r bneg r1 r1
    alu.r.i add r2 #23
    mov.r.r r0 r2
start:
    ld.r.i r0 #345
    ld.r.mw r1 start