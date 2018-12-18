;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcmp:
$2:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	aequ	
	jpz 	$3
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$4
	lwia	#0
	jmp 	$1
$4:
	jmp 	$2
$3:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	popb	
	asub	
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
