; Start the kernel, and set interupt locations
; This is the first thing in the kernel binary
; Start by calling main
  call  main
; Now fill up the addr space till 0x10, where interupts start
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .dw #0
  .db #0
; Interupt addrs, each four bytes apart
; Very important that these jump to the handlers and not call, else they would change the sp
  jmp   _int0_handler
  .db #0
  jmp   _int1_handler
  .db #0
  jmp   _int2_handler
  .db #0
  jmp   _int3_handler
  .db #0
  jmp   _int4_handler
  .db #0
  jmp   _int5_handler
  .db #0
; Done
	.module	CC_DIV_SMALLC_GENERATED
;	Unsigned divide A=A/B, B=A%B
ccudiv:
	mdsp	#-10
;
	pshb	
	xswp	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
;	
	mspa	#8
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	psha	
	lwia	#15
	popb	
	swqa	
ccudiv_2:
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	jpnz	ccudiv_4
	jmp 	ccudiv_5
ccudiv_3:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	jmp 	ccudiv_2
ccudiv_4:
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	popb	
	swqa	
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#4094
	popb	
	abnd	
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	psha	
	mspa	#12
	lwpa	
	popb	
	ashl	
	popb	
	abnd	
	psha	
	mspa	#10
	lwpa	
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	ault	
	alng	
	jpz 	ccudiv_6
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	popb	
	ashl	
	popb	
	abor	
	popb	
	swqa	
ccudiv_6:
	jmp 	ccudiv_3
ccudiv_5:
	mspa	#6
	lwpa	
	xswp	
	mspa	#8
	lwpa	
ccudiv_1:
	mdsp	#10
	ret 	
;	Signed divide
ccdiv:
	mdsp	#-6
;
	pshb	
	xswp	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
;	
	nop 	
	mspa	#5
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#4
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	jpz 	ccdiv_2
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
	mspa	#5
	psha	
	lbpa	
	psha	
	lwia	#1
	popb	
	abxr	
	popb	
	sbqa	
	mspa	#4
	psha	
	lwia	#1
	popb	
	sbqa	
ccdiv_2:
	mspa	#0
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	jpz 	ccdiv_3
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	aneg	
	popb	
	swqa	
	mspa	#5
	psha	
	lbpa	
	psha	
	lwia	#1
	popb	
	abxr	
	popb	
	sbqa	
ccdiv_3:
	mspa	#2
	lwpa	
	xswp	
	mspa	#0
	lwpa	
	call	ccudiv
;	Store b
	psha	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
	mspa	#5
	lbpa	
	jpz 	ccdiv_4
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
ccdiv_4:
	mspa	#4
	lbpa	
	jpz 	ccdiv_5
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	aneg	
	popb	
	swqa	
ccdiv_5:
	mspa	#0
	lwpa	
	xswp	
	mspa	#2
	lwpa	
ccdiv_1:
	mdsp	#6
	ret 	
	.module	CCCASE_SMALLC_GENERATED
cccase:
	mdsp	#-6
	xswp	
	mspa	#0
	swpb	
	mspa	#4
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$2:
	lwia	#1
	jpz 	$3
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	popb	
	swqa	
	popb	
	aequ	
	jpz 	$5
	mspa	#4
	lwpa	
	lwpa	
$5:
	aclv	
	jpz 	$4
	mspa	#4
	lwpa	
	lwpa	
;	Reset sp
	mdsp	#8
	jmpa	
$4:
	mspa	#4
	lwpa	
	lwpa	
	alng	
	jpz 	$6
	mspa	#2
	lwpa	
;	Properly reset sp
	mdsp	#8
	jmpa	

	mspa	#4
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	

$6:
	jmp 	$2
$3:
$1:
	mdsp	#8
	.module	CRUN_END

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
$3:
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
	jpz 	$5
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aneq	
$5:
	aclv	
	jpz 	$4
	mspa	#3
	lbpa	
	asex	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$6
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$7
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
$7:
	jmp 	$8
$6:
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
$8:
	jmp 	$3
$4:
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
	jpz 	$10
	mspa	#1
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aequ	
$10:
	aclv	
	jpz 	$9
	lwia	#0
	jmp 	$2
$9:
	mspa	#1
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#6
	lwpa	
	jmp 	$2
$2:
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
	jmp 	$11
$11:
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
;	Macro pool:51
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
_malloc_new:
	mdsp	#-7
	mspa	#0
	lwib	#6
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#4
	aadd	
	psha	
	mspa	#11
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwib	#0
	aadd	
	psha	
	mspa	#13
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	lwia	#7
	psha	
	mspa	#2
	psha	
	lwma	brk
	psha	
	call	memcpy
	mdsp	#6
	mspa	#11
	lwpa	
	jpz 	$2
	mspa	#11
	lwpa	
	lwib	#2
	aadd	
	psha	
	lwma	brk
	popb	
	swqa	
	jmp 	$3
$2:
	lwma	brk
	swma	_malloc_head
$3:
	lwma	brk
	swma	_malloc_tail
	lwma	brk
	psha	
	lwia	#7
	psha	
	mspa	#13
	lwpa	
	popb	
	aadd	
	popb	
	aadd	
	swma	brk
	lwma	brk
	psha	
	mspa	#11
	lwpa	
	popb	
	asub	
	jmp 	$1
$1:
	mdsp	#7
	ret 	
_malloc_combine:
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	jpz 	$5
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	jpz 	$6
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#7
	popb	
	aadd	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	alng	
	jpz 	$7
	mspa	#2
	lwpa	
	swma	_malloc_tail
$7:
	mspa	#2
	lwpa	
	psha	
	call	_malloc_combine
	mdsp	#2
$6:
	jmp 	$8
$5:
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	jpz 	$9
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	_malloc_combine
	mdsp	#2
$9:
$8:
$4:
	ret 	
kmalloc:
	mdsp	#-7
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	psha	
	lwma	_malloc_head
	popb	
	swqa	
$11:
	mspa	#6
	lwpa	
	jpz 	$12
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#19
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$14
	mspa	#6
	lwpa	
	lwib	#6
	aadd	
	lbpa	
$14:
	aclv	
	jpz 	$13
	mspa	#6
	lwpa	
	lwib	#6
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#4
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#21
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#7
	popb	
	aule	
	alng	
	jpz 	$15
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#19
	lwpa	
	popb	
	swqa	
	mspa	#8
	lwib	#6
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#8
	lwib	#4
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#7
	popb	
	asub	
	popb	
	swqa	
	mspa	#8
	lwib	#0
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#8
	lwib	#2
	aadd	
	psha	
	mspa	#8
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#7
	popb	
	aadd	
	psha	
	mspa	#21
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	lwia	#7
	psha	
	mspa	#10
	psha	
	mspa	#4
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	jpz 	$16
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
	jmp 	$17
$16:
	mspa	#0
	lwpa	
	swma	_malloc_tail
$17:
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
$15:
	mspa	#4
	lwpa	
	psha	
	lwia	#7
	popb	
	aadd	
	jmp 	$10
$13:
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	jmp 	$11
$12:
	lwma	_malloc_tail
	psha	
	mspa	#19
	lwpa	
	psha	
	call	_malloc_new
	mdsp	#4
	jmp 	$10
$10:
	mdsp	#15
	ret 	
