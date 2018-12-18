	.text
_scroll:
	.global	_scroll
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.i r2 0
	ld.r.i r3 80
l79:
	mov.r.r r0 r3
	out.r.p r0 5

	call.j.sp sp __inp_6
	mov.r.r r1 re
	mov.r.r r0 r2
	out.r.p r0 5

	mov.r.r r0 r1
	out.r.p r0 6

	alu.r.i add r2 1
	alu.r.i add r3 1
	ld.r.i rc 1920
	cmp.r.f r2 rc
	jmp.c.j L l79
	ld.r.i r1 1920
l80:
	mov.r.r r0 r1
	out.r.p r0 5

	ld.r.i r0 0
	out.r.p r0 6

	alu.r.i add r1 1
	ld.r.i rc 2000
	cmp.r.f r1 rc
	jmp.c.j L l80
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
	push.r.sp r2 sp
	ld.r.p.off.bs r2 sp 8
	ld.r.i rc 10
	cmp.r.f r2 rc
	jmp.c.j GLgl l36
	ld.r.m.w ra l1+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l47
	ld.r.i ra 0
	st.r.m.w ra l1+0
	ld.r.m.w ra l2+0
	alu.r.i add ra 1
	st.r.m.w ra l2+0
	jmp.c.j LGlge l47
l36:
	ld.r.i rc 9
	cmp.r.f r2 rc
	jmp.c.j GLgl l41
	ld.r.m.w r4 l1+0
	mov.r.r r0 r4
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l43
	mov.r.r ra r4
	alu.r.i add ra 1
	st.r.m.w ra l1+0
l43:
	ld.r.m.w r0 l1+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l47
l85:
	ld.r.m.w r0 l1+0
	alu.r.i add r0 1
	st.r.m.w r0 l1+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l85
	jmp.c.j LGlge l47
l41:
	ld.r.m.w ra l1+0
	ld.r.i rc 80
	cmp.r.f ra rc
	jmp.c.j L l49
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
	call.j.sp sp _scroll
	ld.r.i ra 24
	st.r.m.w ra l2+0
	ld.r.i ra 0
	st.r.m.w ra l1+0
l51:
	ld.r.m.w r1 l2+0
	alu.r.i mul r1 80
	ld.r.m.w r0 l1+0
	alu.r.r add r0 r1
	out.r.p r0 5

	mov.r.r r0 r2
	out.r.p r0 6

	ld.r.m.w ra l1+0
	alu.r.i add ra 1
	st.r.m.w ra l1+0
l47:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_puts:
	.global	_puts
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	mov.r.r ra r1
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l90
l89:
	mov.r.r r0 r1
	ld.r.p.bs r0 r0
	alu.r.i add r1 1
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r ra r1
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l89
l90:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_hex:
	.global	_hex
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	mov.r.r r0 r1
	alu.r.i ursh r0 12
	alu.r.i band r0 15
	mov.r.r rc r0
	ld.r.ra r0 l67+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r1
	alu.r.i ursh r0 8
	alu.r.i band r0 15
	mov.r.r rc r0
	ld.r.ra r0 l67+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r1
	alu.r.i ursh r0 4
	alu.r.i band r0 15
	mov.r.r rc r0
	ld.r.ra r0 l67+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	mov.r.r r0 r1
	alu.r.i band r0 15
	mov.r.r rc r0
	ld.r.ra r0 l67+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	ld.r.i ra 10
	push.r.sp ra sp
	call.j.sp sp _putchar
	alu.r.i add sp 2
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_main:
	.global	_main
	ld.r.i ra 4084
	push.r.sp ra sp
	call.j.sp sp _hex
	alu.r.i add sp 2
l93:
	jmp.c.j LGlge l93
	ret.n.sp sp

	.data
_data:
	.global	_data
	.align
	.dc.w	_a

	.bss
	.extern	__inp_6

	.bss
	.extern	_a

	.data
l1:
	.align
	.dc.w	0

	.data
l2:
	.align
	.dc.w	24

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
;	End of VBCC generated section
	.module

