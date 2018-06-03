;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
fgets:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	popb	
	swqa	
$2:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	xswp	
	asle	
	jpz 	$4
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
;	Arguments Passed: #1
	call	fgetc
	mdsp	#2
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	xswp	
	aslt	
$4:
	aclv	
	jpz 	$3
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#4
	lwpa	
	popb	
	sbqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$5
	mdsp	#0
	jmp 	$3
	mdsp	#0
$5:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt
	jpz 	$7
	mspa	#0
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	aequ	
$7:
	aclv	
	jpz 	$6
	lwia	#0
	jmp 	$1
	mdsp	#0
$6:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#10
	lwpa	
	jmp 	$1
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	globl	fgets
;	extrn	fgetc

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:68
;	.end