kcalloc:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#14
	lwpa	
	popb	
	amul	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#6
	lwpa	
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	popb	
	swqa	
$19:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$20
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$19
$20:
	mspa	#2
	lwpa	
	jmp 	$18
$18:
	mdsp	#6
	ret 	
kfree:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#7
	popb	
	asub	
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#6
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	_malloc_combine
	mdsp	#2
$21:
	mdsp	#2
	ret 	
krealloc:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#7
	popb	
	asub	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#6
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$22
$22:
	mdsp	#4
	ret 	
;	Data Segment
brk:
	.dw	#0
_malloc_head:
	.ds	#7
	.ds	#7
	.dw	#0
	.db	#0

_malloc_tail:
	.ds	#7
	.ds	#7
	.dw	#0
	.db	#0

;	globl	_malloc_new
;	extrn	memcpy
;	globl	_malloc_combine
;	globl	kmalloc
;	globl	kcalloc
;	globl	kfree
;	globl	krealloc

;	0 error(s) in compilation
;	literal pool:0
;	global pool:10
;	Macro pool:51
;	.end

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
	jpz 	$3
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
$3:
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
	jpz 	$4
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_sprintn
	mdsp	#4
$4:
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
$2:
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
	jpz 	$6
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	_uprintn
	mdsp	#4
$6:
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
$5:
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
;	Macro pool:51
;	.end

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

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
serial_in_waiting:
	lwia	#2
	psha	
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	ret 	
serial_async_read:
	mdsp	#-2
	call	serial_in_waiting
	jpz 	$3
	mspa	#0
	psha	
	lwia	#1
	psha	
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#1
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
serial_read:
	mdsp	#-2
$5:
	mspa	#0
	psha	
	call	serial_async_read
	popb	
	swqa	
$6:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$5
$7:
	mspa	#0
	lwpa	
	jmp 	$4
$4:
	mdsp	#2
	ret 	
serial_async_write:
	lwia	#4
	psha	
	call	inp
	mdsp	#2
	jpz 	$9
	lwia	#1
	aneg	
	jmp 	$8
$9:
	mspa	#2
	lbpa	
	psha	
	lwia	#3
	psha	
	call	outp
	mdsp	#4
$8:
	ret 	
serial_write:
$11:
	lwia	#4
	psha	
	call	inp
	mdsp	#2
	jpz 	$12
	jmp 	$11
$12:
	mspa	#2
	lbpa	
	psha	
	lwia	#3
	psha	
	call	outp
	mdsp	#4
$10:
	ret 	
;	Data Segment
;	globl	serial_in_waiting
;	extrn	inp
;	globl	serial_async_read
;	extrn	outp
;	globl	serial_read
;	globl	serial_async_write
;	globl	serial_write

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strchr:
$2:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aneq	
	jpz 	$3
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	alng	
	jpz 	$4
	lwia	#0
	jmp 	$1
$4:
	jmp 	$2
$3:
	mspa	#2
	lwpa	
	jmp 	$1
$1:
	ret 	
strcmp:
$6:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	aequ	
	jpz 	$7
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$8
	lwia	#0
	jmp 	$5
$8:
	jmp 	$6
$7:
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	popb	
	asub	
	jmp 	$5
$5:
	ret 	
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$10:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	jpz 	$11
	jmp 	$10
$11:
	mspa	#0
	lwpa	
	jmp 	$9
$9:
	mdsp	#2
	ret 	
memcmp:
$13:
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$14
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	aneq	
	jpz 	$15
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	asub	
	jmp 	$12
$15:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$13
$14:
	lwia	#0
	jmp 	$12
$12:
	ret 	
memcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$17:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$18
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	jmp 	$17
$18:
	mspa	#4
	lwpa	
	jmp 	$16
$16:
	mdsp	#2
	ret 	
memset:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$20:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$21
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#8
	lbpa	
	popb	
	sbqa	
	jmp 	$20
$21:
	mspa	#4
	lwpa	
	jmp 	$19
$19:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strchr
;	globl	strcmp
;	globl	strcpy
;	globl	memcmp
;	globl	memcpy
;	globl	memset

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
disk_init:
	lwia	#0
	psha	
	lwia	#13
	psha	
	call	outp
	mdsp	#4
	lwia	#1
	psha	
	lwia	#13
	psha	
	call	outp
	mdsp	#4
$2:
	lwia	#13
	psha	
	call	inp
	mdsp	#2
	jpz 	$3
	jmp 	$2
$3:
	lwia	#14
	psha	
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	ret 	
disk_read:
$5:
	lwia	#13
	psha	
	call	inp
	mdsp	#2
	jpz 	$6
	jmp 	$5
$6:
	mspa	#2
	lwpa	
	psha	
	lwia	#14
	psha	
	call	outp
	mdsp	#4
	lwia	#1
	psha	
	lwia	#16
	psha	
	call	outp
	mdsp	#4
	lwia	#0
	psha	
	lwia	#16
	psha	
	call	outp
	mdsp	#4
$7:
	lwia	#13
	psha	
	call	inp
	mdsp	#2
	jpz 	$8
	jmp 	$7
$8:
$9:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#15
	psha	
	call	inp
	mdsp	#2
	popb	
	sbqa	
	lwia	#0
	psha	
	lwia	#15
	psha	
	call	outp
	mdsp	#4
$10:
	lwia	#16
	psha	
	call	inp
	mdsp	#2
	jpnz	$9
$11:
$4:
	ret 	
disk_write:
$13:
	lwia	#13
	psha	
	call	inp
	mdsp	#2
	jpz 	$14
	jmp 	$13
$14:
	mspa	#2
	lwpa	
	psha	
	lwia	#14
	psha	
	call	outp
	mdsp	#4
$15:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#17
	psha	
	call	outp
	mdsp	#4
$16:
	lwia	#18
	psha	
	call	inp
	mdsp	#2
	jpnz	$15
$17:
	lwia	#1
	psha	
	lwia	#18
	psha	
	call	outp
	mdsp	#4
	lwia	#0
	psha	
	lwia	#18
	psha	
	call	outp
	mdsp	#4
$12:
	ret 	
;	Data Segment
;	globl	disk_init
;	extrn	outp
;	extrn	inp
;	globl	disk_read
;	globl	disk_write

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
buffer_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$77:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
	alng	
	jpz 	$81
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#512
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	lwia	#1
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
buffer_get:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$83:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$85
	jmp 	$86
$84:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$83
$85:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aequ	
	jpz 	$88
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
$88:
	aclv	
	jpz 	$87
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	jmp 	$82
$87:
	jmp 	$84
$86:
	mspa	#4
	lwpa	
	psha	
	call	buffer_alloc
	mdsp	#2
	jmp 	$82
$82:
	mdsp	#2
	ret 	
buffer_put:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lbpa	
	alng	
	jpz 	$90
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
$90:
$89:
	ret 	
buffer_flush_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$92:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$94
	jmp 	$95
$93:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$92
$94:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
	jpz 	$96
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lwia	buffer_table
	psha	
	mspa	#4
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$96:
	jmp 	$93
$95:
$91:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	buffer_table
buffer_table:
	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

;	globl	buffer_alloc
;	extrn	kmalloc
;	extrn	disk_read
;	extrn	panic
;	globl	buffer_get
;	globl	buffer_put
;	extrn	disk_write
;	extrn	kfree
;	globl	buffer_flush_all

