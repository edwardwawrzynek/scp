;   Assembly support routines for mmu.c
;   Mostly very simple warppers around machine-level mmu instructions

;   Set the ptb to the value in the ra reg
;   Returns: None

    .text
    .align
_mmu_set_ptb:
    .global _mmu_set_ptb

    ptb.r.n ra

    ret.n.sp sp

;   Set the mmu entry with the index in the ra reg to the value in the rc reg
;   Returns: None

    .text
    .align
_mmu_set_page:
    .global _mmu_set_page

;   Set ptb to ra
    ptb.r.n ra
;   Load 0 into rb, and use it as offset in table (ptb can acess any entry itself)
    ld.r.i rb 0
;   Write out
    mmu.r.r rb rc

    ret.n.sp sp
