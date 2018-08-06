;	Runtime start off for smallc on SCP
;	For now, the stack pointer doesn't need to be changed
;	This expects an adequete number of pages have been mapped in to memory on start

;	Call main
	call	main
;	Halt
	.db	#255
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
outp:
	mspa	#4
	lbpa	
	xswp	
	mspa	#2
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
	mdsp	#-12
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
	mspa	#18
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwib	#0
	aadd	
	psha	
	mspa	#16
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
	lwma	brk
	psha	
	mspa	#2
	psha	
	lwia	#12
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
	mspa	#14
	lwpa	
	jpz 	$2
	mspa	#14
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
	lwia	#12
	psha	
	mspa	#20
	lwpa	
	popb	
	aadd	
	popb	
	aadd	
	swma	brk
	lwma	brk
	psha	
	mspa	#18
	lwpa	
	popb	
	asub	
	jmp 	$1
$1:
	mdsp	#12
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
	lwia	#12
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
	lbib	#1
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
	lwib	#6
	aadd	
	lbpa	
	jpz 	$10
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#12
	popb	
	aadd	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	_malloc_combine
	mdsp	#2
$10:
$9:
$8:
$4:
	ret 	
kmalloc:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-12
	mdsp	#-2
	mspa	#18
	psha	
	lwma	_malloc_head
	popb	
	swqa	
$12:
	mspa	#18
	lwpa	
	jpz 	$13
	mspa	#18
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#24
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$15
	mspa	#18
	lwpa	
	lwib	#6
	aadd	
	lbpa	
$15:
	aclv	
	jpz 	$14
	mspa	#18
	lwpa	
	lwib	#6
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#16
	psha	
	mspa	#20
	lwpa	
	popb	
	swqa	
	mspa	#14
	psha	
	mspa	#20
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#26
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#14
	lwpa	
	psha	
	lwia	#12
	popb	
	aule	
	alng	
	jpz 	$16
	mspa	#18
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#24
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwib	#4
	aadd	
	psha	
	mspa	#16
	lwpa	
	psha	
	lwia	#12
	popb	
	asub	
	popb	
	swqa	
	mspa	#2
	lwib	#6
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#2
	lwib	#0
	aadd	
	psha	
	mspa	#20
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwib	#2
	aadd	
	psha	
	mspa	#20
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#18
	lwpa	
	psha	
	lwia	#12
	popb	
	aadd	
	psha	
	mspa	#26
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	psha	
	lwia	#12
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
	mspa	#18
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	jpz 	$17
	mspa	#18
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
	jmp 	$18
$17:
	mspa	#0
	lwpa	
	swma	_malloc_tail
$18:
	mspa	#18
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
$16:
	mspa	#16
	lwpa	
	psha	
	lwia	#12
	popb	
	aadd	
	jmp 	$11
$14:
	mspa	#18
	psha	
	mspa	#20
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
	jmp 	$12
$13:
	mspa	#22
	lwpa	
	psha	
	lwma	_malloc_tail
	psha	
	lbib	#2
	call	_malloc_new
	mdsp	#4
	jmp 	$11
$11:
	mdsp	#20
	ret 	
kcalloc:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
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
	lbib	#1
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
$20:
	mspa	#4
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
	lwia	#0
	popb	
	sbqa	
	jmp 	$20
$21:
	mspa	#2
	lwpa	
	jmp 	$19
$19:
	mdsp	#6
	ret 	
kfree:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#12
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
	lbib	#1
	call	_malloc_combine
	mdsp	#2
$22:
	mdsp	#2
	ret 	
krealloc:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#12
	popb	
	asub	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	kfree
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$23
$23:
	mdsp	#4
	ret 	
;	Data Segment
;	globl	brk
brk:
	.dw	#0
;	globl	_malloc_head
_malloc_head:
	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.ds	#5

;	globl	_malloc_tail
_malloc_tail:
	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.ds	#5

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
memcmp:
$2:
	mspa	#2
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$3
	mspa	#6
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	aneq	
	jpz 	$4
	mspa	#6
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	asub	
	jmp 	$1
$4:
	mspa	#6
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
	jmp 	$2
$3:
	lwia	#0
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	memcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
memcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
$2:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$3
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
	jmp 	$2
$3:
	mspa	#8
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	memcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
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
	lbib	#1
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
$1:
	ret 	
_print_at:
$5:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	jpz 	$6
	lwia	#5
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	jmp 	$5
$6:
$4:
	ret 	
