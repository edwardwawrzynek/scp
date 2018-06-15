;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
printf:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	swpb	
	mspa	#0
	lwpa	
	psha	
	lwia	#10
	psha	
	lwib	#2
	call	printn
	mdsp	#4
$1:
	mdsp	#6
	ret 	
;	Data Segment
;	globl	printf
;	extrn	printn

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end
