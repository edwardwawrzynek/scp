;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_screenscroll:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$3:
	mspa	#2
	lwpa	
	psha	
	lwia	#2000
	popb	
	ault	
	jpnz	$5
	jmp 	$6
$4:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$3
$5:
	mspa	#2
	lwpa	
	psha	
	lwia	#80
	popb	
	aadd	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1920
	popb	
	ault	
	jpz 	$7
	lwia	#6
	psha	
	call	inp
	mdsp	#2
	jmp 	$8
$7:
	lwia	#0
$8:
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
	jmp 	$4
$6:
	lwia	#1920
	swma	_screenpos
$2:
	mdsp	#4
	ret 	
_screenclear:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$10:
	mspa	#0
	lwpa	
	psha	
	lwia	#2000
	popb	
	ault	
	jpnz	$12
	jmp 	$13
$11:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$10
$12:
	mspa	#0
	lwpa	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	lwia	#0
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
	jmp 	$11
$13:
	lwia	#1920
	swma	_screenpos
$9:
	mdsp	#2
	ret 	
putchar:
	lwma	_screenpos
	psha	
	lwia	#2000
	popb	
	ault	
	alng	
	jpz 	$15
	call	_screenscroll
$15:
	mspa	#2
	lbpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$16
	call	_screenscroll
	jmp 	$17
$16:
	mspa	#2
	lbpa	
	psha	
	lwia	#9
	popb	
	aequ	
	jpz 	$18
	lwma	_screenpos
	psha	
	lwia	#8
	popb	
	aadd	
	swma	_screenpos
	jmp 	$19
$18:
	mspa	#2
	lbpa	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$20
	lwma	_screenpos
	psha	
	lwia	#1
	popb	
	asub	
	swma	_screenpos
	lwma	_screenpos
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	lwia	#0
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
	jmp 	$21
$20:
	lwma	_screenpos
	inca	
	swma	_screenpos
	deca	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	mspa	#2
	lbpa	
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
$21:
$19:
$17:
$14:
	ret 	
;	Data Segment
;	globl	_screenpos
_screenpos:
	.dw	#1920
;	globl	_screenscroll
;	extrn	outp
;	extrn	inp
;	globl	_screenclear
;	globl	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end