printf:
	mdsp	#-2
	mdsp	#-1
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	swpb	
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#2
	popb	
	amul	
	popb	
	swqa	
	mspa	#2
	xswp	
	mspa	#0
	swqa	
	mspa	#4
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#9
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#7
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#7
	psha	
	lwia	#0
	popb	
	swqa	
$8:
	mspa	#4
	lwpa	
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	jpz 	$9
	mspa	#6
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lwpa	
	popb	
	sbqa	
	mspa	#6
	lbpa	
	psha	
	lwia	#37
	popb	
	aequ	
	jpz 	$10
	mspa	#6
	psha	
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lwpa	
	popb	
	sbqa	
	mspa	#6
	lbpa	
	psha	
	lwia	#99
	popb	
	aequ	
	jpz 	$11
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lbib	#1
	call	putchar
	mdsp	#2
	jmp 	$12
$11:
	mspa	#6
	lbpa	
	psha	
	lwia	#105
	popb	
	aequ	
	jpnz	$14
	mspa	#6
	lbpa	
	psha	
	lwia	#100
	popb	
	aequ	
$14:
	aclv	
	jpz 	$13
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lwia	#10
	psha	
	lbib	#2
	call	_sprintn
	mdsp	#4
	jmp 	$15
$13:
	mspa	#6
	lbpa	
	psha	
	lwia	#117
	popb	
	aequ	
	jpz 	$16
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lwia	#10
	psha	
	lbib	#2
	call	_uprintn
	mdsp	#4
	jmp 	$17
$16:
	mspa	#6
	lbpa	
	psha	
	lwia	#115
	popb	
	aequ	
	jpz 	$18
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lbib	#1
	call	_print
	mdsp	#2
	jmp 	$19
$18:
	mspa	#6
	lbpa	
	psha	
	lwia	#120
	popb	
	aequ	
	jpz 	$20
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lwia	#16
	psha	
	lbib	#2
	call	_uprintn
	mdsp	#4
$20:
$19:
$17:
$15:
$12:
	mspa	#7
	psha	
	lwpa	
	psha	
	lwia	#2
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$21
$10:
	mspa	#6
	lbpa	
	psha	
	lbib	#1
	call	putchar
	mdsp	#2
$21:
	jmp 	$8
$9:
$7:
	mdsp	#9
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

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_sprintn:
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	lwia	#45
	psha	
	lbib	#1
	call	putchar
	mdsp	#2
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	aneg	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#10
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
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	lbib	#2
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
	mspa	#10
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	call	ccdiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lbib	#1
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
	mspa	#10
	lwpa	
	psha	
	mspa	#10
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
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	lbib	#2
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
	mspa	#10
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	call	ccudiv
	xswp	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lbib	#1
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
	lbib	#2
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
	lbib	#1
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
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	mspa	#2
	lwpa	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	jmp 	$3
$5:
	lwia	#960
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
	lwia	#1000
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
	lwia	#5
	psha	
	mspa	#2
	lwpa	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	lwia	#0
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	jmp 	$10
$12:
	lwia	#960
	swma	_screenpos
$8:
	mdsp	#2
	ret 	
putchar:
	lwma	_screenpos
	psha	
	lwia	#1000
	popb	
	ault	
	alng	
	jpz 	$14
	lbib	#0
	call	_screenscroll
$14:
	mspa	#2
	lbpa	
	psha	
	lwia	#10
	popb	
	aequ	
	jpz 	$15
	lbib	#0
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
	lwia	#5
	psha	
	lwma	_screenpos
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	lwia	#0
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	jmp 	$20
$19:
	lwia	#5
	psha	
	lwma	_screenpos
	inca	
	swma	_screenpos
	deca	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#6
	psha	
	mspa	#4
	lbpa	
	psha	
	lbib	#2
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
	.dw	#960
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
disk_init:
	lwia	#13
	psha	
	lwia	#1
	psha	
	lbib	#2
	call	outp
	mdsp	#4
$2:
	lwia	#13
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	jpz 	$3
	jmp 	$2
$3:
	lwia	#14
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	ret 	
disk_read:
$5:
	lwia	#13
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	jpz 	$6
	jmp 	$5
$6:
	lwia	#14
	psha	
	mspa	#6
	lwpa	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#16
	psha	
	lwia	#1
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#16
	psha	
	lwia	#0
	psha	
	lbib	#2
	call	outp
	mdsp	#4
