;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncmp:
$2:
	mspa	#2
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	alng	
	jpz 	$4
	mspa	#6
	lwpa	
	lbpa	
	asex	
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
	aequ	
$4:
	aclv	
	jpz 	$3
	mspa	#6
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
	jpz 	$5
	lwia	#0
	jmp 	$1
	mdsp	#0
$5:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	lwia	#0
	jmp 	$7
$6:
	mspa	#6
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	asex	
	popb	
	asub	
$7:
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	strncmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
