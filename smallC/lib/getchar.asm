;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
getchar:
	lwia	#0
	psha	
;	Arguments Passed: #1
	call	fgetc
	mdsp	#2
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	getchar
;	extrn	fgetc

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end
