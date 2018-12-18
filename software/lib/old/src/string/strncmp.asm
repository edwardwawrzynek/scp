;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncmp:
$2:
	mspa	#6
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
$4:
	aclv	
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
	jpz 	$5
	lwia	#0
	jmp 	$1
$5:
	jmp 	$2
$3:
	mspa	#6
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	lwia	#0
	jmp 	$7
$6:
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
$7:
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	strncmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
