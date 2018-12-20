	.text
l1:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 4
	ld.r.i r1 0
	jmp.c.j LGlge l5
l4:
l8:
	mov.r.r r0 r1
	alu.r.i add r0 80
	out.r.p r0 5

l10:
l9:
	call.j.sp sp __inp_6
	mov.r.r r2 re
l12:
	mov.r.r r0 r1
	out.r.p r0 5

l14:
l13:
l16:
	mov.r.r r0 r2
	out.r.p r0 6

l18:
l17:
l7:
	alu.r.i add r1 1
l5:
	ld.r.i rc 1920
	cmp.r.f r1 rc
	jmp.c.j L l4
l6:
	ld.r.i r1 1920
	jmp.c.j LGlge l21
l20:
l24:
	mov.r.r r0 r1
	out.r.p r0 5

l26:
l25:
l28:
	ld.r.i r0 0
	out.r.p r0 6

l30:
l29:
l23:
	alu.r.i add r1 1
l21:
	ld.r.i rc 2000
	cmp.r.f r1 rc
	jmp.c.j L l20
l22:
l2:
	alu.r.i add sp 4
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
l32:
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.bs r2 sp 8
	mov.r.r r0 r2
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l36
l35:
	ld.r.m.b ra _tty+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l38
	ld.r.i ra 0
	st.r.m.b ra _tty+0
	ld.r.m.b ra _tty+1
	alu.r.i add ra 1
	st.r.m.b ra _tty+1
l38:
	jmp.c.j LGlge l39
l36:
	mov.r.r r0 r2
	ld.r.i rc 9
	cmp.r.f r0 rc
	jmp.c.j GLgl l41
l40:
	ld.r.m.b r0 _tty+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l43
l42:
	ld.r.m.b ra _tty+0
	alu.r.i add ra 1
	st.r.m.b ra _tty+0
l43:
	jmp.c.j LGlge l45
l44:
	ld.r.m.b ra _tty+0
	alu.r.i add ra 1
	st.r.m.b ra _tty+0
l45:
	ld.r.m.b r0 _tty+0
	alu.r.i band r0 7
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l44
l46:
	jmp.c.j LGlge l47
l41:
	ld.r.m.b r0 _tty+0
	ld.r.i rc 80
	cmp.r.f r0 rc
	jmp.c.j L l49
l48:
	ld.r.i ra 0
	st.r.m.b ra _tty+0
	ld.r.m.b ra _tty+1
	alu.r.i add ra 1
	st.r.m.b ra _tty+1
l49:
	ld.r.m.b r0 _tty+1
	ld.r.i rc 25
	cmp.r.f r0 rc
	jmp.c.j L l51
l50:
	call.j.sp sp l1
	ld.r.i ra 24
	st.r.m.b ra _tty+1
	ld.r.i ra 0
	st.r.m.b ra _tty+0
l51:
l52:
	ld.r.m.b r0 _tty+1
	alu.r.i mul r0 80
	ld.r.m.b r1 _tty+0
	alu.r.r add r0 r1
	out.r.p r0 5

l54:
l53:
l56:
	mov.r.r r0 r2
	out.r.p r0 6

l58:
l57:
	ld.r.m.b ra _tty+0
	alu.r.i add ra 1
	st.r.m.b ra _tty+0
l47:
l39:
	ld.r.i re 0
l33:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
__tty_open:
	.global	__tty_open
	ld.r.p.off.w r4 sp 2
	ld.r.i rc 0
	cmp.r.f r4 rc
	jmp.c.j e l63
	ld.r.i re 1
	jmp.c.j LGlge l60
l63:
	ld.r.i ra 0
	st.r.m.b ra _tty+0
	ld.r.i ra 0
	st.r.m.b ra _tty+1
	ld.r.i re 0
l60:
	ret.n.sp sp
	.text
__tty_close:
	.global	__tty_close
	ld.r.i re 0
l64:
	ret.n.sp sp
	.text
__tty_write:
	.global	__tty_write
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r2 sp 16
	ld.r.i r1 0
	jmp.c.j LGlge l70
l69:
	alu.r.i add r2 1
	alu.r.i add r1 1
l70:
	ld.r.p.off.w rc sp 18
	cmp.r.f r1 rc
	jmp.c.j e l71
l72:
	mov.r.r r0 r2
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	call.j.sp sp l32
	alu.r.i add sp 2
	mov.r.r r3 re
	ld.r.i rc -1
	cmp.r.f r3 rc
	jmp.c.j GLgl l69
l71:
	ld.r.i rc -1
	cmp.r.f r3 rc
	jmp.c.j GLgl l73
l75:
	ld.r.i r0 0
	jmp.c.j LGlge l74
l73:
	ld.r.i r0 1
l74:
	st.r.p.off.w r0 sp 20
	mov.r.r re r1
l67:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
_set:
	.global	_set
	ld.r.p.off.w r4 sp 2
	ld.r.i ra 2
	st.r.p.off.w ra sp 2
l76:
	ret.n.sp sp
	.text
_main:
	.global	_main
	push.r.sp r0 sp
	alu.r.i sub sp 2
	ld.r.i ra 8
	st.r.p.w ra sp
	mov.r.r r0 sp
	push.r.sp r0 sp
	call.j.sp sp _set
	alu.r.i add sp 2
	ld.r.p.w r0 sp
	alu.r.i add r0 48
	push.r.sp r0 sp
	call.j.sp sp l32
	alu.r.i add sp 2
	mov.r.r r0 re
l80:
	jmp.c.j LGlge l80
l82:
	ld.r.i re 0
l78:
	alu.r.i add sp 2
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
_msg:
	.global	_msg
	.align
	.dc.w	l66

	.bss
	.extern	__inp_6

	.bss
_tty:
	.global	_tty
	.ds	2

	.rodata
l66:
	.dc.bs	104
	.dc.bs	101
	.dc.bs	108
	.dc.bs	108
	.dc.bs	111
	.dc.bs	44
	.dc.bs	32
	.dc.bs	119
	.dc.bs	111
	.dc.bs	114
	.dc.bs	108
	.dc.bs	100
	.dc.bs	33
	.dc.bs	0
;	End of VBCC generated section
	.module

