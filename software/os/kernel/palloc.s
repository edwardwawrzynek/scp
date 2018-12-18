;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
palloc_new:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$37:
	mspa	#0
	lwpa	
	psha	
	lwia	#64
	popb	
	ault	
	jpnz	$39
	jmp 	$40
$38:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$37
$39:
	lwia	palloc_page_in_use
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	alng	
	jpz 	$41
	lwia	palloc_page_in_use
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#128
	popb	
	abor	
	jmp 	$36
$41:
	jmp 	$38
$40:
	lwia	#10
	psha	
	call	panic
	mdsp	#2
$36:
	mdsp	#2
	ret 	
palloc_free:
	lwia	palloc_page_in_use
	psha	
	mspa	#4
	lbpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
$42:
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	palloc_page_in_use
palloc_page_in_use:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0
;	globl	palloc_new
;	extrn	panic
;	globl	palloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
;	.end
