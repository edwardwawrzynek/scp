;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strchr:
$2:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aneq	
	jpz 	$3
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	alng	
	jpz 	$4
	lwia	#0
	jmp 	$1
$4:
	jmp 	$2
$3:
	mspa	#2
	lwpa	
	jmp 	$1
$1:
	ret 	
strcmp:
$6:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	aequ	
	jpz 	$7
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$8
	lwia	#0
	jmp 	$5
$8:
	jmp 	$6
$7:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	popb	
	asub	
	jmp 	$5
$5:
	ret 	
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$10:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	jpz 	$11
	jmp 	$10
$11:
	mspa	#0
	lwpa	
	jmp 	$9
$9:
	mdsp	#2
	ret 	
memcmp:
$13:
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$14
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	aneq	
	jpz 	$15
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	asub	
	jmp 	$12
$15:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$13
$14:
	lwia	#0
	jmp 	$12
$12:
	ret 	
memcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$17:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$18
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	jmp 	$17
$18:
	mspa	#4
	lwpa	
	jmp 	$16
$16:
	mdsp	#2
	ret 	
memset:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$20:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$21
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	lbpa	
	popb	
	sbqa	
	jmp 	$20
$21:
	mspa	#4
	lwpa	
	jmp 	$19
$19:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strchr
;	globl	strcmp
;	globl	strcpy
;	globl	memcmp
;	globl	memcpy
;	globl	memset

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end