;	0 error(s) in compilation
;	literal pool:0
;	global pool:20
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
balloc_alloc:
	mdsp	#-2
	mdsp	#-2
	lwia	balloc_buffer
	psha	
	lwia	superblk
	lwib	#2
	aadd	
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#2
	psha	
	lwia	superblk
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
$77:
	mspa	#2
	lwpa	
	psha	
	lwia	#65535
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	alng	
	jpz 	$81
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
$81:
	mspa	#0
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$82
	mspa	#2
	lwpa	
	jmp 	$76
$82:
	jmp 	$78
$80:
	lwia	#2
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#4
	ret 	
balloc_put:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	popb	
	swqa	
$84:
	mspa	#8
	lwpa	
	lwpa	
	jpz 	$85
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	mspa	#10
	lwpa	
	lwpa	
	popb	
	aneq	
	jpz 	$86
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwpa	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$86:
	mspa	#0
	psha	
	mspa	#10
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	popb	
	swqa	
	jmp 	$84
$85:
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#1
	popb	
	aneq	
	jpz 	$87
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$87:
$83:
	mdsp	#6
	ret 	
balloc_get:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	popb	
	swqa	
	lwia	balloc_get_buf
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$89:
	lwia	#1
	jpz 	$90
	lwia	balloc_buffer
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#6
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#6
	lwpa	
	alng	
	jpnz	$92
	mspa	#6
	lwpa	
	psha	
	lwia	#65535
	popb	
	aequ	
$92:
	aclv	
	jpz 	$91
	lwia	#0
	jmp 	$88
$91:
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$93
	mspa	#2
	lwpa	
	psha	
	lwia	#129
	popb	
	ault	
	alng	
	jpz 	$94
	lwia	#4
	psha	
	call	panic
	mdsp	#2
$94:
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	sbqa	
	lwia	balloc_get_buf
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	lwia	balloc_get_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#0
	lwpa	
	jmp 	$88
$93:
	lwia	balloc_get_buf
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	jmp 	$89
$90:
$88:
	mdsp	#4
	ret 	
balloc_free:
	mdsp	#-2
$96:
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#0
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_write
	mdsp	#4
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
$97:
	mspa	#4
	lwpa	
	jpz 	$99
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aneq	
$99:
	aclv	
	jpz 	$100
	mspa	#4
	lwpa	
	psha	
	lwia	#65535
	popb	
	aneq	
$100:
	aclv	
	jpnz	$96
$98:
$95:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	balloc_buffer
balloc_buffer:
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0
;	globl	balloc_get_buf
balloc_get_buf:
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0
;	globl	balloc_alloc
;	extrn	disk_read
;	extrn	panic
;	globl	balloc_put
;	extrn	disk_write
;	globl	balloc_get
;	extrn	kmalloc
;	extrn	memcpy
;	globl	balloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:21
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
superblock_read:
	lwia	fs_global_buf
	psha	
	lwia	#383
	psha	
	call	disk_read
	mdsp	#4
	lwia	#13
	psha	
	lwia	fs_global_buf
	psha	
	lwia	superblk
	psha	
	call	memcpy
	mdsp	#6
$76:
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	superblk
superblk:
	.dw	#0
	.dw	#0
	.ds	#9

;	globl	superblock_read
;	extrn	disk_read
;	extrn	memcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:14
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
inode_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$77:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$81
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$82:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$84
	jmp 	$85
$83:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$82
$84:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#10
	aadd	
	lbpa	
	alng	
	jpz 	$86
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
	jpz 	$87
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	psha	
	call	inode_force_put
	mdsp	#2
$87:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$76
$86:
	jmp 	$83
$85:
	lwia	#3
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
inode_load:
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$89
	lwia	#5
	psha	
	call	panic
	mdsp	#2
$89:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#6
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#63
	popb	
	abnd	
	psha	
	lwia	#8
	popb	
	amul	
	popb	
	swqa	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	#8
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
$88:
	mdsp	#4
	ret 	
inode_write:
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$91
	lwia	#5
	psha	
	call	panic
	mdsp	#2
$91:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#6
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#63
	popb	
	abnd	
	psha	
	lwia	#8
	popb	
	amul	
	popb	
	swqa	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	#8
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	psha	
	call	memcpy
	mdsp	#6
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$90:
	mdsp	#4
	ret 	
inode_get:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$93:
	mspa	#2
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$95
	jmp 	$96
$94:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$93
$95:
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#8
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aequ	
	jpz 	$98
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
$98:
	aclv	
	jpz 	$97
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#10
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$92
$97:
	jmp 	$94
$96:
	mspa	#0
	psha	
	call	inode_alloc
	popb	
	swqa	
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	psha	
	call	inode_load
	mdsp	#4
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$99
	lwia	#0
	jmp 	$92
$99:
	mspa	#0
	lwpa	
	lwib	#10
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#8
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#13
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$100
	mspa	#0
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	lwia	#0
	jmp 	$92
$100:
	mspa	#0
	lwpa	
	jmp 	$92
$92:
	mdsp	#4
	ret 	
inode_put:
	mspa	#2
	lwpa	
	lwib	#10
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
$101:
	ret 	
inode_force_put:
	mspa	#2
	lwpa	
	lwib	#8
	aadd	
	lwpa	
	jpz 	$103
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#8
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	inode_write
	mdsp	#4
$103:
$102:
	ret 	
inode_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$105:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$107
	jmp 	$108
$106:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$105
$107:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	psha	
	call	inode_force_put
	mdsp	#2
	jmp 	$106
$108:
$104:
	mdsp	#2
	ret 	
inode_add_blk:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	popb	
	swqa	
$110:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$111:
	mspa	#0
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	jpnz	$110
$112:
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	mspa	#10
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	krealloc
	mdsp	#4
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#13
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	balloc_put
	mdsp	#2
$109:
	mdsp	#4
	ret 	
inode_truncate:
	mdsp	#-4
	mdsp	#-2
	mspa	#8
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#8
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_free
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#5
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	psha	
	call	balloc_put
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#13
	aadd	
	psha	
	mspa	#12
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_get
	mdsp	#4
	popb	
	swqa	
$113:
	mdsp	#6
	ret 	
inode_new:
	mdsp	#-2
	mdsp	#-14
	mdsp	#-4
	mspa	#18
	psha	
	lwia	#0
	popb	
	swqa	
$115:
	mspa	#18
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	jpnz	$117
	jmp 	$118
$116:
	mspa	#18
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$115
$117:
	mspa	#18
	lwpa	
	psha	
	mspa	#6
	psha	
	call	inode_load
	mdsp	#4
	mspa	#4
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$119
	mspa	#4
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#4
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#4
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	lwib	#2
	aadd	
	psha	
	mspa	#24
	lwpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#1
	aadd	
	psha	
	mspa	#26
	lbpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#5
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#6
	lwib	#5
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	call	balloc_put
	mdsp	#2
	mspa	#18
	lwpa	
	psha	
	mspa	#6
	psha	
	call	inode_write
	mdsp	#4
	mspa	#18
	lwpa	
	jmp 	$114
$119:
	jmp 	$116
$118:
	lwia	#8
	psha	
	call	panic
	mdsp	#2
$114:
	mdsp	#20
	ret 	
