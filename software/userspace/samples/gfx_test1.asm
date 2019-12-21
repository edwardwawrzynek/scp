	.text
	.align
_rainbow:
	.global	_rainbow
	push.r.sp r0 sp
	ld.r.p.off.b r6 sp 4
	mov.r.r r0 r6
	mov.r.r rc r0
	ld.r.i r0 255
	alu.r.r sub r0 rc
	mov.r.r r6 r0
	mov.r.r r0 r6
	ld.r.i rc 85
	cmp.r.f r0 rc
	jmp.c.j Ge l4
	mov.r.r r0 r6
	alu.r.i mul r0 3
	mov.r.r re r0
	alu.r.i srsh re 6
	mov.r.r rc r0
	ld.r.i r0 255
	alu.r.r sub r0 rc
	alu.r.i srsh r0 5
	alu.r.i lsh r0 5
	alu.r.r add re r0
	jmp.c.j LGlge l1
l4:
	mov.r.r r0 r6
	ld.r.i rc 170
	cmp.r.f r0 rc
	jmp.c.j Ge l6
	mov.r.r r0 r6
	alu.r.i sub r0 85
	mov.r.r r6 r0
	mov.r.r r0 r6
	alu.r.i mul r0 3
	ld.r.i re 255
	alu.r.r sub re r0
	alu.r.i srsh re 6
	alu.r.i srsh r0 5
	alu.r.i lsh r0 2
	alu.r.r add re r0
	jmp.c.j LGlge l1
l6:
	mov.r.r r0 r6
	alu.r.i sub r0 170
	mov.r.r r6 r0
	mov.r.r r0 r6
	alu.r.i mul r0 3
	ld.r.i re 255
	alu.r.r sub re r0
	alu.r.i srsh re 5
	alu.r.i lsh re 2
	alu.r.i srsh r0 5
	alu.r.i lsh r0 5
	alu.r.r add re r0
l1:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	call.j.sp sp _getchar
	mov.r.r r0 re
	mov.r.r ra r0
	ld.r.i rc 2
	.extern ___crtsdiv
	call.j.sp sp ___crtsdiv
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l9+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	ld.r.i re 0
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l9:
	.dc.bs	37
	.dc.bs	105
	.dc.bs	10
	.dc.bs	0

	.bss
	.align
	.extern	_printf

	.bss
	.align
	.extern	_getchar
;	End of VBCC generated section
	.module

