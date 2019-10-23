	.text
	.align
_reset_segs_and_module:
	.global	_reset_segs_and_module
	ld.r.i ra 0
	st.r.m.w ra _seg_pos+0
	ld.r.i ra 0
	st.r.m.w ra _seg_pos+2
	ld.r.i ra 0
	st.r.m.w ra _seg_pos+4
	ld.r.i ra 0
	st.r.m.w ra _seg_pos+6
	ld.r.i ra 0
	st.r.m.b ra _cur_seg+0
	ld.r.i ra 0
	st.r.m.w ra _cur_module+0
l1:
	ret.n.sp sp
	.text
	.align
_expand_labels:
	.global	_expand_labels
	push.r.sp r0 sp
	ld.r.m.w ra _labels+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l6
l5:
	ld.r.i ra 4736
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	st.r.m.w re _labels+0
	ld.r.i ra 64
	st.r.m.w ra _labels_allocd+0
	jmp.c.j LGlge l7
l6:
	ld.r.m.w ra _labels_allocd+0
	alu.r.i add ra 64
	st.r.m.w ra _labels_allocd+0
	ld.r.m.w r0 _labels_allocd+0
	alu.r.i mul r0 74
	push.r.sp r0 sp
	ld.r.m.w ra _labels+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re _labels+0
l7:
l3:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_add_label:
	.global	_add_label
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.m.w ra _labels_cur+0
	ld.r.m.w rc _labels_allocd+0
	cmp.r.f ra rc
	jmp.c.j l l11
l10:
	call.j.sp sp _expand_labels
l11:
	ld.r.m.w r0 _labels_cur+0
	ld.r.m.w ra _labels_cur+0
	alu.r.i add ra 1
	st.r.m.w ra _labels_cur+0
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	mov.r.r r2 r1
	push.r.sp r3 sp
	push.r.sp r2 sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r0 r2
	alu.r.i add r0 64
	ld.r.p.off.w ra sp 14
	st.r.p.w ra r0
	mov.r.r r0 r2
	alu.r.i add r0 68
	ld.r.p.off.w ra sp 16
	st.r.p.w ra r0
	mov.r.r r0 r2
	alu.r.i add r0 66
	ld.r.p.off.bs ra sp 18
	st.r.p.bs ra r0
	mov.r.r r0 r2
	alu.r.i add r0 72
	ld.r.i ra 1
	st.r.p.b ra r0
	mov.r.r re r2
l8:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_find_label:
	.global	_find_label
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 0
	jmp.c.j LGlge l15
l14:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 72
	mov.r.r ra r1
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l19
l18:
	jmp.c.j LGlge l17
l19:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l21
l20:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 64
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.p.off.w rc sp 14
	cmp.r.f ra rc
	jmp.c.j e l22
l24:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 64
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l23
l22:
	ld.r.p.off.b ra sp 16
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l25
l27:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 66
	ld.r.p.bs r1 r1
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j e l26
l25:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l12
l26:
l23:
l21:
l17:
	alu.r.i add r2 1
l15:
	ld.r.m.w rc _labels_cur+0
	cmp.r.f r2 rc
	jmp.c.j l l14
l16:
	ld.r.ra ra l28+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
	ld.r.i re 0
l12:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l28:
	.dc.bs	110
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	108
	.dc.bs	97
	.dc.bs	98
	.dc.bs	101
	.dc.bs	108
	.dc.bs	0
	.text
	.align
_labels_get_num:
	.global	_labels_get_num
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r7 sp 14
	ld.r.p.off.w r6 sp 12
	ld.r.i r5 0
	ld.r.i r4 0
	jmp.c.j LGlge l32
l31:
	mov.r.r r0 r4
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 72
	mov.r.r ra r1
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l36
l35:
	jmp.c.j LGlge l34
l36:
	mov.r.r r0 r4
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 66
	ld.r.p.bs r1 r1
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j GLgl l38
l37:
	mov.r.r ra r7
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r7
	mov.r.r r0 r5
	alu.r.i add r5 1
	mov.r.r r1 r4
	alu.r.i mul r1 74
	ld.r.m.w r2 _labels+0
	alu.r.r add r2 r1
	alu.r.i add r2 70
	st.r.p.w r0 r2
	jmp.c.j LGlge l39
l38:
	mov.r.r r0 r4
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 64
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l41
l40:
	mov.r.r ra r6
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r6
l41:
l39:
l34:
	alu.r.i add r4 1
l32:
	ld.r.m.w rc _labels_cur+0
	cmp.r.f r4 rc
	jmp.c.j l l31
l33:
l29:
	alu.r.i add sp 4
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_labels_write_out:
	.global	_labels_write_out
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 0
	jmp.c.j LGlge l45
l44:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 72
	mov.r.r ra r1
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l49
l48:
	jmp.c.j LGlge l47
l49:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 66
	ld.r.p.bs r1 r1
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j GLgl l51
l50:
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp _obj_write_extern
	alu.r.i add sp 6
	mov.r.r r0 re
	jmp.c.j LGlge l52
l51:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 64
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l54
l53:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 68
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 66
	ld.r.p.bs r1 r1
	push.r.sp r1 sp
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp _obj_write_defined
	alu.r.i add sp 8
l54:
l52:
l47:
	alu.r.i add r2 1
l45:
	ld.r.m.w rc _labels_cur+0
	cmp.r.f r2 rc
	jmp.c.j l l44
l46:
l42:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_remove_defined_externs:
	.global	_remove_defined_externs
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	jmp.c.j LGlge l58
l57:
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 66
	ld.r.p.bs r1 r1
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j GLgl l62
l61:
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 64
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	call.j.sp sp _find_label
	alu.r.i add sp 6
	mov.r.r r3 re
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j e l64
	mov.r.r r0 r2
	alu.r.i mul r0 74
	ld.r.m.w r1 _labels+0
	alu.r.r add r1 r0
	alu.r.i add r1 72
	ld.r.i ra 0
	st.r.p.b ra r1
l64:
l62:
l60:
	alu.r.i add r2 1
l58:
	ld.r.m.w rc _labels_cur+0
	cmp.r.f r2 rc
	jmp.c.j l l57
l59:
l55:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
	.align
_labels_allocd:
	.global	_labels_allocd
	.align
	.dc.w	0

	.data
	.align
_labels_cur:
	.global	_labels_cur
	.align
	.dc.w	0

	.data
	.align
_cur_seg:
	.global	_cur_seg
	.dc.bs	0

	.data
	.align
_cur_module:
	.global	_cur_module
	.align
	.dc.w	0

	.bss
	.align
	.extern	_error

	.bss
	.align
	.extern	_strcmp

	.bss
	.align
	.extern	_strcpy

	.bss
	.align
	.extern	_realloc

	.bss
	.align
	.extern	_malloc

	.bss
	.align
	.extern	_obj_write_extern

	.bss
	.align
	.extern	_obj_write_defined

	.bss
	.align
_labels:
	.global	_labels
	.align
	.ds	2

	.bss
	.align
_seg_pos:
	.global	_seg_pos
	.align
	.ds	8
;	End of VBCC generated section
	.module

