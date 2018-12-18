	.module	SMALLC_GENERATED
gfx_pixel:
	bspl	#2
	psha	
	bspa	#6
	lwpb	
	lwia	#320
	amul	
	popb	
	aadd	
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#6
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
$1:
	ret 	
gfx_rgb:
	bspa	#2
	lbpb	
	lbia	#5
	ashr	
	xswp	
	lbia	#5
	ashl	
	psha	
	bspa	#6
	lbpb	
	lbia	#5
	ashr	
	xswp	
	lbia	#2
	ashl	
	popb	
	aadd	
	psha	
	bspa	#8
	lbpb	
	lbia	#6
	ashr	
	popb	
	aadd	
	jmp 	$2
$2:
	ret 	
gfx_sync:
$4:
	lbia	#12
	psha	
	call	inp
	bdsp	#2
	jpz 	$5
	jmp 	$4
$5:
$3:
	ret 	
gfx_background:
	mdsp	#-2
	bspa	#0
	lbib	#0
	swpb	
$7:
	bspa	#0
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#4
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
$8:
	bspl	#0
	jpnz	$7
$9:
$6:
	bdsp	#2
	ret 	
gfx_clearscreen:
	lbia	#0
	psha	
	call	gfx_background
	bdsp	#2
$10:
	ret 	
gfx_text:
	mdsp	#-2
	bspa	#0
	xswp	
	bspl	#6
	swqa	
$12:
	bspl	#4
	lbpa	
	asex	
	jpz 	$13
	bspl	#4
	lbpa	
	asex	
	xswp	
	lbia	#10
	aequ	
	jpz 	$14
	bspa	#8
	xswp	
	lwqa	
	inca	
	swqa	
	bspa	#6
	xswp	
	bspl	#0
	swqa	
	bspa	#4
	xswp	
	lwqa	
	inca	
	swqa	
	jmp 	$15
$14:
	bspa	#6
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	psha	
	bspa	#10
	lwpb	
	lbia	#80
	amul	
	popb	
	aadd	
	psha	
	lbia	#5
	psha	
	call	outp
	bdsp	#4
	bspa	#4
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lbia	#6
	psha	
	call	outp
	bdsp	#4
$15:
	jmp 	$12
$13:
$11:
	bdsp	#2
	ret 	
gfx_blit_buffer:
	mdsp	#-6
	bspa	#2
	psha	
	bspa	#12
	lwpb	
	bspl	#16
	aadd	
	popb	
	swqa	
	bspa	#0
	psha	
	bspa	#14
	lwpb	
	bspl	#18
	aadd	
	popb	
	swqa	
	bspa	#4
	psha	
	bspa	#14
	lwpb	
	lwia	#320
	amul	
	xswp	
	bspl	#12
	aadd	
	popb	
	swqa	
$17:
	lbia	#1
	jpz 	$18
	bspa	#10
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	bspa	#4
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	bspa	#10
	lwpb	
	bspl	#2
	ault	
	alng	
	jpz 	$19
	bspa	#10
	psha	
	lwpb	
	bspl	#16
	asub	
	popb	
	swqa	
	bspa	#12
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	bspa	#4
	psha	
	lwpa	
	psha	
	lwib	#320
	bspl	#18
	asub	
	popb	
	aadd	
	popb	
	swqa	
	bspa	#12
	lwpb	
	bspl	#0
	ault	
	alng	
	jpz 	$20
	jmp 	$16
$20:
$19:
	bspl	#4
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#8
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
	jmp 	$17
$18:
$16:
	bdsp	#6
	ret 	
gfx_horiz_line:
	mdsp	#-2
	bspa	#0
	psha	
	bspa	#6
	lwpb	
	bspl	#10
	aadd	
	popb	
	swqa	
$22:
	bspa	#4
	lwpb	
	bspl	#0
	ault	
	jpz 	$23
	bspa	#4
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	psha	
	bspa	#8
	lwpb	
	lwia	#320
	amul	
	popb	
	aadd	
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#10
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
	jmp 	$22
$23:
$21:
	bdsp	#2
	ret 	
gfx_vert_line:
	mdsp	#-2
	bspa	#0
	psha	
	bspa	#8
	lwpb	
	bspl	#10
	aadd	
	popb	
	swqa	
