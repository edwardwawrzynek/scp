;	SCP Assembly Demo Program
	.text
	.align
	.extern _printf
_main:				; Main function
	.global _main
	ld.r.ra r0 _msg 	; load pointer to function
	push.r.sp r0 sp		; push pointer
	call.j.sp sp _printf	; call printf
	alu.r.i add sp 2	; remove argument from stack
	ld.r.i re 0		; set main return to 0
	ret.n.sp sp		; return
_msg:
	.dc.bs 72		; H
	.dc.bs 101		; e
	.dc.bs 108		; l
	.dc.bs 108		; l
	.dc.bs 111		; o
	.dc.bs 32		;
	.dc.bs 83		; S
	.dc.bs 67		; C
	.dc.bs 80		; P
	.dc.bs 0		; Null terminator
