;   Defines the end of the space used by the os binary
;   kmalloc uses the address of _BRK_END to know where to begin memory allocation

;   place in the data segment, as that comes after text
    .data
    .align
__BRK_END:
    .global __BRK_END