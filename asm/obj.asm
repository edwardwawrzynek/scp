	.text
	.align
l1:
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	push.r.sp r1 sp
	ld.r.ra ra l4+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i ra 1
	push.r.sp ra sp
	call.j.sp sp _exit
	alu.r.i add sp 2
	mov.r.r r0 re
l2:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l4:
	.dc.bs	115
	.dc.bs	99
	.dc.bs	112
	.dc.bs	32
	.dc.bs	111
	.dc.bs	98
	.dc.bs	106
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	10
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0
	.text
	.align
l5:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	ld.r.p.off.b r2 sp 14
	ld.r.p.off.w r1 sp 12
	jmp.c.j LGlge l9
l8:
	push.r.sp r3 sp
	mov.r.r r0 r1
	alu.r.i band r0 255
	push.r.sp r0 sp
	call.j.sp sp _fputc
	alu.r.i add sp 4
	mov.r.r r0 re
	alu.r.i ursh r1 8
l9:
	mov.r.r r0 r2
	alu.r.i sub r2 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l8
l10:
l6:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
l11:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.b r3 sp 16
	ld.r.i ra 0
	st.r.p.w ra sp
	ld.r.i r2 0
	jmp.c.j LGlge l15
l14:
	ld.r.p.off.w ra sp 14
	push.r.sp ra sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.r lsh r0 r1
	ld.r.p.w rc sp
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra sp
	mov.r.r r0 r2
	mov.r.r r1 r0
	alu.r.i add r1 8
	mov.r.r r2 r1
	ld.r.p.off.w ra sp 14
	push.r.sp ra sp
	call.j.sp sp _feof
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l18
	ld.r.ra ra l19+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l18:
l15:
	mov.r.r r0 r3
	alu.r.i sub r3 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l14
l16:
	ld.r.p.w re sp
l12:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l19:
	.dc.bs	85
	.dc.bs	110
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	69
	.dc.bs	79
	.dc.bs	70
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_obj_write_header:
	.global	_obj_write_header
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r2 sp 12
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i ra 4
	push.r.sp ra sp
	ld.r.i ra 1330660179
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 4
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i r3 0
	jmp.c.j LGlge l23
l22:
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
l25:
	alu.r.i add r3 1
l23:
	ld.r.i rc 4
	cmp.r.f r3 rc
	jmp.c.j L l22
l24:
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 16
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 16
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 20
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 20
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _ftell
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 56
	cmp.r.f r0 rc
	jmp.c.j e l27
l26:
	ld.r.ra ra l28+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l27:
l20:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l28:
	.dc.bs	73
	.dc.bs	110
	.dc.bs	116
	.dc.bs	101
	.dc.bs	114
	.dc.bs	110
	.dc.bs	97
	.dc.bs	108
	.dc.bs	32
	.dc.bs	69
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	104
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	115
	.dc.bs	105
	.dc.bs	122
	.dc.bs	101
	.dc.bs	32
	.dc.bs	100
	.dc.bs	111
	.dc.bs	101
	.dc.bs	115
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	97
	.dc.bs	116
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	119
	.dc.bs	114
	.dc.bs	105
	.dc.bs	116
	.dc.bs	116
	.dc.bs	101
	.dc.bs	110
	.dc.bs	32
	.dc.bs	104
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	101
	.dc.bs	114
	.dc.bs	39
	.dc.bs	115
	.dc.bs	32
	.dc.bs	115
	.dc.bs	105
	.dc.bs	122
	.dc.bs	101
	.dc.bs	0
	.text
	.align
_obj_read_header:
	.global	_obj_read_header
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r3 sp 16
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 1330660179
	cmp.r.f r0 rc
	jmp.c.j e l32
l31:
	ld.r.ra ra l33+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l32:
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i ra 56
	st.r.p.w ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 4
	jmp.c.j LGlge l35
l34:
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	cmp.r.f ra r2
	jmp.c.j e l39
l38:
	ld.r.ra ra l40+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l39:
	mov.r.r r0 r3
	alu.r.i add r0 4
	ld.r.p.off.w r1 sp 4
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	st.r.p.w r2 r0
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	alu.r.r add ra r2
	st.r.p.w ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	ld.r.p.off.w r1 sp 4
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	alu.r.i add r0 2
	st.r.p.w r2 r0
