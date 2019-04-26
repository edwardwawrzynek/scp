	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.p.off.w r2 sp 14
	ld.r.ra ra l5+0
	call.j.sp sp _test_syscall
	ld.r.ra ra l9+0
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j e l31
l28:
	ld.r.ra ra l10+0
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l28
l31:
	ld.r.m.w ra _optind+0
	cmp.r.f ra r3
	jmp.c.j Ge l32
l29:
	ld.r.ra ra l17+0
	push.r.sp ra sp
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r2
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
	ld.r.i r1 0
	jmp.c.j LGlge l18
l16:
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r2
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rb 1
	call.j.sp sp _open
	mov.r.r r1 re
	mov.r.r r0 r1
	ld.r.ra ra l19+0
	mov.r.r rb r0
	call.j.sp sp _test_syscall
l18:
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j GLgl l21
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r2
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l22+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
	jmp.c.j LGlge l33
l21:
	ld.r.ra ra l24+0
	call.j.sp sp _test_syscall
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 2
	push.r.sp r0 sp
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _read
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j GLgl l33
l30:
	ld.r.p.bs r0 sp
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 2
	push.r.sp r0 sp
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _read
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j e l30
l33:
	ld.r.m.w r0 _optind+0
	alu.r.i add r0 1
	st.r.m.w r0 _optind+0
	cmp.r.f r0 r3
	jmp.c.j L l29
l32:
	ld.r.m.b r0 _did_error+0
	mov.r.r re r0
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l19:
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
l22:
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
l24:
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
	.extern	_open

	.bss
	.extern	_read

	.bss
	.extern	_optind

	.bss
	.extern	_getopt

	.bss
	.extern	_putchar

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

