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
$2:
	mspa	#2
	lwpa	
	psha	
	lwia	#2000
	popb	
	ault	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$2
$4:
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
	jpz 	$6
	lwia	#6
	psha	
	call	inp
	mdsp	#2
	jmp 	$7
$6:
	lwia	#0
$7:
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
	jmp 	$3
$5:
	lwia	#1920
	swma	_screenpos
$1:
	mdsp	#4
	ret 	
_screenclear:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$9:
	mspa	#0
	lwpa	
	psha	
	lwia	#2000
	popb	
	ault	
	jpnz	$11
	jmp 	$12
$10:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$9
$11:
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
	jmp 	$10
$12:
	lwia	#1920
	swma	_screenpos
$8:
	mdsp	#2
	ret 	
putchar:
	lwma	_screenpos
	psha	
	lwia	#2000
	popb	
	ault	
	alng	
	jpz 	$14
	call	_screenscroll
$14:
	mspa	#2
	lbpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$15
	call	_screenscroll
	jmp 	$16
$15:
	mspa	#2
	lbpa	
	psha	
	lwia	#9
	popb	
	aequ	
	jpz 	$17
	lwma	_screenpos
	psha	
	lwia	#8
	popb	
	aadd	
	swma	_screenpos
	jmp 	$18
$17:
	mspa	#2
	lbpa	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$19
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
	jmp 	$20
$19:
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
$20:
$18:
$16:
$13:
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
;	Macro pool:513
;	.end
