	.text
___crtudiv:
	.global	___crtudiv
	push.r.sp r0 sp
	push.r.sp r4 sp
	push.r.sp r5 sp
	push.r.sp r6 sp
	push.r.sp r7 sp
	push.r.sp r8 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r8 sp 20
	ld.r.p.off.w r7 sp 22
	ld.r.i r6 0
	ld.r.i r4 0
	ld.r.i r5 15
	jmp.c.j LGlge l4
l3:
	alu.r.i lsh r4 1
	mov.r.r r0 r8
	alu.r.r ursh r0 r5
	alu.r.i band r0 1
	alu.r.r bor r4 r0
	cmp.r.f r4 r7
	jmp.c.j l l8
l7:
	alu.r.r sub r4 r7
	ld.r.i r0 1
	alu.r.r lsh r0 r5
	alu.r.r bor r6 r0
l8:
l6:
	alu.r.i sub r5 1
l4:
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j GLgl l3
l5:
	mov.r.r re r6
l1:
	alu.r.i add sp 6
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
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 1
	ld.r.p.off.w r3 sp 11
	ld.r.i r2 1
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j Ge l12
l11:
	mov.r.r r0 r2
	alu.r.r neg r0 ra
	mov.r.r r2 r0
	alu.r.r neg r3 ra
l12:
	ld.r.p.off.w ra sp 13
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j Ge l14
l13:
	mov.r.r r0 r2
	alu.r.r neg r0 ra
	mov.r.r r2 r0
	ld.r.p.off.w ra sp 13
	alu.r.r neg ra ra
	st.r.p.off.w ra sp 13
l14:
	ld.r.p.off.w ra sp 13
	push.r.sp ra sp
	push.r.sp r3 sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.r mul r1 r0
	mov.r.r re r1
l9:
	alu.r.i add sp 1
	pop.r.sp r3 sp
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

