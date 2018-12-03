;   Test file
    .text
    ld.r.p.off.w    r0 r1 34
_main:
    .global         _main
    ld.r.i          r1 345+1
    ld.r.m.w        r0 _main+2
_call:
    call.j.sp       sp _func

    .module
;   Data segement
    .data
_var:
    .global         _var
    .ds             11
    .align
    .dc.b   123


;   More code
    .text
    nop.n.n
    ld.r.m.w        r0 _var

;   Some external function
    .extern _func
    .extern _func2