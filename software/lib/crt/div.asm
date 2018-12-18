	.text
___crtudiv:
	.global	___crtudiv
	push.r.sp r0 sp
	push.r.sp r4 sp
	push.r.sp r5 sp
	push.r.sp r6 sp
	push.r.sp r7 sp
	push.r.sp r8 sp
	ld.r.p.off.w r8 sp 14
	ld.r.p.off.w r7 sp 16
	ld.r.i r6 0
	ld.r.i r4 0
	mov.r.r r0 r8
	alu.r.i sub r0 1
	mov.r.r r5 r0
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j e l18
l17:
	alu.r.i lsh r4 1
	mov.r.r r0 r8
	alu.r.r ursh r0 r5
	alu.r.i band r0 1
	mov.r.r r4 r0
	alu.r.r bor r4 r4
	cmp.r.f r4 r7
	jmp.c.j l l8
	alu.r.r sub r4 r7
	ld.r.i r0 1
	alu.r.r lsh r0 r5
	mov.r.r r6 r0
	alu.r.r bor r6 r6
l8:
	alu.r.i sub r5 1
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j GLgl l17
l18:
	mov.r.r re r6
	pop.r.sp r8 sp
	pop.r.sp r7 sp
	pop.r.sp r6 sp
	pop.r.sp r5 sp
	pop.r.sp r4 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
___crtsdiv:
	.global	___crtsdiv
	push.r.sp r0 sp
	push.r.sp r4 sp
	push.r.sp r5 sp
	push.r.sp r6 sp
	push.r.sp r7 sp
	push.r.sp r8 sp
	push.r.sp r9 sp
	ld.r.p.off.w r8 sp 16
	ld.r.p.off.w r7 sp 18
	ld.r.i r9 1
	ld.r.i rc 0
	cmp.r.f r8 rc
	jmp.c.j Ge l12
	ld.r.i r9 -1
	alu.r.r neg r8 ra
l12:
	ld.r.i rc 0
	cmp.r.f r7 rc
	jmp.c.j Ge l14
	mov.r.r r0 r9
	alu.r.r neg r0 ra
	mov.r.r r9 r0
	alu.r.r neg r7 ra
l14:
	ld.r.i r6 0
	ld.r.i r4 0
	mov.r.r r0 r8
	alu.r.i sub r0 1
	mov.r.r r5 r0
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j e l30
l29:
	alu.r.i lsh r4 1
	mov.r.r r0 r8
	alu.r.r ursh r0 r5
	alu.r.i band r0 1
	mov.r.r r4 r0
	alu.r.r bor r4 r4
	cmp.r.f r4 r7
	jmp.c.j l l26
	alu.r.r sub r4 r7
	ld.r.i r0 1
	alu.r.r lsh r0 r5
	mov.r.r r6 r0
	alu.r.r bor r6 r6
l26:
	alu.r.i sub r5 1
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j GLgl l29
l30:
	mov.r.r r0 r9
	alu.r.r mul r0 r6
	mov.r.r re r0
	pop.r.sp r9 sp
	pop.r.sp r8 sp
	pop.r.sp r7 sp
	pop.r.sp r6 sp
	pop.r.sp r5 sp
	pop.r.sp r4 sp
	pop.r.sp r0 sp
	ret.n.sp sp
;	End of VBCC generated section
	.module