inode_delete:
	mdsp	#-14
	mspa	#16
	lwpa	
	psha	
	mspa	#2
	psha	
	call	inode_load
	mdsp	#4
	mspa	#0
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwib	#7
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_free
	mdsp	#2
	mspa	#16
	lwpa	
	psha	
	mspa	#2
	psha	
	call	inode_write
	mdsp	#4
$120:
	mdsp	#14
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	inode_table
inode_table:
	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

;	globl	inode_alloc
;	globl	inode_force_put
;	extrn	panic
;	globl	inode_load
;	extrn	disk_read
;	extrn	memcpy
;	globl	inode_write
;	extrn	disk_write
;	globl	inode_get
;	extrn	balloc_get
;	globl	inode_put
;	extrn	kfree
;	globl	inode_put_all
;	globl	inode_add_blk
;	extrn	krealloc
;	extrn	balloc_alloc
;	extrn	balloc_put
;	globl	inode_truncate
;	extrn	balloc_free
;	globl	inode_new
;	globl	inode_delete

;	0 error(s) in compilation
;	literal pool:0
;	global pool:32
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
file_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$77:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$81
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	lwia	#9
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
file_get:
	mdsp	#-2
	mspa	#0
	psha	
	call	file_alloc
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#6
	aadd	
	psha	
	mspa	#8
	lbpa	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	inode_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	alng	
	jpz 	$83
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	#0
	jmp 	$82
$83:
	mspa	#6
	lbpa	
	psha	
	lwia	#4
	popb	
	abnd	
	jpz 	$84
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_truncate
	mdsp	#2
$84:
	mspa	#6
	lbpa	
	psha	
	lwia	#8
	popb	
	abnd	
	jpz 	$85
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	swqa	
$85:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	lwpa	
	alng	
	jpz 	$86
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_add_blk
	mdsp	#2
$86:
	mspa	#0
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	lwpa	
	psha	
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	jmp 	$82
$82:
	mdsp	#2
	ret 	
file_put:
	mspa	#2
	lwpa	
	lwib	#7
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$88
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	buffer_put
	mdsp	#2
$88:
$87:
	ret 	
file_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$90:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$92
	jmp 	$93
$91:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$90
$92:
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	psha	
	call	file_put
	mdsp	#2
	jmp 	$91
$93:
$89:
	mdsp	#2
	ret 	
file_set_buf:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#9
	popb	
	ashr	
	popb	
	swqa	
$95:
	mspa	#0
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#13
	aadd	
	lbpa	
	popb	
	ault	
	alng	
	jpz 	$96
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_add_blk
	mdsp	#2
	jmp 	$95
$96:
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aneq	
	jpz 	$97
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	buffer_put
	mdsp	#2
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
$97:
$94:
	mdsp	#2
	ret 	
file_write:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#2
	popb	
	abnd	
	alng	
	jpz 	$99
	lwia	#0
	jmp 	$98
$99:
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$100:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$101
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$102
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$102:
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#511
	popb	
	abnd	
	popb	
	aadd	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$103
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	popb	
	swqa	
$103:
	jmp 	$100
$101:
	mspa	#0
	lwpa	
	jmp 	$98
$98:
	mdsp	#2
	ret 	
file_read:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	abnd	
	alng	
	jpz 	$105
	lwia	#0
	jmp 	$104
$105:
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$106:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$107
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$108
	mspa	#0
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	asub	
	jmp 	$104
$108:
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$109
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$109:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#511
	popb	
	abnd	
	popb	
	aadd	
	lbpa	
	popb	
	sbqa	
	jmp 	$106
$107:
	mspa	#0
	lwpa	
	jmp 	$104
$104:
	mdsp	#2
	ret 	
file_seek:
	lwia	$111
	psha	
	mspa	#8
	lbpa	
	jmp 	cccase
$113:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$112
$114:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$112
$115:
$116:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	jmp 	$112
	jmp 	$112
;	Data Segment
$111:
	.dw	#2,$113,#3,$114,#1,$115
	.dw	$116,#0
;	Code Segment
$112:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$110
$110:
	ret 	
file_tell:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$117
$117:
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	file_table
file_table:
	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

;	globl	file_alloc
;	extrn	panic
;	globl	file_get
;	extrn	inode_get
;	extrn	inode_truncate
;	extrn	inode_add_blk
;	extrn	buffer_get
;	globl	file_put
;	extrn	inode_put
;	extrn	buffer_put
;	globl	file_put_all
;	globl	file_set_buf
;	globl	file_write
;	globl	file_read
;	globl	file_seek
;	globl	file_tell

;	0 error(s) in compilation
;	literal pool:0
;	global pool:27
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
dir_make_file:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#1
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#4
	lwpa	
	alng	
	jpz 	$77
	lwia	#0
	jmp 	$76
$77:
	mspa	#2
	psha	
	lwia	#1
	aneg	
	popb	
	swqa	
$78:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$81
	jmp 	$80
$81:
$79:
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
	jpnz	$78
$80:
	lwia	#1
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#16
	popb	
	amul	
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	mspa	#0
	psha	
	mspa	#16
	lbpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	call	inode_new
	mdsp	#4
	popb	
	swqa	
	lwia	#16
	psha	
	lwia	#0
	psha	
	lwia	fs_global_buf
	psha	
	call	memset
	mdsp	#6
	mspa	#10
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	call	strcpy
	mdsp	#4
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$82
	mspa	#0
	lwpa	
	psha	
	call	inode_delete
	mdsp	#2
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$76
$82:
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$76
$76:
	mdsp	#6
	ret 	
dir_make_dir:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	popb	
	swqa	
	mspa	#2
	lwpa	
	jpz 	$84
	mspa	#0
	psha	
	lwia	#2
	psha	
	mspa	#6
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$85
	lwia	#0
	jmp 	$83
$85:
	lwia	#32
	psha	
	lwia	#0
	psha	
	lwia	fs_global_buf
	psha	
	call	memset
	mdsp	#6
	lwia	fs_global_buf
	psha	
	lwia	#0
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#16
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#17
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#30
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#31
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	#32
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#32
	popb	
	aneq	
	jpz 	$86
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$83
$86:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$87
	lwia	#0
	jmp 	$83
$87:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#2
	lwpa	
	jmp 	$83
$84:
	lwia	#0
	jmp 	$83
$83:
	mdsp	#4
	ret 	
dir_delete_file:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#1
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#4
	lwpa	
	alng	
	jpz 	$89
	lwia	#1
	jmp 	$88
$89:
$90:
	lwia	#1
	jpz 	$91
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$92
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$92:
	lwia	fs_global_buf
	psha	
	mspa	#12
	lwpa	
	psha	
	call	strcmp
	mdsp	#4
	alng	
	jpz 	$94
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	jpnz	$95
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
$95:
	aclv	
$94:
	aclv	
	jpz 	$93
	jmp 	$91
$93:
	jmp 	$90
$91:
	mspa	#2
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	alng	
	jpz 	$96
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$96:
	lwia	#2
	psha	
	lwia	#16
	aneg	
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$97
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$97:
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	call	inode_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$98
	lwia	#1
	jmp 	$88
$98:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$88
$88:
	mdsp	#6
	ret 	
dir_next_entry:
	mdsp	#-2
$100:
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$103
	lwia	#0
	jmp 	$99
$103:
$101:
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
	alng	
	jpnz	$100