l37:
	ld.r.p.off.w ra sp 4
	alu.r.i add ra 1
	st.r.p.off.w ra sp 4
l35:
	ld.r.p.off.w ra sp 4
	ld.r.i rc 4
	cmp.r.f ra rc
	jmp.c.j L l34
l36:
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	cmp.r.f ra r2
	jmp.c.j e l42
l41:
	ld.r.ra ra l43+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l42:
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 16
	st.r.p.w r2 r0
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	alu.r.r add ra r2
	st.r.p.w ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 16
	alu.r.i add r0 2
	st.r.p.w r2 r0
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	cmp.r.f ra r2
	jmp.c.j e l45
l44:
	ld.r.ra ra l46+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l45:
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 20
	st.r.p.w r2 r0
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r2 re
	ld.r.p.w ra sp
	alu.r.r add ra r2
	st.r.p.w ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 20
	alu.r.i add r0 2
	st.r.p.w r2 r0
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _ftell
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r3
	alu.r.i add r1 2
	mov.r.r rc r1
	ld.r.p.w rc rc
	alu.r.r sub r0 rc
	ld.r.i rc 56
	cmp.r.f r0 rc
	jmp.c.j e l48
l47:
	ld.r.ra ra l49+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l48:
l29:
	alu.r.i add sp 6
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l33:
	.dc.bs	69
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	77
	.dc.bs	97
	.dc.bs	103
	.dc.bs	105
	.dc.bs	99
	.dc.bs	32
	.dc.bs	78
	.dc.bs	117
	.dc.bs	109
	.dc.bs	98
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	116
	.dc.bs	97
	.dc.bs	114
	.dc.bs	116
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	0

	.rodata
	.align
l40:
	.dc.bs	115
	.dc.bs	101
	.dc.bs	103
	.dc.bs	109
	.dc.bs	101
	.dc.bs	110
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	105
	.dc.bs	115
	.dc.bs	97
	.dc.bs	108
	.dc.bs	105
	.dc.bs	103
	.dc.bs	110
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l43:
	.dc.bs	115
	.dc.bs	121
	.dc.bs	109
	.dc.bs	98
	.dc.bs	111
	.dc.bs	108
	.dc.bs	32
	.dc.bs	115
	.dc.bs	101
	.dc.bs	103
	.dc.bs	109
	.dc.bs	101
	.dc.bs	110
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	105
	.dc.bs	115
	.dc.bs	97
	.dc.bs	108
	.dc.bs	105
	.dc.bs	103
	.dc.bs	110
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l46:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	116
	.dc.bs	101
	.dc.bs	114
	.dc.bs	110
	.dc.bs	32
	.dc.bs	115
	.dc.bs	121
	.dc.bs	109
	.dc.bs	98
	.dc.bs	111
	.dc.bs	108
	.dc.bs	32
	.dc.bs	115
	.dc.bs	101
	.dc.bs	103
	.dc.bs	109
	.dc.bs	101
	.dc.bs	110
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	105
	.dc.bs	115
	.dc.bs	97
	.dc.bs	108
	.dc.bs	105
	.dc.bs	103
	.dc.bs	110
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l49:
	.dc.bs	73
	.dc.bs	110
	.dc.bs	116
	.dc.bs	101
	.dc.bs	114
	.dc.bs	110
	.dc.bs	97
	.dc.bs	108
	.dc.bs	32
	.dc.bs	69
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	104
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	115
	.dc.bs	105
	.dc.bs	122
	.dc.bs	101
	.dc.bs	32
	.dc.bs	100
	.dc.bs	111
	.dc.bs	101
	.dc.bs	115
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	97
	.dc.bs	116
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	32
	.dc.bs	104
	.dc.bs	101
	.dc.bs	97
	.dc.bs	100
	.dc.bs	101
	.dc.bs	114
	.dc.bs	39
	.dc.bs	115
	.dc.bs	32
	.dc.bs	115
	.dc.bs	105
	.dc.bs	122
	.dc.bs	101
	.dc.bs	0
	.text
	.align
