	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 12
	ld.r.p.off.w r2 sp 10
	ld.r.i r1 0
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j Le l29
l26:
	mov.r.r r0 r1
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r3
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l7+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	alu.r.i add r1 1
	cmp.r.f r1 r2
	jmp.c.j L l26
l29:
	ld.r.ra ra l8+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	ld.r.ra ra l12+0
	push.r.sp ra sp
	push.r.sp r3 sp
	push.r.sp r2 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r4 re
	ld.r.i rc -1
	cmp.r.f r4 rc
	jmp.c.j e l30
l27:
	mov.r.r r0 r4
	ld.r.i rc 63
	cmp.r.f r4 rc
	jmp.c.j e l18
	ld.r.i rc 99
	cmp.r.f r0 rc
	jmp.c.j e l14
	ld.r.i rc 108
	cmp.r.f r0 rc
	jmp.c.j e l16
	jmp.c.j LGlge l13
l14:
	ld.r.m.w ra _optarg+0
	push.r.sp ra sp
	ld.r.ra ra l15+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	jmp.c.j LGlge l13
l16:
	ld.r.ra ra l17+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	jmp.c.j LGlge l13
l18:
	ld.r.ra ra l19+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
l13:
	ld.r.ra ra l20+0
	push.r.sp ra sp
	push.r.sp r3 sp
	push.r.sp r2 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r4 re
	ld.r.i rc -1
	cmp.r.f r4 rc
	jmp.c.j GLgl l27
l30:
	ld.r.m.w ra _optind+0
	cmp.r.f ra r2
	jmp.c.j Ge l31
l28:
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r3
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l25+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	ld.r.m.w r0 _optind+0
	alu.r.i add r0 1
	st.r.m.w r0 _optind+0
	cmp.r.f r0 r2
	jmp.c.j L l28
l31:
	ld.r.i re 0
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l7:
	.dc.bs	37
	.dc.bs	115
	.dc.bs	32
	.dc.bs	0

	.rodata
l15:
	.dc.bs	99
	.dc.bs	32
	.dc.bs	102
	.dc.bs	108
	.dc.bs	97
	.dc.bs	103
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	101
	.dc.bs	100
	.dc.bs	44
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
l17:
	.dc.bs	108
	.dc.bs	32
	.dc.bs	102
	.dc.bs	108
	.dc.bs	97
	.dc.bs	103
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	101
	.dc.bs	100
	.dc.bs	10
	.dc.bs	0

	.rodata
l19:
	.dc.bs	102
	.dc.bs	108
	.dc.bs	97
	.dc.bs	103
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	10
	.dc.bs	0

	.rodata
l25:
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
l8:
	.dc.bs	10
	.dc.bs	0

	.rodata
l12:
	.dc.bs	99
	.dc.bs	58
	.dc.bs	108
	.dc.bs	0

	.rodata
l20:
	.dc.bs	99
	.dc.bs	58
	.dc.bs	108
	.dc.bs	0

	.bss
	.extern	_printf

	.bss
	.extern	_optarg

	.bss
	.extern	_optind

	.bss
	.extern	_getopt
;	End of VBCC generated section
	.module