$102:
	mspa	#0
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	lwia	#14
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#10
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#0
	lwpa	
	jmp 	$99
$99:
	mdsp	#2
	ret 	
dir_name_inum:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#2
	lwpa	
	alng	
	jpz 	$105
	lwia	#0
	jmp 	$104
$105:
$106:
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#6
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aequ	
	jpz 	$107
	lwia	fs_global_buf
	psha	
	mspa	#10
	lwpa	
	psha	
	call	strcmp
	mdsp	#4
	alng	
	jpz 	$109
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
$109:
	aclv	
	jpz 	$108
	mspa	#0
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$104
$108:
	jmp 	$106
$107:
	mspa	#2
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$104
$104:
	mdsp	#4
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	dir_make_file
;	extrn	file_get
;	extrn	file_read
;	extrn	file_seek
;	extrn	inode_new
;	extrn	memset
;	extrn	strcpy
;	extrn	file_write
;	extrn	inode_delete
;	extrn	file_put
;	globl	dir_make_dir
;	globl	dir_delete_file
;	extrn	strcmp
;	extrn	inode_get
;	extrn	inode_put
;	globl	dir_next_entry
;	extrn	memcpy
;	globl	dir_name_inum

;	0 error(s) in compilation
;	literal pool:0
;	global pool:28
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
fs_path_to_inum:
	mdsp	#-2
	mspa	#4
	lwpa	
	lbpa	
	psha	
	lwia	#47
	popb	
	aequ	
	jpz 	$77
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	mspa	#6
	psha	
	lwia	#2
	popb	
	swqa	
$77:
$78:
	mspa	#6
	lwpa	
	jpz 	$80
	mspa	#0
	lwpa	
$80:
	aclv	
	jpz 	$79
	mspa	#4
	lwpa	
	lbpa	
	alng	
	jpz 	$81
	jmp 	$79
$81:
	mspa	#0
	psha	
	lwia	#47
	psha	
	mspa	#8
	lwpa	
	psha	
	call	strchr
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	jpz 	$82
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
$82:
	mspa	#6
	psha	
	mspa	#6
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
	call	dir_name_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$78
$79:
	mspa	#6
	lwpa	
	jmp 	$76
$76:
	mdsp	#2
	ret 	
fs_init:
	call	disk_init
	call	superblock_read
$83:
	ret 	
fs_close:
	call	file_put_all
	call	inode_put_all
	call	buffer_flush_all
$84:
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	fs_global_buf
fs_global_buf:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0
;	globl	fs_path_to_inum
;	extrn	strchr
;	extrn	dir_name_inum
;	globl	fs_init
;	extrn	disk_init
;	extrn	superblock_read
;	globl	fs_close
;	extrn	file_put_all
;	extrn	inode_put_all
;	extrn	buffer_flush_all

;	0 error(s) in compilation
;	literal pool:0
;	global pool:21
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
panic:
	mspa	#2
	lbpa	
	psha	
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#4
$2:
	lwia	#1
	jpz 	$3
	jmp 	$2
$3:
$1:
	ret 	
;	Data Segment
$0:	.db	#10,#10,#10,#84,#104,#101,#32,#75
	.db	#101,#114,#110,#101,#108,#32,#69,#120
	.db	#112,#101,#114,#105,#101,#110,#99,#101
	.db	#100,#32,#65,#110,#32,#69,#114,#114
	.db	#111,#114,#10,#69,#114,#114,#111,#114
	.db	#32,#67,#111,#100,#101,#58,#32,#37
	.db	#117,#10,#83,#116,#111,#112,#112,#105
	.db	#110,#103,#10,#0
;	globl	panic
;	extrn	printf

;	0 error(s) in compilation
;	literal pool:60
;	global pool:2
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
mmu_proc_table_out:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$37:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$39
	jmp 	$40
$38:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$37
$39:
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	

	        aptb
        
	mspa	#4
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#128
	popb	
	abnd	
	jpz 	$41
	mspa	#4
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	

	            lbib	#0
	            mmus
            
	jmp 	$42
$41:
	lwia	#127

	            lbib	#0
	            mmus
            
$42:
	jmp 	$38
$40:
$36:
	mdsp	#2
	ret 	
mmu_set_page:
	mspa	#2
	lwpa	
  aptb

	mspa	#4
	lbpa	

        lbib  #0
        mmus
        
$43:
	ret 	
mmu_init_clear_table:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#32
	popb	
	swqa	
$45:
	mspa	#0
	lwpa	
	psha	
	lwia	#2048
	popb	
	ault	
	jpnz	$47
	jmp 	$48
$46:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$45
$47:
	mspa	#0
	lwpa	

            aptb
        
	lwia	#127

            lbib    #0
            mmus
        
	jmp 	$46
$48:
$44:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	mmu_proc_table_out
;	globl	mmu_set_page
;	globl	mmu_init_clear_table

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
palloc_new:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$37:
	mspa	#0
	lwpa	
	psha	
	lwia	#64
	popb	
	ault	
	jpnz	$39
	jmp 	$40
$38:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$37
$39:
	lwia	palloc_page_in_use
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	alng	
	jpz 	$41
	lwia	palloc_page_in_use
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#128
	popb	
	abor	
	jmp 	$36
$41:
	jmp 	$38
$40:
	lwia	#10
	psha	
	call	panic
	mdsp	#2
$36:
	mdsp	#2
	ret 	
palloc_free:
	lwia	palloc_page_in_use
	psha	
	mspa	#4
	lbpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
$42:
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	palloc_page_in_use
palloc_page_in_use:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0
;	globl	palloc_new
;	extrn	panic
;	globl	palloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
proc_init_table:
	mdsp	#-1
	mspa	#0
	psha	
	lwia	#0
	popb	
	sbqa	
$106:
	mspa	#0
	lbpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$108
	jmp 	$109
$107:
	mspa	#0
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	jmp 	$106
$108:
	lwia	proc_table
	psha	
	mspa	#2
	lbpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#63
	aadd	
	psha	
	mspa	#2
	lbpa	
	popb	
	sbqa	
	jmp 	$107
$109:
$105:
	mdsp	#1
	ret 	
proc_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$111:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$113
	jmp 	$114
$112:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$111
$113:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	alng	
	jpz 	$115
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	jmp 	$110
$115:
	jmp 	$112
$114:
	lwia	#11
	psha	
	call	panic
	mdsp	#2
$110:
	mdsp	#2
	ret 	
proc_get:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$117:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$119
	jmp 	$120
$118:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$117
$119:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#1
	aadd	
	lbpa	
	psha	
	mspa	#6
	lbpa	
	popb	
	aequ	
	jpz 	$122
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
$122:
	aclv	
	jpz 	$121
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	jmp 	$116
$121:
	jmp 	$118
$120:
	lwia	#0
	jmp 	$116
$116:
	mdsp	#2
	ret 	
proc_write_mem_map:
	mspa	#2
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
	psha	
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	call	mmu_proc_table_out
	mdsp	#4
$123:
	ret 	
proc_init_kernel_entry:
	mdsp	#-2
	mdsp	#-1
	mspa	#1
	psha	
	lwia	proc_table
	popb	
	swqa	
	mspa	#1
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	#0
	sbma	proc_current_pid
	mspa	#1
	lwpa	
	lwib	#1
	aadd	
	psha	
	lbma	proc_current_pid
	inca	
	sbma	proc_current_pid
	deca	
	popb	
	sbqa	
	mspa	#1
	lwpa	
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#1
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#255
	popb	
	sbqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	sbqa	
