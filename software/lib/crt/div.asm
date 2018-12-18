	.text
___crtsdiv:
	.global	___crtsdiv
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r5 sp 10
	ld.r.p.off.w r4 sp 8
	ld.r.i r2 1
	ld.r.i rc 0
	cmp.r.f r4 rc
	jmp.c.j Ge l12
	ld.r.i r2 -1
	alu.r.r neg r4 ra
l12:
	ld.r.i rc 0
	cmp.r.f r5 rc
	jmp.c.j Ge l14
	mov.r.r r0 r2
	alu.r.r neg r0 ra
	mov.r.r r2 r0
	alu.r.r neg r5 ra
l14:
	mov.r.r r0 r5
	push.r.sp r0 sp
	mov.r.r r0 r4
	push.r.sp r0 sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.r mul r0 r1
	mov.r.r re r0
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
___crtudiv:
	.global	___crtudiv
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r8 sp 10
	ld.r.i r6 0
	ld.r.i r4 0
	ld.r.i r5 15
l17:
	alu.r.i lsh r4 1
	ld.r.p.off.w r0 sp 8
	alu.r.r ursh r0 r5
	alu.r.i band r0 1
	mov.r.r r1 r4
	alu.r.r bor r0 r1
	mov.r.r r4 r0
	mov.r.r r2 r4
	cmp.r.f r2 r8
	jmp.c.j l l8
	mov.r.r r0 r2
	alu.r.r sub r0 r8
	mov.r.r r4 r0
	ld.r.i r0 1
	alu.r.r lsh r0 r5
	alu.r.r bor r6 r0
l8:
	alu.r.i sub r5 1
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j GLgl l17
	mov.r.r r0 r6
	mov.r.r re r0
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.extern	___crtsdiv

	.bss
	.extern	___crtudiv
;	End of VBCC generated section
	.module