_obj_init:
	.global	_obj_init
	push.r.sp r0 sp
	ld.r.p.off.w r4 sp 4
	ld.r.i ra 0
	st.r.p.w ra r4
	mov.r.r r0 r4
	alu.r.i add r0 28
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 30
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 32
	ld.r.i ra 0
	st.r.p.b ra r0
	mov.r.r r0 r4
	alu.r.i add r0 2
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 34
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 34
	alu.r.i add r0 2
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 34
	alu.r.i add r0 4
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r4
	alu.r.i add r0 34
	alu.r.i add r0 6
	ld.r.i ra 0
	st.r.p.w ra r0
l50:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_create_header:
	.global	_obj_create_header
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 22
	ld.r.p.off.w r9 sp 20
	ld.r.p.off.w r8 sp 18
	ld.r.p.off.w r7 sp 16
	ld.r.p.off.w r6 sp 14
	ld.r.i r4 56
	ld.r.i r5 0
	jmp.c.j LGlge l55
l54:
	mov.r.r r0 r6
	alu.r.i add r0 4
	mov.r.r r1 r5
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	st.r.p.w r4 r0
	mov.r.r r0 r5
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l59
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j e l60
	ld.r.i rc 2
	cmp.r.f r0 rc
	jmp.c.j e l61
	ld.r.i rc 3
	cmp.r.f r0 rc
	jmp.c.j e l62
	jmp.c.j LGlge l63
l59:
	mov.r.r r0 r7
	alu.r.i mul r0 2
	mov.r.r r1 r6
	alu.r.i add r1 4
	mov.r.r r2 r5
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	st.r.p.w r0 r1
	mov.r.r r0 r7
	alu.r.i mul r0 2
	alu.r.r add r4 r0
	jmp.c.j LGlge l58
l60:
	mov.r.r r0 r8
	alu.r.i mul r0 2
	mov.r.r r1 r6
	alu.r.i add r1 4
	mov.r.r r2 r5
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	st.r.p.w r0 r1
	mov.r.r r0 r8
	alu.r.i mul r0 2
	alu.r.r add r4 r0
	jmp.c.j LGlge l58
l61:
	mov.r.r r0 r9
	alu.r.i mul r0 2
	mov.r.r r1 r6
	alu.r.i add r1 4
	mov.r.r r2 r5
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	st.r.p.w r0 r1
	mov.r.r r0 r9
	alu.r.i mul r0 2
	alu.r.r add r4 r0
	jmp.c.j LGlge l58
l62:
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r r1 r6
	alu.r.i add r1 4
	mov.r.r r2 r5
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	st.r.p.w r0 r1
	mov.r.r r0 r3
	alu.r.i mul r0 2
	alu.r.r add r4 r0
	jmp.c.j LGlge l58
l63:
l58:
l57:
	alu.r.i add r5 1
l55:
	ld.r.i rc 4
	cmp.r.f r5 rc
	jmp.c.j L l54
l56:
	mov.r.r r0 r6
	alu.r.i add r0 4
	alu.r.i add r0 16
	st.r.p.w r4 r0
	ld.r.p.off.w r0 sp 24
	alu.r.i mul r0 67
	mov.r.r r1 r6
	alu.r.i add r1 4
	alu.r.i add r1 16
	alu.r.i add r1 2
	st.r.p.w r0 r1
	ld.r.p.off.w r0 sp 24
	alu.r.i mul r0 67
	alu.r.r add r4 r0
	mov.r.r r0 r6
	alu.r.i add r0 4
	alu.r.i add r0 20
	st.r.p.w r4 r0
	ld.r.p.off.w r0 sp 26
	alu.r.i mul r0 67
	mov.r.r r1 r6
	alu.r.i add r1 4
	alu.r.i add r1 20
	alu.r.i add r1 2
	st.r.p.w r0 r1
	ld.r.p.off.w r0 sp 26
	alu.r.i mul r0 67
	alu.r.r add r4 r0
