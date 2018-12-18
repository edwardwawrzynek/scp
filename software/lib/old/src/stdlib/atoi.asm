;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
atoi:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aequ	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#10
	popb	
	aequ	
	popb	
	abor	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#9
	popb	
	aequ	
	popb	
	abor	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$2
$4:
	jmp 	$3
$5:
	mspa	#0
	psha	
	lwia	#1
	popb	
	swqa	
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#45
	popb	
	aequ	
	jpz 	$6
	mspa	#0
	psha	
	lwia	#1
	aneg	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$6:
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$7:
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	_isdigit
	mdsp	#2
	jpnz	$9
	jmp 	$10
$8:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$7
$9:
	mspa	#2
	psha	
	lwia	#10
	psha	
	mspa	#6
	lwpa	
	popb	
	amul	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	aadd	
	psha	
	lwia	#48
	popb	
	asub	
	popb	
	swqa	
	jmp 	$8
$10:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	amul	
	jmp 	$1
$1:
	mdsp	#6
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	atoi
;	extrn	_isdigit

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:501
;	.end