$25:
	bspa	#6
	lwpb	
	bspl	#0
	ault	
	jpz 	$26
	bspl	#4
	psha	
	bspa	#8
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	xswp	
	lwia	#320
	amul	
	popb	
	aadd	
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#10
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
	jmp 	$25
$26:
$24:
	bdsp	#2
	ret 	
gfx_rect_fill:
	mdsp	#-4
	bspa	#2
	psha	
	bspa	#8
	lwpb	
	bspl	#12
	aadd	
	popb	
	swqa	
	bspa	#0
	psha	
	bspa	#10
	lwpb	
	bspl	#14
	aadd	
	popb	
	swqa	
$28:
	lbia	#1
	jpz 	$29
	bspa	#6
	lwpb	
	bspl	#2
	ault	
	alng	
	jpz 	$30
	bspa	#6
	psha	
	lwpb	
	bspl	#12
	asub	
	popb	
	swqa	
	bspa	#8
	xswp	
	lwqa	
	inca	
	swqa	
	bspa	#8
	lwpb	
	bspl	#0
	ault	
	alng	
	jpz 	$31
	jmp 	$29
$31:
$30:
	bspa	#6
	xswp	
	lwqa	
	inca	
	swqa	
	deca	
	psha	
	bspa	#10
	lwpb	
	lwia	#320
	amul	
	popb	
	aadd	
	psha	
	lbia	#9
	psha	
	call	outp
	bdsp	#4
	bspa	#14
	lbpa	
	psha	
	lbia	#10
	psha	
	call	outp
	bdsp	#4
	jmp 	$28
$29:
$27:
	bdsp	#4
	ret 	
gfx_rect_stroke:
	bspa	#10
	lbpa	
	psha	
	bspl	#8
	psha	
	bspl	#8
	psha	
	bspl	#8
	psha	
	call	gfx_horiz_line
	bdsp	#8
	bspa	#10
	lbpa	
	psha	
	bspl	#10
	psha	
	bspl	#8
	psha	
	bspl	#8
	psha	
	call	gfx_vert_line
	bdsp	#8
	bspa	#10
	lbpa	
	psha	
	bspl	#8
	psha	
	bspa	#8
	lwpb	
	bspl	#12
	aadd	
	xswp	
	lbia	#1
	asub	
	psha	
	bspl	#8
	psha	
	call	gfx_horiz_line
	bdsp	#8
	bspa	#10
	lbpa	
	psha	
	bspl	#10
	psha	
	bspl	#8
	psha	
	bspa	#8
	lwpb	
	bspl	#12
	aadd	
	xswp	
	lbia	#1
	asub	
	psha	
	call	gfx_vert_line
	bdsp	#8
$32:
	ret 	
gfx_line:
	mdsp	#-4
	bspa	#2
	psha	
	bspa	#12
	lwpb	
	bspl	#8
	asub	
	popb	
	swqa	
	bspa	#2
	lwpb	
	lbia	#0
	aslt	
	jpz 	$34
	bspa	#14
	lbpa	
	psha	
	bspl	#10
	psha	
	bspl	#10
	psha	
	bspl	#18
	psha	
	bspl	#18
	psha	
	call	gfx_line
	bdsp	#10
$34:
	bspa	#0
	psha	
	bspa	#14
	lwpb	
	bspl	#10
	asub	
	popb	
	swqa	
	bspl	#2
	psha	
	call	_abs
	bdsp	#2
	psha	
	bspl	#2
	psha	
	call	_abs
	bdsp	#2
	popb	
	asle	
	alng	
	jpz 	$35
	lbia	#0
	psha	
	bspa	#16
	lbpa	
	psha	
	bspl	#16
	psha	
	bspl	#16
	psha	
	bspl	#16
	psha	
	bspl	#16
	psha	
	call	_gfx_line
	bdsp	#12
	jmp 	$36
$35:
	bspa	#0
	lwpb	
	lbia	#0
	asle	
	alng	
	jpz 	$37
	lbia	#1
	psha	
	bspa	#16
	lbpa	
	psha	
	bspl	#14
	psha	
	bspl	#18
	psha	
	bspl	#14
	psha	
	bspl	#18
	psha	
	call	_gfx_line
	bdsp	#12
	jmp 	$38
