;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
index:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#10
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aneq	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$2
$4:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$6:
	mspa	#8
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aneq	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	aequ	
	popb	
	abnd	
	jpnz	$8
	jmp 	$9
$7:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$6
$8:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$7
$9:
	mdsp	#0
	mspa	#8
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$10
	mspa	#4
	lwpa	
	jmp 	$1
	mdsp	#0
$10:
	jmp 	$3
$5:
	mdsp	#0
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#6
	ret 	
;	Data Segment
;	globl	index

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:109
;	.end
