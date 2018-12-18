;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
memchr:
$2:
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$3
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aneq	
	jpz 	$4
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$5
$4:
	mspa	#2
	lwpa	
	jmp 	$1
$5:
	jmp 	$2
$3:
	lwia	#0
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	memchr

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