l52:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_expand_extern:
	.global	_obj_expand_extern
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 12
	ld.r.p.off.w r2 sp 10
	mov.r.r r0 r3
	alu.r.i mul r0 67
	mov.r.r r1 r2
	alu.r.i add r1 4
	alu.r.i add r1 20
	alu.r.i add r1 2
	st.r.p.w r0 r1
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	ld.r.p.w r0 r0
	alu.r.i add r0 52
	push.r.sp r0 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i ra 4
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 20
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
l64:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
l66:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 14
	ld.r.p.off.w r2 sp 12
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	ld.r.p.off.w rc sp 18
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	push.r.sp r0 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i ra 0
	st.r.p.b ra sp
	ld.r.i r1 0
	jmp.c.j LGlge l70
l69:
	mov.r.r r0 r3
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l74
l73:
	ld.r.i ra 1
	st.r.p.b ra sp
l74:
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l76
l75:
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.r add r0 r1
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	jmp.c.j LGlge l77
l76:
	ld.r.i ra 1
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
l77:
l72:
	alu.r.i add r1 1
l70:
	mov.r.r r0 r1
	ld.r.i rc 64
	cmp.r.f r0 rc
	jmp.c.j L l69
l71:
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l79
l78:
	push.r.sp r3 sp
	ld.r.ra ra l80+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.ra ra l81+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l79:
	ld.r.i ra 2
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 64
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 66
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l5
	alu.r.i add sp 6
l67:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l80:
	.dc.bs	10
	.dc.bs	78
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l81:
	.dc.bs	65
	.dc.bs	98
	.dc.bs	111
	.dc.bs	118
	.dc.bs	101
	.dc.bs	32
	.dc.bs	115
	.dc.bs	121
	.dc.bs	109
	.dc.bs	98
	.dc.bs	111
	.dc.bs	108
	.dc.bs	32
	.dc.bs	110
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	32
	.dc.bs	105
	.dc.bs	115
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	111
	.dc.bs	32
	.dc.bs	108
	.dc.bs	111
	.dc.bs	110
	.dc.bs	103
	.dc.bs	10
	.dc.bs	0
	.text
	.align
l82:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 2
	ld.r.p.off.w rc sp 18
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	push.r.sp r0 sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i r2 0
	jmp.c.j LGlge l86
l85:
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 14
	alu.r.r add r1 r2
	st.r.p.bs r0 r1
l88:
	alu.r.i add r2 1
l86:
	mov.r.r r0 r2
	ld.r.i rc 64
	cmp.r.f r0 rc
	jmp.c.j L l85
l87:
	ld.r.i ra 2
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 14
	alu.r.i add r1 64
	st.r.p.w r0 r1
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp l11
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 14
	alu.r.i add r1 66
	st.r.p.b r0 r1
l83:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_write_defined:
	.global	_obj_write_defined
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 70
	ld.r.p.off.w r2 sp 80
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 16
	mov.r.r r1 r2
	alu.r.i add r1 28
	ld.r.p.w r1 r1
	alu.r.i mul r1 67
	ld.r.p.w r0 r0
	alu.r.r add r0 r1
	mov.r.r r3 r0
	ld.r.p.off.w ra sp 82
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.b ra sp 84
	st.r.p.off.b ra sp 68
	ld.r.p.off.w ra sp 86
	st.r.p.off.w ra sp 66
	push.r.sp r3 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp l66
	alu.r.i add sp 6
	mov.r.r r0 r2
	alu.r.i add r0 28
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r0
l89:
	alu.r.i add sp 70
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_write_extern:
	.global	_obj_write_extern
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 70
	ld.r.p.off.w r2 sp 80
	mov.r.r r0 r2
	alu.r.i add r0 4
	alu.r.i add r0 20
	mov.r.r r1 r2
	alu.r.i add r1 30
	ld.r.p.w r1 r1
	alu.r.i mul r1 67
	ld.r.p.w r0 r0
	alu.r.r add r0 r1
	mov.r.r r3 r0
	ld.r.p.off.w ra sp 82
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i ra -1
	st.r.p.off.b ra sp 68
	ld.r.p.off.w ra sp 84
	st.r.p.off.w ra sp 66
	push.r.sp r3 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp l66
	alu.r.i add sp 6
	mov.r.r r0 r2
	alu.r.i add r0 30
	mov.r.r r1 r0
	ld.r.p.w r1 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r0
	mov.r.r re r1
