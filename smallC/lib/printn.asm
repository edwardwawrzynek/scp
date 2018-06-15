;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
printn:
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#0
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#10
	popb	
	aequ	
	psha	
	lwib	#4
	call	Xprintn
	mdsp	#8
$1:
	mdsp	#0
	ret 	
Xprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#12
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#10
	popb	
	aequ	
	popb	
	abnd	
	jpz 	$3
	lwia	#45
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mspa	#12
	psha	
	mspa	#14
	lwpa	
	aneg	
	popb	
	swqa	
	mdsp	#0
$3:
	mspa	#2
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#14
	lwpa	
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$4
	mspa	#2
	lwpa	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	psha	
	lwib	#4
	call	printn
	mdsp	#8
	mdsp	#0
$4:
	mspa	#8
	lwpa	
	jpz 	$5
	mspa	#0
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mdsp	#0
	jmp 	$6
$5:
	mspa	#0
	psha	
	lwia	$0+#17
	popb	
	swqa	
	mdsp	#0
$6:
	mspa	#0
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#14
	lwpa	
	popb	
	call	ccdiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
$2:
	mdsp	#4
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#65,#66,#67,#68,#69,#70
	.db	#0,#48,#49,#50,#51,#52,#53,#54
	.db	#55,#56,#57,#97,#98,#99,#100,#101
	.db	#102,#0
;	globl	printn
;	globl	Xprintn
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:34
;	global pool:3
;	Macro pool:157
;	.end
