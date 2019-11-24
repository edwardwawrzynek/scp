	.text			; SCP Assembly Demo Program
	.align			; Prints "Hello SCP" and exits
	.extern _printf		; Author: Edward Wawrzynek
_main:				; Main function
	.global _main		; main has to be global for linker
	ld.r.ra r0 lmsg 	; load pointer to string
	push.r.sp r0 sp		; push pointer
	call.j.sp sp _printf	; call printf
	alu.r.i add sp 2	; remove argument from stack
	ld.r.i re 0		; set main return to 0
	ret.n.sp sp		; return
lmsg:				; string (readonly, can go in .text)
	.dc.bs 72		; H
	.dc.bs 101		; e
	.dc.bs 108		; l
	.dc.bs 108		; l
	.dc.bs 111		; o
	.dc.bs 32		;
	.dc.bs 83		; S
	.dc.bs 67		; C
	.dc.bs 80		; P
	.dc.bs 10		; Newline
	.dc.bs 0		; Null terminator
