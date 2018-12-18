;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
shed_shedule:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwma	proc_current_proc
	lwib	#63
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	swqa	
$66:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$68
	jmp 	$69
$67:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$66
$68:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	jpz 	$71
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aequ	
$71:
	aclv	
	jpz 	$70
	lwia	#100
	psha	
	call	_int_reset_timer
	mdsp	#2
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	psha	
	call	proc_begin_execute
	mdsp	#2
$70:
	jmp 	$67
$69:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$72:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aule	
	jpnz	$74
	jmp 	$75
$73:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$72
$74:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	jpz 	$77
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aequ	
$77:
	aclv	
	jpz 	$76
	lwia	#100
	psha	
	call	_int_reset_timer
	mdsp	#2
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	psha	
	call	proc_begin_execute
	mdsp	#2
$76:
	jmp 	$73
$75:
	lwia	#13
	psha	
	call	panic
	mdsp	#2
$65:
	mdsp	#4
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	globl	shed_shedule
;	extrn	_int_reset_timer
;	extrn	proc_begin_execute
;	extrn	panic

;	0 error(s) in compilation
;	literal pool:0
;	global pool:11
;	Macro pool:51
;	.end