$7:
	lwia	#13
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	jpz 	$8
	jmp 	$7
$8:
$9:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#15
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	popb	
	sbqa	
	lwia	#15
	psha	
	lwia	#0
	psha	
	lbib	#2
	call	outp
	mdsp	#4
$10:
	lwia	#16
	psha	
	lbib	#1
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
	lbib	#1
	call	inp
	mdsp	#2
	jpz 	$14
	jmp 	$13
$14:
	lwia	#14
	psha	
	mspa	#6
	lwpa	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
$15:
	lwia	#17
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lbib	#2
	call	outp
	mdsp	#4
$16:
	lwia	#18
	psha	
	lbib	#1
	call	inp
	mdsp	#2
	jpnz	$15
$17:
	lwia	#18
	psha	
	lwia	#1
	psha	
	lbib	#2
	call	outp
	mdsp	#4
	lwia	#18
	psha	
	lwia	#0
	psha	
	lbib	#2
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
;	Macro pool:573
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
$2:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$2
$4:
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
	jpz 	$6
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
	lbib	#1
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
	lwib	#2
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	mspa	#4
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
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#2
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
	jmp 	$1
$6:
	jmp 	$3
$5:
	lwia	#1
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$1:
	mdsp	#2
	ret 	
buffer_get:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$8:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$10
	jmp 	$11
$9:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$8
$10:
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
	jpz 	$12
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
	jmp 	$7
$12:
	jmp 	$9
$11:
	mspa	#4
	lwpa	
	psha	
	lbib	#1
	call	buffer_alloc
	mdsp	#2
	jmp 	$7
$7:
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
	jpz 	$14
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	kfree
	mdsp	#2
$14:
$13:
	ret 	
buffer_flush_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$16:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$18
	jmp 	$19
$17:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$16
$18:
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
	lwia	buffer_table
	psha	
	mspa	#4
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
	jmp 	$17
$19:
$15:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
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
;	global pool:16
;	Macro pool:1284
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
	lwia	superblk
	lwib	#2
	aadd	
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
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
$2:
	mspa	#2
	lwpa	
	psha	
	lwia	#65535
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
	lwia	#255
	popb	
	abnd	
	alng	
	jpz 	$6
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
	call	disk_read
	mdsp	#4
$6:
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
	jpz 	$7
	mspa	#2
	lwpa	
	jmp 	$1
$7:
	jmp 	$3
$5:
	lwia	#2
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$1:
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
$9:
	mspa	#8
	lwpa	
	lwpa	
	jpz 	$10
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
	mspa	#4
	lwpa	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
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
	jpz 	$11
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
	mspa	#4
	lwpa	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
$11:
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
	jmp 	$9
$10:
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
	mspa	#4
	lwpa	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
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
	jpz 	$12
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
	mspa	#4
	lwpa	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
$12:
$8:
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
	mspa	#10
	lwpa	
	popb	
	swqa	
$14:
	lwia	#1
	jpz 	$15
	mspa	#8
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
	call	disk_read
	mdsp	#4
	mspa	#8
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#12
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
	mspa	#8
	lwpa	
	alng	
	jpnz	$17
	mspa	#8
	lwpa	
	psha	
	lwia	#65535
	popb	
	aequ	
$17:
	aclv	
	jpz 	$16
	lwia	#0
	jmp 	$13
$16:
	mspa	#8
	lwpa	
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$18
	mspa	#2
	lwpa	
	psha	
	lwia	#129
	popb	
	ault	
	alng	
	jpz 	$19
	lwia	#4
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$19:
	mspa	#6
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
	lbib	#1
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	balloc_get_buf
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
	mspa	#0
	lwpa	
	jmp 	$13
$18:
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
	mspa	#10
	lwpa	
	popb	
	swqa	
	jmp 	$14
$15:
$13:
	mdsp	#4
	ret 	
balloc_free:
	mdsp	#-2
$21:
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
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
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	lwia	balloc_buffer
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
$22:
	mspa	#4
	lwpa	
	jpz 	$24
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aneq	
$24:
	aclv	
	jpz 	$25
	mspa	#4
	lwpa	
	psha	
	lwia	#65535
	popb	
	aneq	
$25:
	aclv	
	jpnz	$21
