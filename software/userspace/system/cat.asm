	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.ra ra l5+0
	call.j.sp sp _test_syscall
	ld.r.ra ra l9+0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 14
	push.r.sp ra sp
	ld.r.p.off.w ra sp 14
	push.r.sp ra sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j e l8
	ld.r.p.off.w r2 sp 12
	ld.r.p.off.w r1 sp 10
l6:
	ld.r.ra ra l10+0
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r1 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l6
	st.r.p.off.w r1 sp 10
	st.r.p.off.w r2 sp 12
l8:
	ld.r.m.w ra _optind+0
	ld.r.p.off.w rc sp 10
	cmp.r.f ra rc
	jmp.c.j Ge l34
l31:
	ld.r.ra ra l17+0
	push.r.sp ra sp
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	ld.r.p.off.w r0 sp 14
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l16
	ld.r.m.w r1 _stdin+0
	jmp.c.j LGlge l18
l16:
	ld.r.ra ra l19+0
	push.r.sp ra sp
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	ld.r.p.off.w r0 sp 14
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	mov.r.r r1 re
	mov.r.r r0 r1
	ld.r.ra ra l20+0
	mov.r.r rb r0
	call.j.sp sp _test_syscall
l18:
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l22
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	ld.r.p.off.w r0 sp 12
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l23+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
	jmp.c.j LGlge l35
l22:
	ld.r.ra ra l25+0
	call.j.sp sp _test_syscall
	ld.r.i r3 0
	push.r.sp r1 sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r2 r0
	mov.r.r r0 r2
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j e l35
l32:
	mov.r.r r0 r3
	alu.r.i add r3 1
	ld.r.ra ra l29+0
	mov.r.r rb r0
	call.j.sp sp _test_syscall
	mov.r.r r0 r2
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	push.r.sp r1 sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r2 r0
	mov.r.r r0 r2
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l32
l35:
	ld.r.m.w r0 _optind+0
	alu.r.i add r0 1
	st.r.m.w r0 _optind+0
	ld.r.p.off.w rc sp 10
	cmp.r.f r0 rc
	jmp.c.j L l31
l34:
	ld.r.m.b r0 _did_error+0
	mov.r.r re r0
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l19:
	.dc.bs	114
	.dc.bs	43
	.dc.bs	0

	.rodata
l20:
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	101
	.dc.bs	100
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	10
	.dc.bs	0

	.rodata
l23:
	.dc.bs	99
	.dc.bs	97
	.dc.bs	116
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	32
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	0

	.rodata
l29:
	.dc.bs	114
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	10
	.dc.bs	0

	.rodata
l25:
	.dc.bs	114
	.dc.bs	117
	.dc.bs	110
	.dc.bs	110
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	10
	.dc.bs	0

	.rodata
l17:
	.dc.bs	45
	.dc.bs	0

	.rodata
l5:
	.dc.bs	115
	.dc.bs	116
	.dc.bs	97
	.dc.bs	114
	.dc.bs	116
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	116
	.dc.bs	10
	.dc.bs	0

	.rodata
l9:
	.dc.bs	0

	.rodata
l10:
	.dc.bs	0

	.data
_did_error:
	.global	_did_error
	.dc.bs	0

	.data
_args:
	.global	_args
	.align
	.dc.w	l1
	.dc.w	l2

	.bss
	.extern	_test_syscall

	.bss
	.extern	_optind

	.bss
	.extern	_getopt

	.bss
	.extern	_fgetc

	.bss
	.extern	_putchar

	.bss
	.extern	_fopen

	.bss
	.extern	_stdin

	.bss
	.extern	_stderr

	.bss
	.extern	_fprintf

	.bss
	.extern	_strcmp

	.rodata
l1:
	.dc.bs	99
	.dc.bs	97
	.dc.bs	116
	.dc.bs	0

	.rodata
l2:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	50
	.dc.bs	0
;	End of VBCC generated section
	.module