$125:
	mspa	#0
	lbpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$127
	jmp 	$128
$126:
	mspa	#0
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	jmp 	$125
$127:
	mspa	#1
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lbpa	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$126
$128:
	mspa	#1
	lwpa	
	psha	
	call	proc_write_mem_map
	mdsp	#2
$124:
	mdsp	#3
	ret 	
proc_init_mem_map:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$130:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#0
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$132
	jmp 	$133
$131:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$130
$132:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$131
$133:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$134:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#1
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$136
	jmp 	$137
$135:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$134
$136:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$135
$137:
	mspa	#2
	psha	
	lwia	#31
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$138:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#2
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$140
	jmp 	$141
$139:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$138
$140:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$139
$141:
$129:
	mdsp	#4
	ret 	
proc_new_entry:
	mdsp	#-2
	mspa	#0
	psha	
	call	proc_alloc
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#1
	aadd	
	psha	
	lbma	proc_current_pid
	inca	
	sbma	proc_current_pid
	deca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#6
	lbpa	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#3
	popb	
	sbqa	
	mspa	#0
	lwpa	
	jmp 	$142
$142:
	mdsp	#2
	ret 	
proc_load_mem:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#1
	aadd	
	psha	
	mspa	#12
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	psha	
	lwia	#11
	popb	
	ashr	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	sbqa	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#2
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#8
	lwpa	
	psha	
	call	proc_init_mem_map
	mdsp	#2
	mspa	#8
	lwpa	
	psha	
	call	proc_write_mem_map
	mdsp	#2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#14
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
$144:
	mspa	#4
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	kernel_map_in_mem
	mdsp	#4
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$147
	lwia	#1
	jmp 	$143
$147:
	mspa	#0
	psha	
	lwia	#2048
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	popb	
	swqa	
	mspa	#2
	psha	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
$145:
	mspa	#0
	lwpa	
	psha	
	lwia	#2048
	popb	
	aequ	
	jpnz	$144
$146:
	mspa	#2
	lwpa	
	psha	
	mspa	#12
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	aneq	
	jmp 	$143
$143:
	mdsp	#6
	ret 	
proc_create_new:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	lbpa	
	psha	
	call	proc_new_entry
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#1
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$149
	mspa	#2
	lwpa	
	psha	
	call	proc_put
	mdsp	#2
	lwia	#0
	jmp 	$148
$149:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	proc_load_mem
	mdsp	#4
	jpz 	$150
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#2
	lwpa	
	psha	
	call	proc_put
	mdsp	#2
	lwia	#0
	jmp 	$148
$150:
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#2
	lwpa	
	jmp 	$148
$148:
	mdsp	#4
	ret 	
proc_set_cpu_state:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	psha	
	mspa	#12
	lwpa	
	popb	
	swqa	
$151:
	ret 	
proc_begin_execute:
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aneq	
	jpz 	$153
	lwia	#1
	jmp 	$152
$153:
	mspa	#2
	lwpa	
	swma	proc_current_proc
	mspa	#2
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
  aptb

	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_a
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_b
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_sp
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_pc
	lwma	proc_begin_execute_reg_sp
  psha

	lwma	proc_begin_execute_reg_pc
  psha

	lwma	proc_begin_execute_reg_b
  xswp

	lwma	proc_begin_execute_reg_a
  ktou

	lwia	#12
	psha	
	call	panic
	mdsp	#2
$152:
	ret 	
proc_put:
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	psha	
	call	proc_put_memory
	mdsp	#2
$154:
	ret 	
proc_put_memory:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$156:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$158
	jmp 	$159
$157:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$156
$158:
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#128
	popb	
	abnd	
	jpz 	$160
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	psha	
	call	palloc_free
	mdsp	#2
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$161
$160:
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
$161:
	jmp 	$157
$159:
	mspa	#4
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
	psha	
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	call	mmu_proc_table_out
	mdsp	#4
$155:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	globl	proc_table
proc_table:
	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

;	globl	proc_current_pid
proc_current_pid:
	.db	#0
;	globl	proc_current_proc
proc_current_proc:
	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

proc_begin_execute_reg_a:
	.dw	#0
proc_begin_execute_reg_b:
	.dw	#0
proc_begin_execute_reg_sp:
	.dw	#0
proc_begin_execute_reg_pc:
	.dw	#0
;	globl	proc_init_table
;	globl	proc_alloc
;	extrn	panic
;	globl	proc_get
;	globl	proc_write_mem_map
;	extrn	mmu_proc_table_out
;	globl	proc_init_kernel_entry
;	extrn	palloc_new
;	globl	proc_init_mem_map
;	globl	proc_new_entry
;	globl	proc_load_mem
;	extrn	file_seek
;	extrn	kernel_map_in_mem
;	extrn	file_read
;	globl	proc_create_new
;	extrn	file_get
;	globl	proc_put
;	extrn	file_put
;	globl	proc_set_cpu_state
;	globl	proc_begin_execute
;	globl	proc_put_memory
;	extrn	palloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:43
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
kernel_init:
	call	mmu_init_clear_table
	call	fs_init
	call	proc_init_table
	call	proc_init_kernel_entry
$105:
	ret 	
kernel_map_in_mem:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#11
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#12
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#128
	popb	
	abnd	
	alng	
	jpz 	$107
	lwia	#0
	jmp 	$106
$107:
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	swqa	
	mspa	#4
	lwpa	
	psha	
	lwia	#31
	popb	
	aneq	
	jpz 	$108
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#128
	popb	
	abnd	
	alng	
	jpz 	$109
	lwia	#0
	jmp 	$106
$109:
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	swqa	
	jmp 	$110
$108:
	mspa	#0
	psha	
	lwia	#127
	popb	
	swqa	
$110:
	mspa	#2
	lwpa	
	psha	
	lwia	#29
	psha	
	call	mmu_set_page
	mdsp	#4
	mspa	#0
	lwpa	
	psha	
	lwia	#30
	psha	
	call	mmu_set_page
	mdsp	#4
	lwia	#29
	psha	
	lwia	#11
	popb	
	ashl	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#2047
	popb	
	abnd	
	popb	
	aadd	
	jmp 	$106
$106:
	mdsp	#6
	ret 	
;	Data Segment
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	globl	kernel_init
;	extrn	mmu_init_clear_table
;	extrn	fs_init
;	extrn	proc_init_table
;	extrn	proc_init_kernel_entry
;	globl	kernel_map_in_mem
;	extrn	mmu_set_page

;	0 error(s) in compilation
;	literal pool:0
;	global pool:21
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_int0_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#2
$65:
	ret 	
_int1_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#22
	psha	
	call	printf
	mdsp	#2
$66:
	ret 	
_int2_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#44
	psha	
	call	printf
	mdsp	#2
$67:
	ret 	
_int3_handler:
	lwia	$0+#66
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$69:
	lwia	#1
	jpz 	$70
	jmp 	$69
$70:
$68:
	ret 	
_int4_handler:
	lwia	$0+#83
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$72:
	lwia	#1
	jpz 	$73
	jmp 	$72
$73:
$71:
	ret 	
_int5_handler:
	lwia	$0+#100
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$75:
	lwia	#1
	jpz 	$76
	jmp 	$75
