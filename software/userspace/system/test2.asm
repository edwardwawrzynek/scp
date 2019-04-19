	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	ld.r.ra ra l14+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	call.j.sp sp _fork
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l16
	ld.r.ra ra l17+0
	ld.r.ra rb _args3+0
	call.j.sp sp _execv
l16:
	ld.r.ra ra l18+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	ld.r.i re 0
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l17:
	.dc.bs	99
	.dc.bs	97
	.dc.bs	116
	.dc.bs	0

	.rodata
l14:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	50
	.dc.bs	10
	.dc.bs	0

	.rodata
l18:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	101
	.dc.bs	99
	.dc.bs	32
	.dc.bs	102
	.dc.bs	97
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	100
	.dc.bs	10
	.dc.bs	0

	.data
_args:
	.global	_args
	.align
	.dc.w	l1
	.dc.w	l2
	.dc.w	l3
	.dc.w	0

	.data
_args2:
	.global	_args2
	.align
	.dc.w	l4
	.dc.w	l5
	.dc.w	l6
	.dc.w	l7
	.dc.w	0

	.data
_args3:
	.global	_args3
	.align
	.dc.w	l8
	.dc.w	l9
	.dc.w	l10
	.dc.w	l11
	.dc.w	0

	.bss
	.extern	_printf

	.bss
	.extern	_fork

	.bss
	.extern	_execv

	.rodata
l1:
	.dc.bs	109
	.dc.bs	107
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	0

	.rodata
l2:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	95
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	49
	.dc.bs	0

	.rodata
l3:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	95
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	50
	.dc.bs	0

	.rodata
l4:
	.dc.bs	108
	.dc.bs	115
	.dc.bs	0

	.rodata
l5:
	.dc.bs	100
	.dc.bs	101
	.dc.bs	118
	.dc.bs	0

	.rodata
l6:
	.dc.bs	102
	.dc.bs	115
	.dc.bs	97
	.dc.bs	107
	.dc.bs	100
	.dc.bs	106
	.dc.bs	0

	.rodata
l7:
	.dc.bs	46
	.dc.bs	0

	.rodata
l8:
	.dc.bs	99
	.dc.bs	97
	.dc.bs	116
	.dc.bs	0

	.rodata
l9:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	50
	.dc.bs	0

	.rodata
l10:
	.dc.bs	45
	.dc.bs	0

	.rodata
l11:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	105
	.dc.bs	116
	.dc.bs	0
;	End of VBCC generated section
	.module

