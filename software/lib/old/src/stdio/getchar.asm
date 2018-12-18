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
	jmp 	$1
$1:
	ret 	
_key_async_read:
	mdsp	#-2
	call	_key_in_waiting
	jpz 	$3
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
	jmp 	$2
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#2
	ret 	
_key_async_press_read:
	mdsp	#-2
	call	_key_in_waiting
	jpz 	$5
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
	jpz 	$6
	lwia	#1
	aneg	
	jmp 	$7
$6:
	mspa	#0
	lwpa	
$7:
	jmp 	$4
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
	call	_key_async_read
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
	call	_key_async_press_read
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
	call	_key_read
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
	jmp 	$17
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
	jmp 	$17
$20:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpz 	$21
	jmp 	$17
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
$22:
	lbma	_getcharecho
	jpz 	$23
	mspa	#0
	lwpa	
	psha	
	call	putchar
	mdsp	#2
$23:
	mspa	#0
	lwpa	
	jmp 	$16
	jmp 	$17
$18:
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
;	Macro pool:625
;	.end
