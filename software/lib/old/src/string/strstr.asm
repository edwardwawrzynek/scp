;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strstr:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	psha	
	call	strlen
	mdsp	#2
	popb	
	swqa	
$2:
	mspa	#4
	lwpa	
	lbpa	
	jpz 	$3
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	call	memcmp
	mdsp	#6
	alng	
	jpz 	$4
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	jmp 	$1
$4:
	jmp 	$2
$3:
	lwia	#0
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strstr
;	extrn	strlen
;	extrn	memcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:51
;	.end
