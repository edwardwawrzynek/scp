	.text
	.align
_print_buffer:
	.global	_print_buffer
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.i r0 0
	ld.r.p.off.w r1 sp 6
l14:
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	push.r.sp r0 sp
	ld.r.ra ra l9+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 6
	alu.r.i add r0 1
	alu.r.i add r1 2
	ld.r.i rc 16
	cmp.r.f r0 rc
	jmp.c.j L l14
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l9:
	.dc.bs	98
	.dc.bs	117
	.dc.bs	102
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	105
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	48
	.dc.bs	52
	.dc.bs	120
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	alu.r.i sub sp 32
	ld.r.ra ra l18+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	mov.r.r r0 sp
	mov.r.r ra r0
	call.j.sp sp _setjmp
	push.r.sp r0 sp
	call.j.sp sp _print_buffer
	alu.r.i add sp 2
	ld.r.ra ra l19+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
l25:
	jmp.c.j LGlge l25
	alu.r.i add sp 32
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l18:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	32
	.dc.bs	115
	.dc.bs	101
	.dc.bs	116
	.dc.bs	106
	.dc.bs	109
	.dc.bs	112
	.dc.bs	10
	.dc.bs	0

	.rodata
l19:
	.dc.bs	100
	.dc.bs	111
	.dc.bs	110
	.dc.bs	101
	.dc.bs	0

	.data
_args:
	.global	_args
	.align
	.dc.w	l1
	.dc.w	l2
	.dc.w	0

	.bss
	.extern	_printf

	.bss
	.extern	_setjmp

	.rodata
l1:
	.dc.bs	115
	.dc.bs	104
	.dc.bs	0

	.rodata
l2:
	.dc.bs	45
	.dc.bs	105
	.dc.bs	0
;	End of VBCC generated section
	.module

