;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
gets:
	mdsp	#-1
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#7
	lwpa	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
;	Arguments Passed: #0
	call	getchar
	mdsp	#0
	popb	
	sbqa	
	psha	
	lwia	#10
	popb	
	aneq	
	jpz 	$4
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aneq	
$4:
	aclv	
	jpz 	$3
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$5
	mspa	#0
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	xswp	
	aule	
	jpz 	$6
	mspa	#0
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lwia	#32
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
	lwia	#8
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
	mdsp	#0
$6:
	mdsp	#0
	jmp 	$7
$5:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#21
	popb	
	aequ	
	jpz 	$8
	mspa	#0
	psha	
	mspa	#7
	lwpa	
	popb	
	swqa	
	lwia	#10
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
	lwia	#35
	psha	
;	Arguments Passed: #1
	call	putchar
	mdsp	#2
	mdsp	#0
	jmp 	$9
$8:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#4
	lbpa	
	asex	
	popb	
	sbqa	
	mdsp	#0
$9:
	mdsp	#0
$7:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpz 	$11
	mspa	#0
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	aequ	
$11:
	aclv	
	jpz 	$10
	lwia	#0
	jmp 	$1
	mdsp	#0
$10:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#5
	lwpa	
	jmp 	$1
$1:
	mdsp	#3
	ret 	
;	Data Segment
;	globl	gets
;	extrn	getchar
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:128
;	.end
