;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
binary:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
$2:
	mspa	#6
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	asle	
	jpz 	$3
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	call	ccdiv
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#16
	lwpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
;	Arguments Passed: #2
	call	strcmp
	mdsp	#4
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$4
	mspa	#4
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
	mdsp	#0
	jmp 	$5
$4:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpz 	$6
	mspa	#6
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	swqa	
	mdsp	#0
	jmp 	$7
$6:
	mspa	#2
	lwpa	
	jmp 	$1
	mdsp	#0
$7:
	mdsp	#0
$5:
	jmp 	$2
$3:
	mdsp	#0
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#8
	ret 	
;	Data Segment
;	globl	binary
;	extrn	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end
