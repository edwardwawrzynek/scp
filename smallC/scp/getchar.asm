;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
getchar:
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	getchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
;	.end
