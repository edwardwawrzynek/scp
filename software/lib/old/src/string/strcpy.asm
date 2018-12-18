;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$2:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	jpz 	$3
	jmp 	$2
$3:
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	strcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:494
;	.end
