;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcmp:
$2:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	popb	
	aequ	
	jpz 	$3
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$4
	lwia	#0
	jmp 	$1
	mdsp	#0
$4:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	asex	
	popb	
	asub	
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
