;	Function func
;	localsize: 2
	.text
_func:
	.global	_func
	alu.r.i sub sp 2
	push.r.sp ra sp
	push.r.sp rb sp
	push.r.sp rc sp
	push.r.sp rd sp
;	Begin function body
	ld.r.p.off.w ra sp 12
	ld.r.p.off.w rc sp 14
	alu.r.r add ra rc
	st.r.p.w ra sp
l2:
;	End function body
	pop.r.sp rd sp
	pop.r.sp rc sp
	pop.r.sp rb sp
	pop.r.sp ra sp
	ret.n.sp sp
;	End of function func
;	Function main
;	localsize: 0
	.text
_main3:
	.global	_main3
	push.r.sp ra sp
	push.r.sp rb sp
	push.r.sp rc sp
	push.r.sp rd sp
;	Begin function body
	ld.r.p.off.w r0 sp 10
	ld.r.p.w r0 r0
	mov.r.r ra r0
	call.r.sp ra sp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.m.w re _f+0
l3:
;	End function body
	pop.r.sp rd sp
	pop.r.sp rc sp
	pop.r.sp rb sp
	pop.r.sp ra sp
	ret.n.sp sp
;	End of function main
;	var: f
	.bss
	.extern	_f
;	var: a
	.data
l1:
	.align
	.dc.w	1
	.ds	8+2
;	End of VBCC SCP generated section