$76:
$74:
	ret 	
_int_reset_timer:
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	psha	
	call	outp
	mdsp	#4
$77:
	ret 	
;	Data Segment
$0:	.db	#83,#111,#109,#101,#116,#104,#105,#110
	.db	#103,#32,#119,#101,#110,#116,#32,#119
	.db	#114,#111,#110,#103,#10,#0,#83,#111
	.db	#109,#101,#116,#104,#105,#110,#103,#32
	.db	#119,#101,#110,#116,#32,#119,#114,#111
	.db	#110,#103,#10,#0,#83,#111,#109,#101
	.db	#116,#104,#105,#110,#103,#32,#119,#101
	.db	#110,#116,#32,#119,#114,#111,#110,#103
	.db	#10,#0,#73,#110,#116,#32,#51,#32
	.db	#116,#114,#105,#103,#103,#101,#114,#101
	.db	#100,#10,#0,#73,#110,#116,#32,#52
	.db	#32,#116,#114,#105,#103,#103,#101,#114
	.db	#101,#100,#10,#0,#73,#110,#116,#32
	.db	#53,#32,#116,#114,#105,#103,#103,#101
	.db	#114,#101,#100,#10,#0
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
int_handler_reg_a:
	.dw	#0
int_handler_reg_b:
	.dw	#0
int_handler_reg_sp:
	.dw	#0
int_handler_reg_pc:
	.dw	#0
;	globl	_int0_handler
;	extrn	proc_set_cpu_state
;	extrn	shed_shedule
;	extrn	printf
;	globl	_int1_handler
;	globl	_int2_handler
;	globl	_int3_handler
;	extrn	switch_to_user
;	globl	_int4_handler
;	globl	_int5_handler
;	globl	_int_reset_timer
;	extrn	outp

;	0 error(s) in compilation
;	literal pool:117
;	global pool:23
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
shed_shedule:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwma	proc_current_proc
	lwib	#63
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	swqa	
$66:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$68
	jmp 	$69
$67:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$66
$68:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	jpz 	$71
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aequ	
$71:
	aclv	
	jpz 	$70
	lwia	#100
	psha	
	call	_int_reset_timer
	mdsp	#2
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	psha	
	call	proc_begin_execute
	mdsp	#2
$70:
	jmp 	$67
$69:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$72:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aule	
	jpnz	$74
	jmp 	$75
$73:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$72
$74:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	jpz 	$77
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aequ	
$77:
	aclv	
	jpz 	$76
	lwia	#100
	psha	
	call	_int_reset_timer
	mdsp	#2
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	psha	
	call	proc_begin_execute
	mdsp	#2
$76:
	jmp 	$73
$75:
	lwia	#13
	psha	
	call	panic
	mdsp	#2
$65:
	mdsp	#4
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	globl	shed_shedule
;	extrn	_int_reset_timer
;	extrn	proc_begin_execute
;	extrn	panic

;	0 error(s) in compilation
;	literal pool:0
;	global pool:11
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
hexdump:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mspa	#5
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	popb	
	swqa	
$106:
	mspa	#3
	lwpa	
	psha	
	mspa	#13
	lwpa	
	popb	
	ault	
	jpnz	$108
	jmp 	$109
$107:
	mspa	#3
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$106
$108:
	mspa	#5
	lwpa	
	psha	
	mspa	#11
	lwpa	
	lbpa	
	psha	
	lwia	#4
	popb	
	ashr	
	popb	
	aadd	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	mspa	#5
	lwpa	
	psha	
	mspa	#11
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#15
	popb	
	abnd	
	popb	
	aadd	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	mspa	#0
	psha	
	mspa	#5
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccudiv
	xswp	
	psha	
	lwia	#9
	popb	
	aequ	
	popb	
	sbqa	
	mspa	#0
	lbpa	
	jpz 	$110
	lwia	#124
	jmp 	$111
$110:
	lwia	#32
$111:
	psha	
	call	putchar
	mdsp	#2
	mspa	#0
	lbpa	
	jpz 	$112
	mspa	#9
	psha	
	mspa	#11
	lwpa	
	psha	
	lwia	#10
	popb	
	asub	
	popb	
	swqa	
	mspa	#1
	psha	
	lwia	#0
	popb	
	swqa	
$113:
	mspa	#1
	lwpa	
	psha	
	lwia	#10
	popb	
	ault	
	jpnz	$115
	jmp 	$116
$114:
	mspa	#1
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$113
$115:
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#10
	popb	
	aneq	
	jpz 	$118
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#9
	popb	
	aneq	
$118:
	aclv	
	jpz 	$119
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#8
	popb	
	aneq	
$119:
	aclv	
	jpz 	$117
	mspa	#9
	lwpa	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$120
$117:
	lwia	#219
	psha	
	call	putchar
	mdsp	#2
$120:
	mspa	#9
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$114
$116:
$112:
	jmp 	$107
$109:
$105:
	mdsp	#7
	ret 	
list_dir:
	mdsp	#-2
	mdsp	#-14
	mspa	#14
	psha	
	mspa	#2
	psha	
	mspa	#22
	lwpa	
	psha	
	call	dir_next_entry
	mdsp	#4
	popb	
	swqa	
$122:
	mspa	#14
	lwpa	
	jpz 	$123
	mspa	#0
	psha	
	mspa	#16
	lwpa	
	psha	
	lwia	$0+#17
	psha	
	call	printf
	mdsp	#6
	mspa	#14
	psha	
	mspa	#2
	psha	
	mspa	#22
	lwpa	
	psha	
	call	dir_next_entry
	mdsp	#4
	popb	
	swqa	
	jmp 	$122
$123:
$121:
	mdsp	#16
	ret 	
debug:

        .db #254
        .db #1
    
$124:
	ret 	
switch_to_user:

        lbia    #0
        aptb
        prvu
    
$125:
	ret 	
switch_to_sys:

        lbia    #0
        aptb
        prvs
    
$126:
	ret 	
serial_load:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-8
	mdsp	#-1
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#11
	psha	
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	mspa	#25
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	popb	
	swqa	
	mspa	#13
	psha	
	lwia	#4
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
$128:
	lwia	#1
	jpz 	$129
	mspa	#2
	psha	
	call	serial_read
	popb	
	sbqa	
	mspa	#2
	lbpa	
	psha	
	call	serial_write
	mdsp	#2
	mspa	#0
	lwpa	
	psha	
	lwia	#3
	popb	
	aule	
	alng	
	jpz 	$130
	lwia	#1
	psha	
	mspa	#5
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#17
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#5
	popb	
	aadd	
	popb	
	swqa	
$130:
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#4
	lbpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$132
	mspa	#3
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#255
	popb	
	aequ	
$132:
	aclv	
	jpz 	$133
	mspa	#3
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#15
	popb	
	aequ	
$133:
	aclv	
	jpz 	$134
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#240
	popb	
	aequ	
$134:
	aclv	
	jpz 	$131
	mspa	#13
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	jmp 	$127
$131:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$128
$129:
$127:
	mdsp	#15
	ret 	
file_print:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mdsp	#-2
	mspa	#3
	psha	
	mspa	#11
	lwpa	
	psha	
	mspa	#15
	lwpa	
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#3
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$136
	mspa	#11
	lwpa	
	psha	
	lwia	$0+#25
	psha	
	call	printf
	mdsp	#4
	jmp 	$135
