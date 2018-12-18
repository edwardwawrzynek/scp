;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
itoa:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
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
	lwia	#0
	popb	
	swqa	
$3:
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccdiv
	xswp	
	psha	
	lwia	#48
	popb	
	aadd	
	popb	
	sbqa	
$4:
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpnz	$3
$5:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	lwia	#45
	popb	
	sbqa	
$6:
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#8
	lwpa	
	psha	
	call	_reverse
	mdsp	#2
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	itoa
;	extrn	_reverse

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:500
;	.end
