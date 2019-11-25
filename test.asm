	.text
	.align
_START:
	.global _START
	nop.n.n
	ld.r.ra r0 ll1
	alu.r.i add r0 4
	jmp.c.r GLgle r0

lhang1:
	jmp.c.j GLgle lhang1


ll1:
	jmp.c.j GLgle lhang1

	ld.r.ra r0 ldata
	ld.r.i r1 5
	st.r.p.off.b r1 r0 1
	ld.r.m.b rf ldata1
	out.r.p rf 0

lhang2:
	jmp.c.j GLgle lhang2

	.data
	.align
ldata:
	.dc.b 0
ldata1:
	.dc.b 0





