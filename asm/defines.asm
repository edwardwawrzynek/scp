	.text
	.align
_expand_defs:
	.global	_expand_defs
	push.r.sp r0 sp
	ld.r.m.w ra _defs+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l4
l3:
	ld.r.i ra 4224
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	st.r.m.w re _defs+0
	ld.r.i ra 64
	st.r.m.w ra _defs_allocd+0
	jmp.c.j LGlge l5
l4:
	ld.r.m.w ra _defs_allocd+0
	alu.r.i add ra 64
	st.r.m.w ra _defs_allocd+0
	ld.r.m.w r0 _defs_allocd+0
	alu.r.i mul r0 66
	push.r.sp r0 sp
	ld.r.m.w ra _defs+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re _defs+0
l5:
l1:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_add_def:
	.global	_add_def
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.m.w ra _defs_cur+0
	ld.r.m.w rc _defs_allocd+0
	cmp.r.f ra rc
	jmp.c.j l l9
l8:
	call.j.sp sp _expand_defs
l9:
	ld.r.m.w r0 _defs_cur+0
	ld.r.m.w ra _defs_cur+0
	alu.r.i add ra 1
	st.r.m.w ra _defs_cur+0
	alu.r.i mul r0 66
	ld.r.m.w r1 _defs+0
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
	mov.r.r re r2
l6:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_find_def:
	.global	_find_def
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 0
	jmp.c.j LGlge l13
l12:
	mov.r.r r0 r2
	alu.r.i mul r0 66
	ld.r.m.w r1 _defs+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l17
l16:
	mov.r.r r0 r2
	alu.r.i mul r0 66
	ld.r.m.w r1 _defs+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l10
l17:
l15:
	alu.r.i add r2 1
l13:
	ld.r.m.w rc _defs_cur+0
	cmp.r.f r2 rc
	jmp.c.j l l12
l14:
	ld.r.i re 0
l10:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
	.align
_defs_allocd:
	.global	_defs_allocd
	.align
	.dc.w	0

	.data
	.align
_defs_cur:
	.global	_defs_cur
	.align
	.dc.w	0

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
_defs:
	.global	_defs
	.align
	.ds	2
;	End of VBCC generated section
	.module

