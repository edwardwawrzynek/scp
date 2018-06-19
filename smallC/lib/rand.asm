;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
srand:
	mspa	#2
	lwpa	
	swma	xxseed
$1:
	mdsp	#0
	ret 	
rand:
	lwma	xxseed
	psha	
	lwia	#251
	popb	
	amul	
	psha	
	lwia	#123
	popb	
	aadd	
	swma	xxseed
	lwma	xxseed
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$3
	lwma	xxseed
	aneg	
	swma	xxseed
	mdsp	#0
$3:
	lwma	xxseed
	jmp 	$2
$2:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	xxseed
xxseed:
	.dw	#0
;	globl	srand
;	globl	rand

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:51
;	.end
