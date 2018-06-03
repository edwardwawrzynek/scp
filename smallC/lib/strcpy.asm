;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$2:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	popb	
	sbqa	
	jpz 	$3
	jmp 	$2
$3:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
;	.end
