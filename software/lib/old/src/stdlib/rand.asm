;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
srand:
	mspa	#2
	lwpa	
	swma	xxseed
	mspa	#2
	lwpa	
	psha	
	lwia	#53562
	popb	
	abxr	
	swma	xxseed2
$1:
	ret 	
rand:
	lwma	xxseed
	psha	
	lwia	#5
	popb	
	amul	
	psha	
	lwia	#123
	popb	
	aadd	
	psha	
	lwia	#64060
	popb	
	abxr	
	psha	
	lwia	#21671
	popb	
	amul	
	psha	
	lwia	#2
	popb	
	assr	
	psha	
	lwma	xxseed2
	popb	
	aadd	
	psha	
	lwia	#41906
	popb	
	abxr	
	swma	xxseed
	lwma	xxseed2
	psha	
	lwia	#87
	popb	
	amul	
	psha	
	lwia	#54
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	ashl	
	psha	
	lwia	#9121
	psha	
	lwma	xxseed
	psha	
	lwia	#13393
	popb	
	abxr	
	psha	
	lwia	#20274
	popb	
	abnd	
	popb	
	amul	
	popb	
	abxr	
	swma	xxseed2
	lwma	xxseed
	psha	
	call	abs
	mdsp	#2
	jmp 	$2
$2:
	ret 	
;	Data Segment
;	globl	xxseed
xxseed:
	.dw	#0
;	globl	xxseed2
xxseed2:
	.dw	#0
;	globl	srand
;	globl	rand
;	extrn	abs

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:51
;	.end
