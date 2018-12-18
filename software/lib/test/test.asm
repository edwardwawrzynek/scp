	.text
_scroll:
	.global	_scroll
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.i r1 0
	jmp.c.j LGlge l6
l5:
l9:
	mov.r.r r0 r1
	alu.r.i add r0 80
	out.r.p r0 5

l11:
l10:
	call.j.sp sp __inp_6
	mov.r.r r3 re
l13:
	mov.r.r r0 r1
	out.r.p r0 5

l15:
l14:
l17:
	mov.r.r r0 r3
	out.r.p r0 6

l19:
l18:
l8:
	alu.r.i add r1 1
l6:
	ld.r.i rc 1920
	cmp.r.f r1 rc
	jmp.c.j L l5
l7:
	ld.r.i r2 1920
	jmp.c.j LGlge l22
l21:
l25:
	mov.r.r r0 r2
	out.r.p r0 5

l27:
l26:
l29:
	ld.r.i r0 0
	out.r.p r0 6

l31:
l30:
l24:
	alu.r.i add r2 1
l22:
	ld.r.i rc 2000
	cmp.r.f r2 rc
	jmp.c.j L l21
l23:
l3:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_putchar:
	.global	_putchar
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.bs r1 sp 6
	mov.r.r r0 r1
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l36
l35:
	ld.r.m.w ra l1+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l38
	ld.r.i ra 0
	st.r.m.w ra l1+0
	ld.r.m.w ra l2+0
	alu.r.i add ra 1
	st.r.m.w ra l2+0
l38:
	jmp.c.j LGlge l39
l36:
	mov.r.r r0 r1
	ld.r.i rc 9
	cmp.r.f r0 rc
	jmp.c.j GLgl l41
l40:
	ld.r.m.w r0 l1+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l43
l42:
	ld.r.m.w ra l1+0
	alu.r.i add ra 1
	st.r.m.w ra l1+0
l43:
	jmp.c.j LGlge l45
l44:
	ld.r.m.w ra l1+0
	alu.r.i add ra 1
	st.r.m.w ra l1+0
l45:
	ld.r.m.w r0 l1+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l44
l46:
	jmp.c.j LGlge l47
l41:
	ld.r.m.w ra l1+0
	ld.r.i rc 80
	cmp.r.f ra rc
	jmp.c.j L l49
l48:
	ld.r.i ra 0
	st.r.m.w ra l1+0
	ld.r.m.w ra l2+0
	alu.r.i add ra 1
	st.r.m.w ra l2+0
l49:
	ld.r.m.w ra l2+0
	ld.r.i rc 25
	cmp.r.f ra rc
	jmp.c.j L l51
l50:
	call.j.sp sp _scroll
	ld.r.i ra 24
	st.r.m.w ra l2+0
	ld.r.i ra 0
	st.r.m.w ra l1+0
l51:
l52:
	ld.r.m.w r0 l2+0
	alu.r.i mul r0 80
	ld.r.m.w rc l1+0
	alu.r.r add r0 rc
	out.r.p r0 5

l54:
l53:
l56:
	mov.r.r r0 r1
	out.r.p r0 6

l58:
l57:
	ld.r.m.w ra l1+0
	alu.r.i add ra 1
	st.r.m.w ra l1+0
l47:
l39:
l33:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_puts:
	.global	_puts
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	jmp.c.j LGlge l63
l62:
	mov.r.r r0 r1
	alu.r.i add r1 1
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
l63:
	mov.r.r ra r1
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l62
l64:
l60:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_hex:
	.global	_hex
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	mov.r.r r0 r2
	alu.r.i ursh r0 12
	alu.r.i band r0 15
	ld.r.ra r1 l67+0
	alu.r.r add r1 r0
	ld.r.p.bs r1 r1
	push.r.sp r1 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r2
	alu.r.i ursh r0 8
	alu.r.i band r0 15
	ld.r.ra r1 l68+0
	alu.r.r add r1 r0
	ld.r.p.bs r1 r1
	push.r.sp r1 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r2
	alu.r.i ursh r0 4
	alu.r.i band r0 15
	ld.r.ra r1 l69+0
	alu.r.r add r1 r0
	ld.r.p.bs r1 r1
	push.r.sp r1 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r2
	alu.r.i band r0 15
	ld.r.ra r1 l70+0
	alu.r.r add r1 r0
	ld.r.p.bs r1 r1
	push.r.sp r1 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	ld.r.i ra 10
	push.r.sp ra sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
l65:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l67:
	.dc.bs	48
	.dc.bs	49
	.dc.bs	50
	.dc.bs	51
	.dc.bs	52
	.dc.bs	53
	.dc.bs	54
	.dc.bs	55
	.dc.bs	56
	.dc.bs	57
	.dc.bs	97
	.dc.bs	98
	.dc.bs	99
	.dc.bs	100
	.dc.bs	101
	.dc.bs	102
	.dc.bs	0

	.rodata
l68:
	.dc.bs	48
	.dc.bs	49
	.dc.bs	50
	.dc.bs	51
	.dc.bs	52
	.dc.bs	53
	.dc.bs	54
	.dc.bs	55
	.dc.bs	56
	.dc.bs	57
	.dc.bs	97
	.dc.bs	98
	.dc.bs	99
	.dc.bs	100
	.dc.bs	101
	.dc.bs	102
	.dc.bs	0

	.rodata
l69:
	.dc.bs	48
	.dc.bs	49
	.dc.bs	50
	.dc.bs	51
	.dc.bs	52
	.dc.bs	53
	.dc.bs	54
	.dc.bs	55
	.dc.bs	56
	.dc.bs	57
	.dc.bs	97
	.dc.bs	98
	.dc.bs	99
	.dc.bs	100
	.dc.bs	101
	.dc.bs	102
	.dc.bs	0

	.rodata
l70:
	.dc.bs	48
	.dc.bs	49
	.dc.bs	50
	.dc.bs	51
	.dc.bs	52
	.dc.bs	53
	.dc.bs	54
	.dc.bs	55
	.dc.bs	56
	.dc.bs	57
	.dc.bs	97
	.dc.bs	98
	.dc.bs	99
	.dc.bs	100
	.dc.bs	101
	.dc.bs	102
	.dc.bs	0
	.text
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	alu.r.i sub sp 2
	ld.r.i r1 12252
	ld.r.i ra 3
	push.r.sp ra sp
	push.r.sp r1 sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	mov.r.r r0 re
	push.r.sp r0 sp
	call.j.sp sp _hex
	alu.r.i add sp 2
l73:
	jmp.c.j LGlge l73
l75:
	ld.r.i re 0
l71:
	alu.r.i add sp 2
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.extern	___crtudiv

	.bss
	.extern	__inp_6

	.data
l1:
	.align
	.dc.w	0

	.data
l2:
	.align
	.dc.w	24
;	End of VBCC generated section
	.module

