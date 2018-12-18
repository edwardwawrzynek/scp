;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_print:
$3:
	mspa	#2
	lwpa	
	lbpa	
	asex	
	jpz 	$4
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
	jmp 	$3
$4:
$2:
	ret 	
_print_at:
$6:
	mspa	#2
	lwpa	
	lbpa	
	asex	
	jpz 	$7
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
	jmp 	$6
$7:
$5:
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
$9:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	jpz 	$10
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	lwia	#37
	popb	
	aequ	
	jpz 	$11
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lwia	$12
	psha	
	mspa	#6
	lwpa	
	lbpa	
	asex	
	jmp 	cccase
$14:
	mspa	#0
	lwpa	
	lwpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$13
$15:
$16:
	lwia	#10
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_sprintn
	mdsp	#4
	jmp 	$13
$17:
	lwia	#10
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
	jmp 	$13
$18:
	lwia	#16
	psha	
	mspa	#2
	lwpa	
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
	jmp 	$13
$19:
	mspa	#0
	lwpa	
	lwpa	
	psha	
	call	_print
	mdsp	#2
	jmp 	$13
$20:
	jmp 	$13
	jmp 	$13
;	Data Segment
$12:
	.dw	#99,$14,#105,$15,#100,$16,#117,$17
	.dw	#120,$18,#115,$19
	.dw	$20,#0
;	Code Segment
$13:
	mspa	#0
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	jmp 	$21
$11:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$21:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$9
$10:
$8:
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
;	Macro pool:51
;	.end
