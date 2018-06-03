;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
puts:
$2:
	mspa	#2
	lwpa	
	lbpa	
	asex	
	jpz 	$3
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
	mdsp	#0
	lwia	#10
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	puts
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:110
;	.end
