	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	ld.r.p.off.w r1 sp 10
	ld.r.ra ra l6+0
	push.r.sp ra sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j e l17
l15:
	ld.r.ra ra l7+0
	push.r.sp ra sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l15
l17:
	ld.r.m.w ra _optind+0
	cmp.r.f ra r2
	jmp.c.j Ge l18
l16:
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	call.j.sp sp _mkdir
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l13
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l14+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _perror
	alu.r.i add sp 2
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
l13:
	ld.r.m.w r0 _optind+0
	alu.r.i add r0 1
	st.r.m.w r0 _optind+0
	cmp.r.f r0 r2
	jmp.c.j L l16
l18:
	ld.r.m.b r0 _did_error+0
	mov.r.r re r0
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l14:
	.dc.bs	109
	.dc.bs	107
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	110
	.dc.bs	111
	.dc.bs	116
	.dc.bs	32
	.dc.bs	99
	.dc.bs	114
	.dc.bs	101
	.dc.bs	97
	.dc.bs	116
	.dc.bs	101
	.dc.bs	32
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	111
	.dc.bs	114
	.dc.bs	121
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	0

	.rodata
l6:
	.dc.bs	0

	.rodata
l7:
	.dc.bs	0

	.data
_did_error:
	.global	_did_error
	.dc.bs	0

	.bss
	.extern	_mkdir

	.bss
	.extern	_optind

	.bss
	.extern	_getopt

	.bss
	.extern	_stderr

	.bss
	.extern	_perror

	.bss
	.extern	_fprintf
;	End of VBCC generated section
	.module