$37:
	lbia	#1
	psha	
	bspa	#16
	lbpa	
	psha	
	bspl	#10
	psha	
	bspl	#14
	psha	
	bspl	#18
	psha	
	bspl	#22
	psha	
	call	_gfx_line
	bdsp	#12
$38:
$36:
$33:
	bdsp	#4
	ret 	
_gfx_line:
	mdsp	#-16
	bspa	#6
	lbib	#1
	swpb	
	bspa	#12
	psha	
	bspa	#24
	lwpb	
	bspl	#20
	asub	
	popb	
	swqa	
	bspa	#14
	psha	
	bspa	#26
	lwpb	
	bspl	#22
	asub	
	popb	
	swqa	
	bspa	#14
	lwpb	
	lbia	#0
	aslt	
	jpz 	$40
	bspa	#6
	psha	
	lbia	#1
	aneg	
	popb	
	swqa	
	bspa	#14
	psha	
	bspa	#22
	lwpb	
	bspl	#26
	asub	
	popb	
	swqa	
$40:
	bspa	#4
	psha	
	lbib	#2
	bspl	#16
	amul	
	xswp	
	bspl	#14
	asub	
	popb	
	swqa	
	bspa	#10
	psha	
	lbib	#2
	bspl	#16
	amul	
	popb	
	swqa	
	bspa	#8
	psha	
	lbia	#2
	psha	
	bspa	#18
	lwpb	
	bspl	#16
	asub	
	popb	
	amul	
	popb	
	swqa	
	bspa	#2
	xswp	
	bspl	#18
	swqa	
	bspa	#0
	xswp	
	bspl	#20
	swqa	
	bspa	#28
	lbpa	
	jpz 	$41
	bspa	#26
	lbpa	
	psha	
	bspl	#4
	psha	
	bspl	#4
	psha	
	call	gfx_pixel
	bdsp	#6
	jmp 	$42
$41:
	bspa	#26
	lbpa	
	psha	
	bspl	#2
	psha	
	bspl	#6
	psha	
	call	gfx_pixel
	bdsp	#6
$42:
$43:
	bspa	#2
	lwpb	
	bspl	#22
	ault	
	jpz 	$44
	bspa	#4
	lwpb	
	lbia	#0
	asle	
	jpz 	$45
	bspa	#4
	psha	
	lwpb	
	bspl	#12
	aadd	
	popb	
	swqa	
	bspa	#2
	xswp	
	lwqa	
	inca	
	swqa	
	jmp 	$46
$45:
	bspa	#4
	psha	
	lwpb	
	bspl	#10
	aadd	
	popb	
	swqa	
	bspa	#2
	xswp	
	lwqa	
	inca	
	swqa	
	bspa	#0
	psha	
	lwpb	
	bspl	#8
	aadd	
	popb	
	swqa	
$46:
	bspa	#28
	lbpa	
	jpz 	$47
	bspa	#26
	lbpa	
	psha	
	bspl	#4
	psha	
	bspl	#4
	psha	
	call	gfx_pixel
	bdsp	#6
	jmp 	$48
$47:
	bspa	#26
	lbpa	
	psha	
	bspl	#2
	psha	
	bspl	#6
	psha	
	call	gfx_pixel
	bdsp	#6
$48:
	jmp 	$43
$44:
$39:
	bdsp	#16
	ret 	
gfx_triangle_stroke:
	bspa	#14
	lbpa	
	psha	
	bspl	#10
	psha	
	bspl	#10
	psha	
	bspl	#10
	psha	
	bspl	#10
	psha	
	call	gfx_line
	bdsp	#10
	bspa	#14
	lbpa	
	psha	
	bspl	#14
	psha	
	bspl	#14
	psha	
	bspl	#10
	psha	
	bspl	#10
	psha	
	call	gfx_line
	bdsp	#10
	bspa	#14
	lbpa	
	psha	
	bspl	#14
	psha	
	bspl	#14
	psha	
	bspl	#14
	psha	
	bspl	#14
	psha	
	call	gfx_line
	bdsp	#10
$49:
	ret 	
_abs:
	bspa	#2
	lwpb	
	lbia	#0
	aslt	
	jpz 	$51
	bspl	#2
	aneg	
	jmp 	$50
	jmp 	$52
$51:
	bspl	#2
	jmp 	$50
$52:
$50:
	ret 	
;	optimizer end
