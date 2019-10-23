	.text
	.align
_error:
	.global	_error
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	ld.r.ra ra _line+0
	push.r.sp ra sp
	push.r.sp r1 sp
	ld.r.ra ra l3+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i ra 1
	push.r.sp ra sp
	call.j.sp sp _exit
	alu.r.i add sp 2
	mov.r.r r0 re
l1:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l3:
	.dc.bs	10
	.dc.bs	115
	.dc.bs	99
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	109
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
	.dc.bs	65
	.dc.bs	116
	.dc.bs	58
	.dc.bs	10
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_read_byte:
	.global	_read_byte
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 2
l6:
	ld.r.m.w r0 _cur_in_file+0
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l10
l9:
	ld.r.i re -1
	jmp.c.j LGlge l4
l10:
	ld.r.m.w r0 _cur_in_file+0
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r2 re
	ld.r.m.w r0 _cur_in_file+0
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _feof
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l12
	ld.r.m.w ra _cur_in_file+0
	alu.r.i add ra 1
	st.r.m.w ra _cur_in_file+0
	jmp.c.j LGlge l13
l12:
	jmp.c.j LGlge l8
l13:
	jmp.c.j LGlge l6
l8:
	mov.r.r re r2
l4:
	alu.r.i add sp 2
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_reset_file:
	.global	_reset_file
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 2
	ld.r.i r2 0
	jmp.c.j LGlge l17
l16:
	ld.r.i ra 1
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	mov.r.r r0 re
	alu.r.i add r2 1
l17:
	mov.r.r r0 r2
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l16
l18:
	ld.r.i ra 0
	st.r.m.w ra _cur_in_file+0
l14:
	alu.r.i add sp 2
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
	.align
_do_debug:
	.global	_do_debug
	.dc.bs	0

	.data
	.align
_cur_in_file:
	.global	_cur_in_file
	.align
	.dc.w	0

	.bss
	.align
	.extern	_fgetc

	.bss
	.align
	.extern	_fseek

	.bss
	.align
	.extern	_feof

	.bss
	.align
	.extern	_printf

	.bss
	.align
_line:
	.global	_line
	.ds	81

	.bss
	.align
_lptr:
	.global	_lptr
	.align
	.ds	2

	.bss
	.align
_debug_file:
	.global	_debug_file
	.align
	.ds	2

	.bss
	.align
_in_files:
	.global	_in_files
	.align
	.ds	100

	.bss
	.align
_out:
	.global	_out
	.align
	.ds	42

	.bss
	.align
	.extern	_exit
;	End of VBCC generated section
	.module