l91:
	alu.r.i add sp 70
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_get_defined:
	.global	_obj_get_defined
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 8
	ld.r.p.off.w r3 sp 18
	ld.r.i ra 67
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 16
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	st.r.p.off.w re sp 2
	ld.r.p.off.w ra sp 2
	alu.r.i mul ra 68
	st.r.p.off.w ra sp 4
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	st.r.p.w re sp
	ld.r.i r2 0
	jmp.c.j LGlge l96
l95:
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 16
	mov.r.r r1 r2
	alu.r.i mul r1 67
	ld.r.p.w r0 r0
	alu.r.r add r0 r1
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i mul r0 68
	ld.r.p.off.w r1 sp 2
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp l82
	alu.r.i add sp 6
l98:
	alu.r.i add r2 1
l96:
	ld.r.p.off.w rc sp 2
	cmp.r.f r2 rc
	jmp.c.j l l95
l97:
	ld.r.p.w re sp
l93:
	alu.r.i add sp 8
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_get_extern:
	.global	_obj_get_extern
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 8
	ld.r.p.off.w r3 sp 18
	ld.r.i ra 67
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 20
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	st.r.p.off.w re sp 2
	ld.r.p.off.w ra sp 2
	alu.r.i mul ra 68
	st.r.p.off.w ra sp 4
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	st.r.p.w re sp
	ld.r.i r2 0
	jmp.c.j LGlge l102
l101:
	mov.r.r r0 r3
	alu.r.i add r0 4
	alu.r.i add r0 20
	mov.r.r r1 r2
	alu.r.i mul r1 67
	ld.r.p.w r0 r0
	alu.r.r add r0 r1
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i mul r0 68
	ld.r.p.off.w r1 sp 2
	alu.r.r add r1 r0
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp l82
	alu.r.i add sp 6
l104:
	alu.r.i add r2 1
l102:
	ld.r.p.off.w rc sp 2
	cmp.r.f r2 rc
	jmp.c.j l l101
l103:
	ld.r.p.w re sp
l99:
	alu.r.i add sp 8
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_find_defined_symbol:
	.global	_obj_find_defined_symbol
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 18
	ld.r.i ra 67
	push.r.sp ra sp
	ld.r.p.off.w r0 sp 16
	alu.r.i add r0 4
	alu.r.i add r0 16
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	st.r.p.w re sp
	ld.r.i r2 0
	jmp.c.j LGlge l108
l107:
	mov.r.r r0 r2
	alu.r.i mul r0 68
	mov.r.r r1 r3
	alu.r.r add r1 r0
	push.r.sp r1 sp
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l112
l111:
	mov.r.r r0 r2
	alu.r.i mul r0 68
	mov.r.r r1 r3
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l105
l112:
l110:
	alu.r.i add r2 1
l108:
	ld.r.p.w rc sp
	cmp.r.f r2 rc
	jmp.c.j l l107
l109:
	ld.r.i re 0
l105:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_set_seg:
	.global	_obj_set_seg
	push.r.sp r0 sp
	ld.r.p.off.b r5 sp 6
	ld.r.p.off.w r4 sp 4
	mov.r.r r0 r4
	alu.r.i add r0 32
	st.r.p.b r5 r0
l113:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
l115:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	mov.r.r r0 r3
	alu.r.i add r0 34
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r r1 r3
	alu.r.i add r1 4
	mov.r.r r2 r3
	alu.r.i add r2 32
	ld.r.p.b r2 r2
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	mov.r.r rc r1
	ld.r.p.w rc rc
	cmp.r.f ra rc
	jmp.c.j l l119
l118:
	ld.r.ra ra l120+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l119:
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	mov.r.r r1 r3
	alu.r.i add r1 34
	mov.r.r r2 r3
	alu.r.i add r2 32
	ld.r.p.b r2 r2
	alu.r.i mul r2 2
	alu.r.r add r1 r2
	mov.r.r rc r1
	ld.r.p.w rc rc
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	mov.r.r r1 r3
	alu.r.i add r1 2
	mov.r.r rc r1
	ld.r.p.w rc rc
	alu.r.r add r0 rc
	push.r.sp r0 sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	mov.r.r r0 r3
	alu.r.i add r0 34
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r0
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.p.off.b r0 sp 14
	push.r.sp r0 sp
	call.j.sp sp _fputc
	alu.r.i add sp 4
	mov.r.r r0 re
