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

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
outp:
	mspa	#2
	lbpa	

		xswp
		
	mspa	#4
	lwpa	

		outa
		
$1:
	ret 	
inp:
	mspa	#2
	lbpa	

		xswp
		ina 
		
$2:
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

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
puts:
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
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
$1:
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	puts
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:501
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_gets:
	mdsp	#-1
	mdsp	#-2
	mdsp	#-1
	mspa	#0
	psha	
	lbma	_getcharecho
	popb	
	sbqa	
	lwia	#0
	sbma	_getcharecho
	mspa	#1
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$2:
	mspa	#3
	psha	
	call	getchar
	popb	
	sbqa	
	psha	
	mspa	#10
	lbpa	
	asex	
	popb	
	aneq	
	jpz 	$4
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aneq	
$4:
	aclv	
	jpz 	$3
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$5
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$6
	mspa	#1
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lwia	#8
	psha	
	call	putchar
	mdsp	#2
$6:
	jmp 	$7
$5:
	mspa	#3
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
	mspa	#1
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#5
	lbpa	
	asex	
	popb	
	sbqa	
$7:
	jmp 	$2
$3:
	mspa	#0
	lbpa	
	sbma	_getcharecho
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpz 	$9
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aequ	
$9:
	aclv	
	jpz 	$8
	lwia	#0
	jmp 	$1
$8:
	mspa	#1
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#6
	lwpa	
	jmp 	$1
$1:
	mdsp	#4
	ret 	
gets:
	lwia	#10
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_gets
	mdsp	#4
	jmp 	$10
$10:
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_gets
;	extrn	getchar
;	extrn	putchar
;	globl	gets

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:508
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_sprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	lwia	#45
	psha	
	call	putchar
	mdsp	#2
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	aneg	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$3
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_sprintn
	mdsp	#4
$3:
	mspa	#0
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccdiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$1:
	mdsp	#4
	ret 	
_uprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccudiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aneq	
	jpz 	$5
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
$5:
	mspa	#0
	psha	
	lwia	$0+#17
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	call	ccudiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	putchar
	mdsp	#2
$4:
	mdsp	#4
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#97,#98,#99,#100,#101,#102
	.db	#0,#48,#49,#50,#51,#52,#53,#54
	.db	#55,#56,#57,#97,#98,#99,#100,#101
	.db	#102,#0
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_sprintn
;	extrn	putchar
;	globl	_uprintn

;	0 error(s) in compilation
;	literal pool:34
;	global pool:6
;	Macro pool:520
;	.end

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

