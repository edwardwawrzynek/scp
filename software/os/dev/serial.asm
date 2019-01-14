	.text
	.align
l2:
	push.r.sp r0 sp
	alu.r.i sub sp 2
l5:
l6:
	call.j.sp sp __inp__serial_tx_busy_port
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l5
l7:
	ld.r.p.off.bs r0 sp 6
	st.r.p.?? ra sp
	mov.r.r ra r0
	call.j.sp sp __outp__serial_data_out_port
	ld.r.p.?? ra sp
	ld.r.i re 0
l3:
	alu.r.i add sp 2
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
l8:
	push.r.sp r0 sp
	alu.r.i sub sp 4
	call.j.sp sp __inp__serial_in_waiting_port
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l12
l11:
	ld.r.i re -2
	jmp.c.j LGlge l9
l12:
	call.j.sp sp __inp__serial_data_in_port
	mov.r.r r0 re
	st.r.p.bs r0 sp
	st.r.p.off.?? ra sp 2
	ld.r.i ra 1
	call.j.sp sp __outp__serial_next_port
	ld.r.p.off.?? ra sp 2
	ld.r.p.bs r0 sp
	mov.r.r re r0
l9:
	alu.r.i add sp 4
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
__serial_open:
	.global	__serial_open
	ld.r.p.off.w ra sp 2
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l16
	ld.r.i re 1
	jmp.c.j LGlge l13
l16:
	ld.r.i re 0
l13:
	ret.n.sp sp
	.text
	.align
__serial_close:
	.global	__serial_close
	ld.r.i re 0
l17:
	ret.n.sp sp
	.text
	.align
__serial_write:
	.global	__serial_write
	push.r.sp r0 sp
	alu.r.i sub sp 4
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	jmp.c.j LGlge l22
l21:
	ld.r.p.off.w ra sp 10
	alu.r.i add ra 1
	st.r.p.off.w ra sp 10
	ld.r.p.off.w ra sp 2
	alu.r.i add ra 1
	st.r.p.off.w ra sp 2
l22:
	ld.r.p.off.w ra sp 2
	ld.r.p.off.w rc sp 12
	cmp.r.f ra rc
	jmp.c.j e l23
l24:
	ld.r.p.off.w r0 sp 10
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	call.j.sp sp l2
	alu.r.i add sp 2
	st.r.p.w re sp
	ld.r.p.w ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j Ge l21
l23:
	ld.r.p.w ra sp
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j e l25
l27:
	ld.r.i r0 0
	jmp.c.j LGlge l26
l25:
	ld.r.i r0 1
l26:
	ld.r.p.off.w rc sp 14
	st.r.p.b r0 rc
	ld.r.p.off.w re sp 2
l19:
	alu.r.i add sp 4
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
__serial_read:
	.global	__serial_read
	push.r.sp r0 sp
	alu.r.i sub sp 4
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	jmp.c.j LGlge l31
l30:
	ld.r.p.w ra sp
	ld.r.p.off.w rc sp 10
	st.r.p.b ra rc
	ld.r.p.off.w ra sp 10
	alu.r.i add ra 1
	st.r.p.off.w ra sp 10
	ld.r.p.off.w ra sp 2
	alu.r.i add ra 1
	st.r.p.off.w ra sp 2
l31:
	ld.r.p.off.w ra sp 2
	ld.r.p.off.w rc sp 12
	cmp.r.f ra rc
	jmp.c.j e l32
l33:
	call.j.sp sp l8
	st.r.p.w re sp
	ld.r.p.w ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j Ge l30
l32:
	ld.r.p.w ra sp
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j e l34
l36:
	ld.r.i r0 0
	jmp.c.j LGlge l35
l34:
	ld.r.i r0 1
l35:
	ld.r.p.off.w rc sp 14
	st.r.p.b r0 rc
	ld.r.p.off.w re sp 2
l28:
	alu.r.i add sp 4
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.extern	__inp__serial_data_in_port

	.bss
	.extern	__outp__serial_next_port

	.bss
	.extern	__inp__serial_in_waiting_port

	.bss
	.extern	__outp__serial_data_out_port

	.bss
	.extern	__inp__serial_tx_busy_port

	.bss
l1:
	.ds	1
;	End of VBCC generated section
	.module

