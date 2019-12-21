	.text
	.align
_do_char:
	.global	_do_char
	push.r.sp r0 sp
	push.r.sp r1 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r1 sp 14
	ld.r.p.off.w r0 sp 12
	st.r.p.w rc sp
	mov.r.r rc r1
	st.r.p.off.w rb sp 2
	ld.r.i rb 0
	st.r.p.off.w ra sp 4
	mov.r.r ra r0
	call.j.sp sp _put_char
	ld.r.p.off.w ra sp 4
	ld.r.p.off.w rb sp 2
	ld.r.p.w rc sp
	ld.r.i rc 79
	cmp.r.f r0 rc
	jmp.c.j Ge l4
l3:
	push.r.sp r1 sp
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _do_char
	alu.r.i add sp 4
l4:
l1:
	alu.r.i add sp 6
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	alu.r.i sub sp 2
	ld.r.ra r0 _do_char+0
	ld.r.i ra 65
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r ra r0
	call.r.sp ra sp
	alu.r.i add sp 4
l5:
	alu.r.i add sp 2
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.align
	.extern	_put_char
;	End of VBCC generated section
	.module

