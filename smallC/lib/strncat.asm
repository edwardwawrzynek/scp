;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncat:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
$2:
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	jpz 	$3
	jmp 	$2
$3:
	mdsp	#0
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
$4:
	mspa	#8
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
	asex	
	popb	
	sbqa	
	jpz 	$5
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mdsp	#0
	jmp 	$5
	mdsp	#0
$6:
	jmp 	$4
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strncat

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
