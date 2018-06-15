;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncpy:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aslt	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$2
$4:
	mspa	#10
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#10
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
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$6
$7:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aslt	
	jpz 	$8
	mspa	#10
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$7
$8:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
	mdsp	#0
$6:
	jmp 	$3
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	globl	strncpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