l116:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l120:
	.dc.bs	115
	.dc.bs	101
	.dc.bs	103
	.dc.bs	32
	.dc.bs	115
	.dc.bs	105
	.dc.bs	122
	.dc.bs	101
	.dc.bs	32
	.dc.bs	111
	.dc.bs	118
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	117
	.dc.bs	110
	.dc.bs	0
	.text
	.align
_obj_write_const_byte:
	.global	_obj_write_const_byte
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.b r2 sp 10
	ld.r.p.off.w r1 sp 8
	ld.r.i ra 0
	push.r.sp ra sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	mov.r.r r0 r2
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
l121:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_write_const_word:
	.global	_obj_write_const_word
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 10
	ld.r.p.off.w r1 sp 8
	ld.r.i ra 1
	push.r.sp ra sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	mov.r.r r0 r2
	alu.r.i band r0 255
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	ld.r.i ra 3
	push.r.sp ra sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	mov.r.r r0 r2
	alu.r.i ursh r0 8
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp l115
	alu.r.i add sp 4
l123:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_write_offset:
	.global	_obj_write_offset
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 5
	ld.r.p.off.b ra sp 18
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l128
l127:
	ld.r.i r0 64
	jmp.c.j LGlge l129
l128:
	ld.r.i r0 0
l129:
	mov.r.r r1 r2
	alu.r.r bor r0 r1
	mov.r.r r2 r0
	ld.r.p.off.b r0 sp 16
	alu.r.i band r0 3
	alu.r.i lsh r0 4
	mov.r.r r1 r2
	alu.r.r bor r0 r1
	mov.r.r r2 r0
	mov.r.r r0 r2
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 14
	alu.r.i band r0 255
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	mov.r.r r0 r2
	alu.r.i bor r0 2
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 14
	alu.r.i ursh r0 8
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
l125:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_write_extern_offset:
	.global	_obj_write_extern_offset
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 13
	ld.r.p.off.b ra sp 16
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l133
l132:
	ld.r.i r0 64
	jmp.c.j LGlge l134
l133:
	ld.r.i r0 0
l134:
	mov.r.r r1 r2
	alu.r.r bor r0 r1
	mov.r.r r2 r0
	mov.r.r r0 r2
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 14
	alu.r.i band r0 255
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	mov.r.r r0 r2
	alu.r.i bor r0 2
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 14
	alu.r.i ursh r0 8
	push.r.sp r0 sp
	push.r.sp r3 sp
	call.j.sp sp l115
	alu.r.i add sp 4
l130:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
l135:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	mov.r.r r0 r3
	alu.r.i add r0 34
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r r1 r3
	alu.r.i add r1 4
	mov.r.r r2 r3
	alu.r.i add r2 32
	ld.r.p.b r2 r2
	alu.r.i mul r2 4
	alu.r.r add r1 r2
	alu.r.i add r1 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	mov.r.r rc r1
	ld.r.p.w rc rc
	cmp.r.f ra rc
	jmp.c.j l l139
l138:
	ld.r.i re -1
	jmp.c.j LGlge l136
l139:
	ld.r.i ra 1
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 4
	alu.r.r add r0 r1
	mov.r.r r1 r3
	alu.r.i add r1 34
	mov.r.r r2 r3
	alu.r.i add r2 32
	ld.r.p.b r2 r2
	alu.r.i mul r2 2
	alu.r.r add r1 r2
	mov.r.r rc r1
	ld.r.p.w rc rc
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	mov.r.r r1 r3
	alu.r.i add r1 2
	mov.r.r rc r1
	ld.r.p.w rc rc
	alu.r.r add r0 rc
	push.r.sp r0 sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	mov.r.r r0 r3
	alu.r.i add r0 34
	mov.r.r r1 r3
	alu.r.i add r1 32
	ld.r.p.b r1 r1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r0
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r re r0
l136:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_read_byte:
	.global	_obj_read_byte
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 14
	push.r.sp r3 sp
	call.j.sp sp l135
	alu.r.i add sp 2
	mov.r.r r1 re
	push.r.sp r3 sp
	call.j.sp sp l135
	alu.r.i add sp 2
	mov.r.r r2 re
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j e l142
l144:
	ld.r.i rc -1
	cmp.r.f r2 rc
	jmp.c.j GLgl l143
