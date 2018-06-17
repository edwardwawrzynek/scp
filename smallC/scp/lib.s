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
	lwma	_screenpos
	psha	
	lwia	#1000
	popb	
	ault	
	alng	
	jpz 	$9
	lwib	#0
	call	_screenscroll
	mdsp	#0
	mdsp	#0
$9:
	mspa	#2
	lbpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$10
	lwib	#0
	call	_screenscroll
	mdsp	#0
	mdsp	#0
	jmp 	$11
$10:
	mspa	#2
	lbpa	
	psha	
	lwia	#9
	popb	
	aequ	
	jpz 	$12
	lwma	_screenpos
	psha	
	lwia	#8
	popb	
	aadd	
	swma	_screenpos
	mdsp	#0
	jmp 	$13
$12:
	mspa	#2
	lbpa	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$14
	lwma	_screenpos
	psha	
	lwia	#1
	popb	
	asub	
	swma	_screenpos
	lwia	#5
	psha	
	lwma	_screenpos
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	lwia	#0
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mdsp	#0
	jmp 	$15
$14:
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
$15:
	mdsp	#0
$13:
	mdsp	#0
$11:
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
_key_in_waiting:
	lwia	#8
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	mdsp	#0
	ret 	
_key_async_read:
	mdsp	#-2
	lwib	#0
	call	_key_in_waiting
	mdsp	#0
	jpz 	$3
	mspa	#0
	psha	
	lwia	#7
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#7
	psha	
	lwia	#1
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	jmp 	$2
	mdsp	#0
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#2
	ret 	
_key_async_press_read:
	mdsp	#-2
	lwib	#0
	call	_key_in_waiting
	mdsp	#0
	jpz 	$5
	mspa	#0
	psha	
	lwia	#7
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#7
	psha	
	lwia	#1
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpz 	$6
	lwia	#1
	aneg	
	jmp 	$7
$6:
	mspa	#0
	lwpa	
$7:
	jmp 	$4
	mdsp	#0
$5:
	lwia	#1
	aneg	
	jmp 	$4
$4:
	mdsp	#2
	ret 	
_key_read:
	mdsp	#-2
$9:
	mspa	#0
	psha	
	lwib	#0
	call	_key_async_read
	mdsp	#0
	popb	
	swqa	
$10:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$9
$11:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$8
$8:
	mdsp	#2
	ret 	
_key_press_read:
	mdsp	#-2
$13:
	mspa	#0
	psha	
	lwib	#0
	call	_key_async_press_read
	mdsp	#0
	popb	
	swqa	
$14:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$13
$15:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$12
$12:
	mdsp	#2
	ret 	
getchar:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	$0+#0
	popb	
	swqa	
$17:
	lwia	#1
	jpz 	$18
	mspa	#0
	psha	
	lwib	#0
	call	_key_read
	mdsp	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	aequ	
	jpz 	$19
	lwia	#1
	sbma	_getcharshifted
	mdsp	#0
	jmp 	$17
	mdsp	#0
$19:
	mspa	#0
	lwpa	
	psha	
	lwia	#272
	popb	
	aequ	
	jpz 	$20
	lwia	#0
	sbma	_getcharshifted
	mdsp	#0
	jmp 	$17
	mdsp	#0
$20:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpz 	$21
	mdsp	#0
	jmp 	$17
	mdsp	#0
$21:
	lbma	_getcharshifted
	jpz 	$22
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#32
	popb	
	asub	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	swqa	
	mdsp	#0
$22:
	lbma	_getcharecho
	jpz 	$23
	mspa	#0
	lwpa	
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
$23:
	mspa	#0
	lwpa	
	jmp 	$16
	jmp 	$17
$18:
	mdsp	#0
$16:
	mdsp	#4
	ret 	
;	Data Segment
$0:	.db	#32,#33,#34,#35,#36,#37,#38,#34
	.db	#40,#41,#42,#43,#60,#95,#62,#63
	.db	#41,#33,#64,#35,#36,#37,#94,#38
	.db	#42,#40,#58,#58,#60,#43,#62,#63
	.db	#64,#65,#66,#67,#68,#69,#70,#71
	.db	#72,#73,#74,#75,#76,#77,#78,#79
	.db	#80,#81,#82,#83,#84,#85,#86,#87
	.db	#88,#89,#90,#123,#124,#125,#94,#95
	.db	#126,#65,#66,#67,#68,#69,#70,#71
	.db	#72,#73,#74,#75,#76,#77,#78,#79
	.db	#80,#81,#82,#83,#84,#85,#86,#87
	.db	#88,#89,#90,#123,#124,#125,#126,#0
;	globl	_key_in_waiting
;	extrn	inp
;	globl	_key_async_read
;	extrn	outp
;	globl	_key_async_press_read
;	globl	_key_read
;	globl	_key_press_read
;	globl	_getcharecho
_getcharecho:
	.db	#1
;	globl	_getcharshifted
_getcharshifted:
	.db	#0
;	globl	getchar
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:96
;	global pool:11
;	Macro pool:275
;	.end

