;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_gets:
	mdsp	#-1
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#9
	lwpa	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
	lwib	#0
	call	getchar
	mdsp	#0
	popb	
	sbqa	
	psha	
	mspa	#7
	lbpa	
	asex	
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
	mspa	#9
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$6
	mspa	#0
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	mdsp	#0
$6:
	mdsp	#0
	jmp 	$7
$5:
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
	jpz 	$9
	mspa	#0
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	aequ	
$9:
	aclv	
	jpz 	$8
	lwia	#0
	jmp 	$1
	mdsp	#0
$8:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#7
	lwpa	
	jmp 	$1
$1:
	mdsp	#3
	ret 	
gets:
	mspa	#2
	lwpa	
	psha	
	lwia	#10
	psha	
	lwib	#2
	call	_gets
	mdsp	#4
	jmp 	$10
$10:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	_gets
;	extrn	getchar
;	globl	gets

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:117
;	.end
