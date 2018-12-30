	.text
_set:
	.global	_set
	ld.r.p.off.w r4 sp 2
	ld.r.i ra 19
	st.r.p.w ra r4
l1:
	ret.n.sp sp
	.text
_main:
	.global	_main
	push.r.sp r0 sp
	alu.r.i sub sp 2
	ld.r.i ra 5
	st.r.p.w ra sp
	mov.r.r r0 sp
	push.r.sp r0 sp
	call.j.sp sp _set
	alu.r.i add sp 2
	ld.r.p.w re sp
l3:
	alu.r.i add sp 2
	pop.r.sp r0 sp
	ret.n.sp sp
;	End of VBCC generated section
	.module

