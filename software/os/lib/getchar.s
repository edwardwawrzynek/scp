;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_key_in_waiting:
	lwia	#8
	psha	
	call	inp
	mdsp	#2
	jmp 	$2
$2:
	ret 	
_key_async_read:
	mdsp	#-2
	call	_key_in_waiting
	jpz 	$4
	mspa	#0
	psha	
	lwia	#7
	psha	
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#7
	psha	
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	jmp 	$3
$4:
	lwia	#1
	aneg	
	jmp 	$3
$3:
	mdsp	#2
	ret 	
_key_async_press_read:
	mdsp	#-2
	call	_key_in_waiting
	jpz 	$6
	mspa	#0
	psha	
	lwia	#7
	psha	
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#7
	psha	
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpz 	$7
	lwia	#1
	aneg	
	jmp 	$8
$7:
	mspa	#0
	lwpa	
$8:
	jmp 	$5
$6:
	lwia	#1
	aneg	
	jmp 	$5
$5:
	mdsp	#2
	ret 	
_key_read:
	mdsp	#-2
$10:
	mspa	#0
	psha	
	call	_key_async_read
	popb	
	swqa	
$11:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$10
$12:
	mspa	#0
	lwpa	
	jmp 	$9
$9:
	mdsp	#2
	ret 	
_key_press_read:
	mdsp	#-2
$14:
	mspa	#0
	psha	
	call	_key_async_press_read
	popb	
	swqa	
$15:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$14
$16:
	mspa	#0
	lwpa	
	jmp 	$13
$13:
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
$18:
	lwia	#1
	jpz 	$19
	mspa	#0
	psha	
	call	_key_read
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	aequ	
	jpz 	$20
	lwia	#1
	sbma	_getcharshifted
	jmp 	$18
$20:
	mspa	#0
	lwpa	
	psha	
	lwia	#272
	popb	
	aequ	
	jpz 	$21
	lwia	#0
	sbma	_getcharshifted
	jmp 	$18
$21:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpz 	$22
	jmp 	$18
$22:
	lbma	_getcharshifted
	jpz 	$23
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
$23:
	lbma	_getcharecho
	jpz 	$24
	mspa	#0
	lwpa	
	psha	
	call	putchar
	mdsp	#2
$24:
	mspa	#0
	lwpa	
	jmp 	$17
	jmp 	$18
$19:
$17:
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
;	Macro pool:51
;	.end
