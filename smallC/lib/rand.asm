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
getrand:
	lwia	$0+#0
	psha	
;	Arguments Passed: #1
	call	puts
	mdsp	#2
;	Arguments Passed: #0
	call	getchar
	mdsp	#0
	psha	
	lwia	#123
	popb	
	amul	
	jmp 	$4
$4:
	mdsp	#0
	ret 	
;	Data Segment
$0:	.db	#84,#121,#112,#101,#32,#97,#32,#99
	.db	#104,#97,#114,#97,#99,#116,#101,#114
	.db	#0
;	globl	xxseed
xxseed:
	.dw	#0
;	globl	srand
;	globl	rand
;	globl	getrand
;	extrn	puts
;	extrn	getchar

;	0 error(s) in compilation
;	literal pool:17
;	global pool:6
;	Macro pool:51
;	.end
