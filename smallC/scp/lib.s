;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
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
	lwia	#1000
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
	lwia	#5
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#40
	popb	
	aadd	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#960
	popb	
	ault	
	jpz 	$6
	lwia	#6
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jmp 	$7
$6:
	lwia	#0
$7:
	popb	
	swqa	
	lwia	#5
	psha	
	mspa	#4
	lwpa	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	mspa	#2
	lwpa	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	jmp 	$3
$5:
	mdsp	#0
	lwia	#960
	swma	_screenpos
$1:
	mdsp	#4
	ret 	
putchar:
	mspa	#2
	lbpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$9
	lwib	#0
	call	_screenscroll
	mdsp	#0
	mdsp	#0
	jmp 	$10
$9:
	mspa	#2
	lbpa	
	psha	
	lwia	#9
	popb	
	aequ	
	jpz 	$11
	lwma	_screenpos
	psha	
	lwia	#8
	popb	
	aadd	
	swma	_screenpos
	mdsp	#0
	jmp 	$12
$11:
	lwia	#5
	psha	
	lwma	_screenpos
	inca	
	swma	_screenpos
	deca	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	mspa	#4
	lbpa	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mdsp	#0
$12:
	mdsp	#0
$10:
	lwma	_screenpos
	psha	
	lwia	#1000
	popb	
	ault	
	alng	
	jpz 	$13
	lwib	#0
	call	_screenscroll
	mdsp	#0
	mdsp	#0
$13:
$8:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	_screenpos
_screenpos:
	.dw	#960
;	globl	_screenscroll
;	extrn	outp
;	extrn	inp
;	globl	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
outp:
	mspa	#4
	lbpa	
	xswp	
	mspa	#2
	lwpa	
	outa	
$1:
	mdsp	#0
	ret 	
inp:
	mspa	#2
	lbpa	
	xswp	
	ina 	
$2:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	outp
;	globl	inp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
getchar:
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	getchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
;	.end

