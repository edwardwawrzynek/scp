;   Test 1
    .text
_main:
    .global _main
    ld.r.m.w r0 _var2

    .extern _var2
    .data

_var1:
    .global _var1
    .dc.w   342