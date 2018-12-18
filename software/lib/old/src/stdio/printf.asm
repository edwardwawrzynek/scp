;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_print:
$2:
	mspa	#2
	lwpa	
	lbpa	
	asex	
	jpz 	$3
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
$1:
	ret 	
_print_at:
$5:
	mspa	#2
	lwpa	
	lbpa	
	asex	
	jpz 	$6
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
	jmp 	$5
$6:
$4:
	ret 	
printf:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	psha	
	lwia	#2
	popb	
	aadd	
	popb	
	swqa	
$8:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	jpz 	$9
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	lwia	#37
	popb	
	aequ	
	jpz 	$10
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lwia	$11
	psha	
	mspa	#6
	lwpa	
	lbpa	
	asex	
	jmp 	cccase
$13:
	mspa	#0
	lwpa	
	lwpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$12
$14:
$15:
	lwia	#10
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_sprintn
	mdsp	#4
	jmp 	$12
$16:
	lwia	#10
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
	jmp 	$12
$17:
	lwia	#16
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
	jmp 	$12
$18:
	mspa	#0
	lwpa	
	lwpa	
	psha	
	call	_print
	mdsp	#2
	jmp 	$12
$19:
	jmp 	$12
	jmp 	$12
;	Data Segment
$11:
	.dw	#99,$13,#105,$14,#100,$15,#117,$16
	.dw	#120,$17,#115,$18
	.dw	$19,#0
;	Code Segment
$12:
	mspa	#0
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	jmp 	$20
$10:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$20:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$8
$9:
$7:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_print
;	extrn	putchar
;	globl	_print_at
;	extrn	outp
;	globl	printf
;	extrn	_sprintn
;	extrn	_uprintn

;	0 error(s) in compilation
;	literal pool:0
;	global pool:10
;	Macro pool:494
;	.end
