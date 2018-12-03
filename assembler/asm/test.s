;   Test file
    .text
    ld.r.p.off.w    r0 r1 34
_main:
    .global         _main
    ld.r.i          r1 345+1
    ld.r.m.w        r0 _main+2
    call.j.sp       sp _func

;   Data segement
    .data
_var:
    .ds             12

;   More code
    .text
    nop.n.n
    ld.r.m.w        r0 _var
;   Some external function
    .extern _func