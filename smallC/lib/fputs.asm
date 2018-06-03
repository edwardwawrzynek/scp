;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
fputs:
$2:
	mspa	#4
	lwpa	
	lbpa	
	asex	
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
	mspa	#4
	lwpa	
	psha	
;	Arguments Passed: #2
	call	fputc
	mdsp	#4
	jmp 	$2
$3:
	mdsp	#0
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	fputs
;	extrn	fputc

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end
