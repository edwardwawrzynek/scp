;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strlen:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
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
	lbpa	
	jpz 	$3
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
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
;	globl	strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:494
;	.end
