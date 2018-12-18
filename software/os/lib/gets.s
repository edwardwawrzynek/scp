;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_gets:
	mdsp	#-1
	mdsp	#-2
	mdsp	#-1
	mspa	#0
	psha	
	lbma	_getcharecho
	popb	
	sbqa	
	lwia	#0
	sbma	_getcharecho
	mspa	#1
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$3:
	mspa	#3
	psha	
	call	getchar
	popb	
	sbqa	
	psha	
	mspa	#10
	lbpa	
	asex	
	popb	
	aneq	
	jpz 	$5
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aneq	
$5:
	aclv	
	jpz 	$4
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$6
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$7
	mspa	#1
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lwia	#8
	psha	
	call	putchar
	mdsp	#2
$7:
	jmp 	$8
$6:
	mspa	#3
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
	mspa	#1
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#5
	lbpa	
	asex	
	popb	
	sbqa	
$8:
	jmp 	$3
$4:
	mspa	#0
	lbpa	
	sbma	_getcharecho
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpz 	$10
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aequ	
$10:
	aclv	
	jpz 	$9
	lwia	#0
	jmp 	$2
$9:
	mspa	#1
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#6
	lwpa	
	jmp 	$2
$2:
	mdsp	#4
	ret 	
gets:
	lwia	#10
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_gets
	mdsp	#4
	jmp 	$11
$11:
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_gets
;	extrn	getchar
;	extrn	putchar
;	globl	gets

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
;	.end
