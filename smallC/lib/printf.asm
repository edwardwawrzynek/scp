;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
printf:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
;	Arguments Passed: #2
	call	Xprintf
	mdsp	#4
$1:
	mdsp	#2
	ret 	
Xprintf:
	mspa	#2
	lwpa	
	psha	
;	Arguments Passed: #1
	call	puts
	mdsp	#2
	mspa	#4
	lwpa	
	psha	
	lwia	#0
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#10
	psha	
;	Arguments Passed: #2
	call	printn
	mdsp	#4
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#10
	psha	
;	Arguments Passed: #2
	call	printn
	mdsp	#4
	mspa	#4
	lwpa	
	psha	
	lwia	#2
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#10
	psha	
;	Arguments Passed: #2
	call	printn
	mdsp	#4
$2:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	printf
;	globl	Xprintf
;	extrn	puts
;	extrn	printn

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:103
;	.end
