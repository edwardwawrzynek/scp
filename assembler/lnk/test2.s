; Test 2
    .data
_var2:
    .global _var2
    .dc.w   54367

    .text
l1:
    call.j.sp sp _main
    nop.n.n

    .data
    .extern _main
