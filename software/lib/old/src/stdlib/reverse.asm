;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_reverse:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mspa	#3
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#1
	psha	
	mspa	#9
	lwpa	
	psha	
	call	_strlen
	mdsp	#2
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
$2:
	mspa	#3
	lwpa	
	psha	
	mspa	#3
	lwpa	
	popb	
	aslt	
	jpz 	$3
	mspa	#0
	psha	
	mspa	#9
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#7
	lwpa	
	psha	
	mspa	#5
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#9
	lwpa	
	psha	
	mspa	#5
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#7
	lwpa	
	psha	
	mspa	#3
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#2
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#3
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	mspa	#1
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jmp 	$2
$3:
	mspa	#7
	lwpa	
	jmp 	$1
$1:
	mdsp	#5
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_reverse
;	extrn	_strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:494
;	.end
