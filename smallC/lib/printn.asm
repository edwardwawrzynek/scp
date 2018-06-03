;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
printn:
	mdsp	#-2
	mdsp	#-2
	mspa	#10
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#10
	popb	
	aequ	
	popb	
	abnd	
	jpz 	$2
	lwia	#45
	psha	
	mspa	#8
	lwpa	
	psha	
;	Arguments Passed: #2
	call	fputc
	mdsp	#4
	mspa	#10
	psha	
	mspa	#12
	lwpa	
	aneg	
	popb	
	swqa	
	mdsp	#0
$2:
	mspa	#2
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$3
	mspa	#2
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
;	Arguments Passed: #3
	call	printn
	mdsp	#6
	mdsp	#0
$3:
	mspa	#0
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	mspa	#8
	lwpa	
	psha	
;	Arguments Passed: #2
	call	fputc
	mdsp	#4
$1:
	mdsp	#4
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#65,#66,#67,#68,#69,#70
	.db	#0
;	globl	printn
;	extrn	fputc

;	0 error(s) in compilation
;	literal pool:17
;	global pool:2
;	Macro pool:129
;	.end