$23:
$20:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
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
;	global pool:17
;	Macro pool:1284
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
superblock_read:
	lwia	#383
	psha	
	lwia	fs_global_buf
	psha	
	lbib	#2
	call	disk_read
	mdsp	#4
	lwia	superblk
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#13
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
$1:
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
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
;	global pool:10
;	Macro pool:769
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
$2:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$2
$4:
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
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$6
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$1
$6:
	jmp 	$3
$5:
	lwia	#3
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$1:
	mdsp	#2
	ret 	
inode_load:
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$8
	lwia	#5
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$8:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#10
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
	mspa	#8
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
	mspa	#2
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	lbib	#2
	call	disk_read
	mdsp	#4
	mspa	#8
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#8
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
$7:
	mdsp	#4
	ret 	
inode_write:
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$10
	lwia	#5
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$10:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#10
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
	mspa	#8
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
	mspa	#2
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	lbib	#2
	call	disk_read
	mdsp	#4
	lwia	fs_global_buf
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#8
	psha	
	lbib	#3
	call	memcpy
	mdsp	#6
	mspa	#2
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	lbib	#2
	call	disk_write
	mdsp	#4
$9:
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
$12:
	mspa	#2
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$14
	jmp 	$15
$13:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$12
$14:
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
	jpz 	$17
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
	lbpa	
$17:
	aclv	
	jpz 	$16
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
	jmp 	$11
$16:
	jmp 	$13
$15:
	mspa	#0
	psha	
	lbib	#0
	call	inode_alloc
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	lbib	#2
	call	inode_load
	mdsp	#4
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$18
	lwia	#7
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$18:
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
	lwib	#5
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwib	#13
	aadd	
	psha	
	lbib	#2
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
	jpz 	$19
	lwia	#6
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$19:
	mspa	#0
	lwpa	
	jmp 	$11
$11:
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
	mspa	#2
	lwpa	
	lwib	#10
	aadd	
	lbpa	
	alng	
	jpz 	$21
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	kfree
	mdsp	#2
	mspa	#2
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwib	#8
	aadd	
	lwpa	
	psha	
	lbib	#2
	call	inode_write
	mdsp	#4
$21:
$20:
	ret 	
inode_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$23:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$25
	jmp 	$26
$24:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$23
$25:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	psha	
	lbib	#1
	call	inode_put
	mdsp	#2
	jmp 	$24
$26:
$22:
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
$28:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$29:
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
	jpnz	$28
$30:
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#6
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
	lbib	#2
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
	lbib	#0
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
	lbib	#1
	call	balloc_put
	mdsp	#2
$27:
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
	lbib	#1
	call	balloc_free
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#5
	aadd	
	psha	
	lbib	#0
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
	lbib	#1
	call	balloc_put
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	kfree
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	mspa	#12
	lwpa	
	lwib	#13
	aadd	
	psha	
	lbib	#2
	call	balloc_get
	mdsp	#4
	popb	
	swqa	
$31:
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
$33:
	mspa	#18
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	jpnz	$35
	jmp 	$36
$34:
	mspa	#18
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$33
$35:
	mspa	#4
	psha	
	mspa	#20
	lwpa	
	psha	
	lbib	#2
	call	inode_load
	mdsp	#4
	mspa	#4
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$37
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
	lwia	#0
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
	mspa	#26
	lwpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#1
	aadd	
	psha	
	mspa	#24
	lbpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#5
	aadd	
	psha	
	lbib	#0
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
	lbib	#1
	call	balloc_put
	mdsp	#2
	mspa	#4
	psha	
	mspa	#20
	lwpa	
	psha	
	lbib	#2
	call	inode_write
	mdsp	#4
	mspa	#18
	lwpa	
	jmp 	$32
$37:
	jmp 	$34
$36:
	lwia	#8
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$32:
	mdsp	#20
	ret 	
inode_delete:
	mdsp	#-14
	mspa	#0
	psha	
	mspa	#18
	lwpa	
	psha	
	lbib	#2
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
	lbib	#1
	call	balloc_free
	mdsp	#2
	mspa	#0
	psha	
	mspa	#18
	lwpa	
	psha	
	lbib	#2
	call	inode_write
	mdsp	#4
$38:
	mdsp	#14
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
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
;	global pool:27
;	Macro pool:1284
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
$2:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$2
$4:
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	alng	
	jpz 	$6
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	jmp 	$1
$6:
	jmp 	$3
$5:
	lwia	#9
	psha	
	lbib	#1
	call	panic
	mdsp	#2