$136:
	mspa	#5
	psha	
	lwia	#1
	psha	
	mspa	#7
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
$137:
	lwia	#1
	psha	
	mspa	#2
	psha	
	mspa	#9
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$138
	mspa	#0
	lwpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$137
$138:
$135:
	mdsp	#7
	ret 	
main:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-3
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	call	switch_to_sys
	lwia	_MEM_END
	swma	brk
	lwia	$0+#43
	psha	
	call	printf
	mdsp	#2
	call	kernel_init
	lwia	$0+#59
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
	mspa	#11
	psha	
	lwia	#2
	popb	
	swqa	
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	lwia	buf
	psha	
	lwia	#2
	popb	
	aadd	
	swma	arg
$140:
	lwia	#1
	jpz 	$141
	mspa	#11
	lwpa	
	psha	
	lwia	$0+#74
	psha	
	call	printf
	mdsp	#4
	lwia	$0+#84
	psha	
	call	printf
	mdsp	#2
	lwia	buf
	psha	
	call	gets
	mdsp	#2
	mspa	#0
	psha	
	lwma	arg
	popb	
	swqa	
$142:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aneq	
	jpz 	$143
	jmp 	$142
$143:
	mspa	#0
	lwpa	
	swma	arg2
	mspa	#0
	lwpa	
	psha	
	lwia	buf
	psha	
	lwia	#256
	popb	
	aadd	
	popb	
	ault	
	jpz 	$145
	mspa	#0
	lwpa	
	psha	
	lwia	buf
	popb	
	ault	
	alng	
$145:
	aclv	
	jpz 	$144
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	psha	
	lwia	#0
	popb	
	sbqa	
$144:
	mspa	#19
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#23
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
	lwia	$146
	psha	
	lwia	buf
	psha	
	lwia	#0
	popb	
	aadd	
	lbpa	
	asex	
	jmp 	cccase
$148:
	call	fs_close

                .db #255
                
	jmp 	$147
$149:
	mspa	#19
	lwpa	
	psha	
	call	list_dir
	mdsp	#2
	jmp 	$147
$150:
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	mspa	#23
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	psha	
	lwia	$0+#87
	psha	
	call	printf
	mdsp	#10
	jmp 	$147
$151:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	dir_delete_file
	mdsp	#4
	jmp 	$147
$152:
	lwma	arg
	psha	
	lwma	arg
	psha	
	mspa	#15
	lwpa	
	psha	
	call	dir_name_inum
	mdsp	#4
	psha	
	lwia	$0+#91
	psha	
	call	printf
	mdsp	#6
	jmp 	$147
$153:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	dir_make_dir
	mdsp	#4
	jmp 	$147
$154:
	mspa	#13
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#13
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$155
	lwia	$0+#95
	psha	
	call	printf
	mdsp	#2
	jmp 	$147
$155:
	mspa	#11
	psha	
	mspa	#15
	lwpa	
	popb	
	swqa	
	mspa	#19
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	jmp 	$147
$156:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	serial_load
	mdsp	#4
	jmp 	$147
$157:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	file_print
	mdsp	#4
	jmp 	$147
$158:
	call	debug
	jmp 	$147
$159:
	call	switch_to_sys
	mspa	#4
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#17
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#100
	psha	
	call	proc_create_new
	mdsp	#4
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg2
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#15
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#101
	psha	
	call	proc_create_new
	mdsp	#4
	popb	
	swqa	
	mspa	#17
	lwpa	
	jpz 	$161
	mspa	#15
	lwpa	
$161:
	aclv	
	jpz 	$160
	call	shed_shedule
	jmp 	$162
$160:
	lwia	$0+#108
	psha	
	call	printf
	mdsp	#2
$162:
	call	switch_to_user
	jmp 	$147
$163:
	lwia	buf
	psha	
	lwia	#0
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	$0+#117
	psha	
	call	printf
	mdsp	#4
	jmp 	$147
	jmp 	$147
;	Data Segment
$146:
	.dw	#101,$148,#108,$149,#109,$150,#114,$151
	.dw	#105,$152,#100,$153,#99,$154,#115,$156
	.dw	#112,$157,#120,$158,#110,$159
	.dw	$163,#0
;	Code Segment
$147:
	jmp 	$140
$141:
$139:
	mdsp	#21
	ret 	
atoi:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$165:
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
	jpnz	$167
	jmp 	$168
$166:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$165
$167:
	jmp 	$166
$168:
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
	jpz 	$169
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
$169:
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$170:
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
	jpnz	$172
	jmp 	$173
$171:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$170
$172:
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
	jmp 	$171
$173:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	amul	
	jmp 	$164
$164:
	mdsp	#6
	ret 	
_isdigit:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#48
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#57
	popb	
	asle	
	popb	
	abnd	
	jpz 	$175
	lwia	#1
	jmp 	$174
	jmp 	$176
$175:
	lwia	#0
	jmp 	$174
$176:
$174:
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#97,#98,#99,#100,#101,#102
	.db	#0,#37,#117,#58,#32,#37,#115,#10
	.db	#0,#110,#111,#32,#115,#117,#99,#104
	.db	#32,#102,#105,#108,#101,#58,#32,#37
	.db	#115,#10,#0,#73,#110,#105,#116,#105
	.db	#110,#103,#32,#75,#101,#114,#110,#101
	.db	#108,#10,#0,#75,#101,#114,#110,#101
	.db	#108,#32,#73,#110,#105,#116,#101,#100
	.db	#10,#0,#10,#67,#87,#68,#58,#32
	.db	#37,#117,#10,#0,#36,#32,#0,#37
	.db	#117,#10,#0,#37,#117,#10,#0,#78
	.db	#111,#32,#115,#117,#99,#104,#32,#100
	.db	#105,#114,#10,#0,#70,#97,#105,#108
	.db	#117,#114,#101,#10,#0,#78,#111,#32
	.db	#115,#117,#99,#104,#32,#99,#111,#109
	.db	#109,#97,#110,#100,#58,#32,#37,#99
	.db	#10,#0
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	brk
;	extrn	_MEM_END
;	globl	buf
buf:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0
;	globl	arg
arg:
	.dw	#0
;	globl	arg2
arg2:
	.dw	#0
;	globl	arg3
arg3:
	.dw	#0
;	globl	hexdump
;	extrn	putchar
;	globl	list_dir
;	extrn	dir_next_entry
;	extrn	printf
;	globl	debug
;	globl	switch_to_user
;	globl	switch_to_sys
;	globl	serial_load
;	extrn	dir_make_file
;	extrn	file_get
;	extrn	serial_read
;	extrn	serial_write
;	extrn	file_write
;	extrn	file_put
;	globl	file_print
;	extrn	fs_path_to_inum
;	extrn	file_read
;	globl	main
;	extrn	kernel_init
;	extrn	gets
;	extrn	file_seek
;	extrn	fs_close
;	extrn	dir_delete_file
;	extrn	dir_name_inum
;	extrn	dir_make_dir
;	extrn	proc_create_new
;	extrn	shed_shedule
;	globl	atoi
;	globl	_isdigit

;	0 error(s) in compilation
;	literal pool:138
;	global pool:50
;	Macro pool:51
;	.end

_MEM_END:
;	Nothing else

