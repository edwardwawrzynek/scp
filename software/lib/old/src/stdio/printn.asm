;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_sprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	lwia	#45
	psha	
	call	putchar
	mdsp	#2
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	aneg	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$3
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_sprintn
	mdsp	#4
$3:
	mspa	#0
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$1:
	mdsp	#4
	ret 	
_uprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccudiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$5
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
$5:
	mspa	#0
	psha	
	lwia	$0+#17
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccudiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$4:
	mdsp	#4
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#97,#98,#99,#100,#101,#102
	.db	#0,#48,#49,#50,#51,#52,#53,#54
	.db	#55,#56,#57,#97,#98,#99,#100,#101
	.db	#102,#0
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_sprintn
;	extrn	putchar
;	globl	_uprintn

;	0 error(s) in compilation
;	literal pool:34
;	global pool:6
;	Macro pool:520
;	.end