$1:
	mdsp	#2
	ret 	
file_get:
	mdsp	#-2
	mspa	#0
	psha	
	lbib	#0
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
	mspa	#6
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
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	inode_get
	mdsp	#2
	popb	
	swqa	
	mspa	#4
	lbpa	
	psha	
	lwia	#4
	popb	
	abnd	
	jpz 	$8
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	inode_truncate
	mdsp	#2
$8:
	mspa	#4
	lbpa	
	psha	
	lwia	#8
	popb	
	abnd	
	jpz 	$9
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
$9:
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
	jpz 	$10
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	inode_add_blk
	mdsp	#2
$10:
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
	lbib	#1
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	jmp 	$7
$7:
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
	jpz 	$12
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	inode_put
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	buffer_put
	mdsp	#2
$12:
$11:
	ret 	
file_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$14:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$16
	jmp 	$17
$15:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$14
$16:
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	psha	
	lbib	#1
	call	file_put
	mdsp	#2
	jmp 	$15
$17:
$13:
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
$19:
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
	jpz 	$20
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lbib	#1
	call	inode_add_blk
	mdsp	#2
	jmp 	$19
$20:
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
	jpz 	$21
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	lbib	#1
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
	lbib	#1
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
$21:
$18:
	mdsp	#2
	ret 	
file_write:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	mspa	#8
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#2
	popb	
	abnd	
	alng	
	jpz 	$23
	lwia	#0
	jmp 	$22
$23:
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	file_set_buf
	mdsp	#2
$24:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$25
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$26
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	file_set_buf
	mdsp	#2
$26:
	mspa	#8
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#10
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
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#10
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
	jpz 	$27
	mspa	#8
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	popb	
	swqa	
$27:
	jmp 	$24
$25:
	mspa	#0
	lwpa	
	jmp 	$22
$22:
	mdsp	#2
	ret 	
file_read:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	mspa	#8
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	abnd	
	alng	
	jpz 	$29
	lwia	#0
	jmp 	$28
$29:
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	file_set_buf
	mdsp	#2
$30:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$31
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#10
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
	jpz 	$32
	mspa	#0
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	asub	
	jmp 	$28
$32:
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$33
	mspa	#8
	lwpa	
	psha	
	lbib	#1
	call	file_set_buf
	mdsp	#2
$33:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#10
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#12
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
	jmp 	$30
$31:
	mspa	#0
	lwpa	
	jmp 	$28
$28:
	mdsp	#2
	ret 	
file_seek:
	lwia	$35
	psha	
	mspa	#4
	lbpa	
	jmp 	cccase
$37:
	mspa	#6
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
	jmp 	$36
$38:
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#8
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
	jmp 	$36
$39:
$40:
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	jmp 	$36
	jmp 	$36
;	Data Segment
$35:
	.dw	#2,$37,#3,$38,#1,$39
	.dw	$40,#0
;	Code Segment
$36:
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$34
$34:
	ret 	
file_tell:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$41
$41:
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
;	globl	file_table
file_table:
	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
	.dw	#0
	.db	#0
	.db	#0

	.dw	#0
	.dw	#0
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
;	global pool:23
;	Macro pool:1284
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
fs_init:
	lbib	#0
	call	superblock_read
$1:
	ret 	
fs_close:
	lbib	#0
	call	file_put_all
	lbib	#0
	call	inode_put_all
	lbib	#0
	call	buffer_flush_all
$2:
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
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
;	globl	fs_init
;	extrn	superblock_read
;	globl	fs_close
;	extrn	file_put_all
;	extrn	inode_put_all
;	extrn	buffer_flush_all

;	0 error(s) in compilation
;	literal pool:0
;	global pool:13
;	Macro pool:769
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
panic:
	lwia	$0+#0
	psha	
	mspa	#4
	lbpa	
	psha	
	lbib	#2
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
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
;	globl	panic
;	extrn	printf

;	0 error(s) in compilation
;	literal pool:60
;	global pool:8
;	Macro pool:769
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
main:
$1:
	ret 	
;	Data Segment
;	extrn	superblk
;	extrn	some_value
;	extrn	buffer_table
;	extrn	inode_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	brk
;	extrn	_MEM_END
;	globl	main

;	0 error(s) in compilation
;	literal pool:0
;	global pool:9
;	Macro pool:769
;	.end

;	for kmalloc before sutable sbrk
_MEM_END:
;	Nothing much
