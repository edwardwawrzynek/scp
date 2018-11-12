;   This is a test program
    ld.r.mw r0 start

    ld.r.i r1 #6547
    ld.r.ra r2 start

    ld.r.i r3 #2
    alu.r.r sub r2 r3

    st.r.pw.off r1 r2 #2

    ld.r.mw r0 start

    .ds #100

start:
    .dw #345