l142:
	ld.r.i re -1
	jmp.c.j LGlge l140
l143:
	ld.r.p.off.w rc sp 18
	st.r.p.b r1 rc
	ld.r.p.off.w rc sp 16
	st.r.p.b r2 rc
	ld.r.i re 0
l140:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_obj_read_data:
	.global	_obj_read_data
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 16
	ld.r.p.off.w r2 sp 14
	mov.r.r r0 sp
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _obj_read_byte
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l148
l147:
	ld.r.i re -1
	jmp.c.j LGlge l145
l148:
	ld.r.p.b r0 sp
	alu.r.i band r0 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l150
	ld.r.i ra 1
	ld.r.p.off.w rc sp 20
	st.r.p.b ra rc
	jmp.c.j LGlge l151
l150:
	ld.r.i ra 0
	ld.r.p.off.w rc sp 20
	st.r.p.b ra rc
	ld.r.p.off.b ra sp 2
	st.r.p.w ra r3
	ld.r.p.b ra sp
	ld.r.p.off.w rc sp 18
	st.r.p.b ra rc
	ld.r.i re 0
	jmp.c.j LGlge l145
l151:
	mov.r.r r0 sp
	alu.r.i add r0 1
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 5
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _obj_read_byte
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l153
l152:
	ld.r.ra ra l154+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
	ld.r.i re -1
	jmp.c.j LGlge l145
l153:
	ld.r.p.off.b r0 sp 1
	alu.r.i band r0 2
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l156
l155:
	ld.r.ra ra l157+0
	push.r.sp ra sp
	call.j.sp sp l1
	alu.r.i add sp 2
l156:
	ld.r.p.off.b r0 sp 3
	alu.r.i lsh r0 8
	ld.r.p.off.b r1 sp 2
	alu.r.r add r1 r0
	st.r.p.w r1 r3
	ld.r.p.b ra sp
	ld.r.p.off.w rc sp 18
	st.r.p.b ra rc
	ld.r.i re 0
l145:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l154:
	.dc.bs	69
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	97
	.dc.bs	32
	.dc.bs	115
	.dc.bs	101
	.dc.bs	99
	.dc.bs	111
	.dc.bs	110
	.dc.bs	100
	.dc.bs	32
	.dc.bs	98
	.dc.bs	121
	.dc.bs	116
	.dc.bs	101
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	32
	.dc.bs	119
	.dc.bs	111
	.dc.bs	114
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l157:
	.dc.bs	83
	.dc.bs	101
	.dc.bs	99
	.dc.bs	111
	.dc.bs	110
	.dc.bs	100
	.dc.bs	32
	.dc.bs	98
	.dc.bs	121
	.dc.bs	116
	.dc.bs	101
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	32
	.dc.bs	119
	.dc.bs	111
	.dc.bs	114
	.dc.bs	100
	.dc.bs	32
	.dc.bs	105
	.dc.bs	115
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	109
	.dc.bs	97
	.dc.bs	114
	.dc.bs	107
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	97
	.dc.bs	115
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	0

	.bss
	.align
	.extern	___crtudiv

	.bss
	.align
	.extern	_fgetc

	.bss
	.align
	.extern	_fputc

	.bss
	.align
	.extern	_fseek

	.bss
	.align
	.extern	_ftell

	.bss
	.align
	.extern	_feof

	.bss
	.align
	.extern	_printf

	.bss
	.align
	.extern	_malloc

	.bss
	.align
	.extern	_strcmp

	.bss
	.align
	.extern	_strcpy

	.bss
	.align
	.extern	_exit
;	End of VBCC generated section
	.module

