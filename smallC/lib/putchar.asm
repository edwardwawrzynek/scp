;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
putchar:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#1
	psha	
;	Arguments Passed: #2
	call	fputc
	mdsp	#4
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	putchar
;	extrn	fputc

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end
