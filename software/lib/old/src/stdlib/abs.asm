;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
abs:
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	mspa	#2
	lwpa	
	aneg	
	jmp 	$1
	jmp 	$3
$2:
	mspa	#2
	lwpa	
	jmp 	$1
$3:
$1:
	ret 	
;	Data Segment
;	globl	abs

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end