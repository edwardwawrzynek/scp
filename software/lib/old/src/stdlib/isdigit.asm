;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_isdigit:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#48
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#57
	popb	
	asle	
	popb	
	abnd	
	jpz 	$2
	lwia	#1
	jmp 	$1
	jmp 	$3
$2:
	lwia	#0
	jmp 	$1
$3:
$1:
	ret 	
;	Data Segment
;	globl	_isdigit

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
