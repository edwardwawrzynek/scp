;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
abs:
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	mspa	#2
	lwpa	
	aneg	
	jmp 	$1
	mdsp	#0
	jmp 	$3
$2:
	mspa	#2
	lwpa	
	jmp 	$1
	mdsp	#0
$3:
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	abs

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
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
	mdsp	#0
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
	mdsp	#0
$6:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
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
	lwib	#1
	call	isdigit
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
	mdsp	#0
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
;	globl	atoi
;	extrn	isdigit

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:110
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
binary:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
$2:
	mspa	#6
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	asle	
	jpz 	$3
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	call	ccdiv
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#16
	lwpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwib	#2
	call	strcmp
	mdsp	#4
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$4
	mspa	#4
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
	mdsp	#0
	jmp 	$5
$4:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpz 	$6
	mspa	#6
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	swqa	
	mdsp	#0
	jmp 	$7
$6:
	mspa	#2
	lwpa	
	jmp 	$1
	mdsp	#0
$7:
	mdsp	#0
$5:
	jmp 	$2
$3:
	mdsp	#0
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#8
	ret 	
;	Data Segment
;	globl	binary
;	extrn	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
isalpha:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#97
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#122
	popb	
	asle	
	popb	
	abnd	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#65
	popb	
	aslt	
	alng	
	psha	
	mspa	#6
	lbpa	
	asex	
	psha	
	lwia	#90
	popb	
	asle	
	popb	
	abnd	
	popb	
	abor	
	jpz 	$2
	lwia	#1
	jmp 	$1
	mdsp	#0
	jmp 	$3
$2:
	lwia	#0
	jmp 	$1
	mdsp	#0
$3:
$1:
	mdsp	#0
	ret 	
isupper:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#65
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#90
	popb	
	asle	
	popb	
	abnd	
	jpz 	$5
	lwia	#1
	jmp 	$4
	mdsp	#0
	jmp 	$6
$5:
	lwia	#0
	jmp 	$4
	mdsp	#0
$6:
$4:
	mdsp	#0
	ret 	
islower:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#97
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#122
	popb	
	asle	
	popb	
	abnd	
	jpz 	$8
	lwia	#1
	jmp 	$7
	mdsp	#0
	jmp 	$9
$8:
	lwia	#0
	jmp 	$7
	mdsp	#0
$9:
$7:
	mdsp	#0
	ret 	
isdigit:
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
	jpz 	$11
	lwia	#1
	jmp 	$10
	mdsp	#0
	jmp 	$12
$11:
	lwia	#0
	jmp 	$10
	mdsp	#0
$12:
$10:
	mdsp	#0
	ret 	
isspace:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aequ	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#9
	popb	
	aequ	
	popb	
	abor	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#10
	popb	
	aequ	
	popb	
	abor	
	jpz 	$14
	lwia	#1
	jmp 	$13
	mdsp	#0
	jmp 	$15
$14:
	lwia	#0
	jmp 	$13
	mdsp	#0
$15:
$13:
	mdsp	#0
	ret 	
toupper:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#97
	popb	
	aslt	
	alng	
	jpz 	$17
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#122
	popb	
	asle	
$17:
	aclv	
	jpz 	$18
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	asub	
	jmp 	$19
$18:
	mspa	#2
	lbpa	
	asex	
$19:
	jmp 	$16
$16:
	mdsp	#0
	ret 	
tolower:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#65
	popb	
	aslt	
	alng	
	jpz 	$21
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#90
	popb	
	asle	
$21:
	aclv	
	jpz 	$22
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aadd	
	jmp 	$23
$22:
	mspa	#2
	lbpa	
	asex	
$23:
	jmp 	$20
$20:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	isalpha
;	globl	isupper
;	globl	islower
;	globl	isdigit
;	globl	isspace
;	globl	toupper
;	globl	tolower

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
gets:
	mdsp	#-1
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#7
	lwpa	
	popb	
	swqa	
$2:
	mspa	#2
	psha	
	lwib	#0
	call	getchar
	mdsp	#0
	popb	
	sbqa	
	psha	
	lwia	#10
	popb	
	aneq	
	jpz 	$4
	mspa	#2
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
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#8
	popb	
	aequ	
	jpz 	$5
	mspa	#0
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$6
	mspa	#0
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lwia	#32
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	lwia	#8
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
$6:
	mdsp	#0
	jmp 	$7
$5:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#21
	popb	
	aequ	
	jpz 	$8
	mspa	#0
	psha	
	mspa	#7
	lwpa	
	popb	
	swqa	
	lwia	#10
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	lwia	#35
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
	jmp 	$9
$8:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#4
	lbpa	
	asex	
	popb	
	sbqa	
	mdsp	#0
$9:
	mdsp	#0
$7:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpz 	$11
	mspa	#0
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	aequ	
$11:
	aclv	
	jpz 	$10
	lwia	#0
	jmp 	$1
	mdsp	#0
$10:
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#5
	lwpa	
	jmp 	$1
$1:
	mdsp	#3
	ret 	
;	Data Segment
;	globl	gets
;	extrn	getchar
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:128
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
index:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#10
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aneq	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$2
$4:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$6:
	mspa	#8
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aneq	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	aequ	
	popb	
	abnd	
	jpnz	$8
	jmp 	$9
$7:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$6
$8:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$7
$9:
	mdsp	#0
	mspa	#8
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$10
	mspa	#4
	lwpa	
	jmp 	$1
	mdsp	#0
$10:
	jmp 	$3
$5:
	mdsp	#0
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#6
	ret 	
;	Data Segment
;	globl	index

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:109
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
itoa:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	aneg	
	popb	
	swqa	
	mdsp	#0
$2:
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$3:
	mspa	#6
	lwpa	
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
	mspa	#10
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccdiv
	xswp	
	psha	
	lwia	#48
	popb	
	aadd	
	popb	
	sbqa	
$4:
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccdiv
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpnz	$3
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	mspa	#6
	lwpa	
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
	lwia	#45
	popb	
	sbqa	
	mdsp	#0
$6:
	mspa	#6
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#6
	lwpa	
	psha	
	lwib	#1
	call	reverse
	mdsp	#2
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	globl	itoa
;	extrn	reverse

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:109
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
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
	lwib	#1
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
	mdsp	#0
$1:
	mdsp	#0
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
$5:
	mspa	#4
	lwpa	
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	jpz 	$6
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
	jpz 	$7
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
	jpz 	$8
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
	jmp 	$9
$8:
	mspa	#6
	lbpa	
	psha	
	lwia	#105
	popb	
	aequ	
	jpnz	$11
	mspa	#6
	lbpa	
	psha	
	lwia	#100
	popb	
	aequ	
$11:
	aclv	
	jpz 	$10
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
	lwib	#2
	call	_sprintn
	mdsp	#4
	mdsp	#0
	jmp 	$12
$10:
	mspa	#6
	lbpa	
	psha	
	lwia	#117
	popb	
	aequ	
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
	lwib	#2
	call	_uprintn
	mdsp	#4
	mdsp	#0
	jmp 	$14
$13:
	mspa	#6
	lbpa	
	psha	
	lwia	#115
	popb	
	aequ	
	jpz 	$15
	mspa	#2
	lwpa	
	psha	
	mspa	#9
	lwpa	
	popb	
	asub	
	lwpa	
	psha	
	lwib	#1
	call	_print
	mdsp	#2
	mdsp	#0
	jmp 	$16
$15:
	mspa	#6
	lbpa	
	psha	
	lwia	#120
	popb	
	aequ	
	jpz 	$17
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
	lwib	#2
	call	_uprintn
	mdsp	#4
	mdsp	#0
$17:
	mdsp	#0
$16:
	mdsp	#0
$14:
	mdsp	#0
$12:
	mdsp	#0
$9:
	mspa	#7
	psha	
	lwpa	
	psha	
	lwia	#2
	popb	
	aadd	
	popb	
	swqa	
	mdsp	#0
	jmp 	$18
$7:
	mspa	#6
	lbpa	
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
$18:
	jmp 	$5
$6:
	mdsp	#0
$4:
	mdsp	#9
	ret 	
;	Data Segment
;	globl	_print
;	extrn	putchar
;	globl	printf
;	extrn	_sprintn
;	extrn	_uprintn

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:103
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
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
	lwib	#1
	call	putchar
	mdsp	#2
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	aneg	
	popb	
	swqa	
	mdsp	#0
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
	lwib	#2
	call	_sprintn
	mdsp	#4
	mdsp	#0
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
	lwib	#1
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
	lwib	#2
	call	_uprintn
	mdsp	#4
	mdsp	#0
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
	lwib	#1
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
;	globl	_sprintn
;	extrn	putchar
;	globl	_uprintn

;	0 error(s) in compilation
;	literal pool:34
;	global pool:3
;	Macro pool:129
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
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
	lwib	#1
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
	mdsp	#0
	lwia	#10
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	puts
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:110
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
reverse:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mspa	#3
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#1
	psha	
	mspa	#9
	lwpa	
	psha	
	lwib	#1
	call	strlen
	mdsp	#2
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	swqa	
$2:
	mspa	#3
	lwpa	
	psha	
	mspa	#3
	lwpa	
	popb	
	aslt	
	jpz 	$3
	mspa	#0
	psha	
	mspa	#9
	lwpa	
	psha	
	mspa	#7
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#7
	lwpa	
	psha	
	mspa	#5
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#9
	lwpa	
	psha	
	mspa	#5
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#7
	lwpa	
	psha	
	mspa	#3
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#2
	lbpa	
	asex	
	popb	
	sbqa	
	mspa	#3
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	mspa	#1
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jmp 	$2
$3:
	mdsp	#0
	mspa	#7
	lwpa	
	jmp 	$1
$1:
	mdsp	#5
	ret 	
;	Data Segment
;	globl	reverse
;	extrn	strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
shellsort:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#2
	popb	
	call	ccdiv
	popb	
	swqa	
$2:
	mspa	#6
	lwpa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#2
	popb	
	call	ccdiv
	popb	
	swqa	
	jmp 	$2
$4:
	mspa	#4
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$6:
	mspa	#4
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	aslt	
	jpnz	$8
	jmp 	$9
$7:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$6
$8:
	mspa	#2
	psha	
	mspa	#6
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	asub	
	popb	
	swqa	
$10:
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	alng	
	jpnz	$12
	jmp 	$13
$11:
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	jmp 	$10
$12:
	mspa	#12
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	aadd	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwib	#2
	call	strcmp
	mdsp	#4
	psha	
	lwia	#0
	popb	
	asle	
	jpz 	$14
	mdsp	#0
	jmp 	$13
	mdsp	#0
$14:
	mspa	#0
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#12
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwia	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	aadd	
	lwia	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#12
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	aadd	
	lwia	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
	jmp 	$11
$13:
	mdsp	#0
	jmp 	$7
$9:
	mdsp	#0
	jmp 	$3
$5:
	mdsp	#0
$1:
	mdsp	#8
	ret 	
;	Data Segment
;	globl	shellsort
;	extrn	strcmp

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
strcat:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$2:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	jpz 	$3
	jmp 	$2
$3:
	mdsp	#0
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	asex	
$4:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
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
	popb	
	sbqa	
	jpz 	$5
	jmp 	$4
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strcat

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcmp:
$2:
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	popb	
	aequ	
	jpz 	$3
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$4
	lwia	#0
	jmp 	$1
	mdsp	#0
$4:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#4
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	asex	
	popb	
	asub	
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$2:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
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
	popb	
	sbqa	
	jpz 	$3
	jmp 	$2
$3:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strlen:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	jpz 	$3
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$2
$3:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
srand:
	mspa	#2
	lwpa	
	swma	xxseed
$1:
	mdsp	#0
	ret 	
rand:
	lwma	xxseed
	psha	
	lwia	#251
	popb	
	amul	
	psha	
	lwia	#123
	popb	
	aadd	
	swma	xxseed
	lwma	xxseed
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$3
	lwma	xxseed
	aneg	
	swma	xxseed
	mdsp	#0
$3:
	lwma	xxseed
	jmp 	$2
$2:
	mdsp	#0
	ret 	
getrand:
	lwia	$0+#0
	psha	
	lwib	#1
	call	puts
	mdsp	#2
	lwib	#0
	call	getchar
	mdsp	#0
	psha	
	lwia	#123
	popb	
	amul	
	jmp 	$4
$4:
	mdsp	#0
	ret 	
;	Data Segment
$0:	.db	#84,#121,#112,#101,#32,#97,#32,#99
	.db	#104,#97,#114,#97,#99,#116,#101,#114
	.db	#0
;	globl	xxseed
xxseed:
	.dw	#0
;	globl	srand
;	globl	rand
;	globl	getrand
;	extrn	puts
;	extrn	getchar

;	0 error(s) in compilation
;	literal pool:17
;	global pool:6
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncat:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
$2:
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	jpz 	$3
	jmp 	$2
$3:
	mdsp	#0
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
$4:
	mspa	#8
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
	asex	
	popb	
	sbqa	
	jpz 	$5
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	sbqa	
	mdsp	#0
	jmp 	$5
	mdsp	#0
$6:
	jmp 	$4
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strncat

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncmp:
$2:
	mspa	#2
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	alng	
	jpz 	$4
	mspa	#6
	lwpa	
	lbpa	
	asex	
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
	popb	
	aequ	
$4:
	aclv	
	jpz 	$3
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
	lwia	#0
	popb	
	aequ	
	jpz 	$5
	lwia	#0
	jmp 	$1
	mdsp	#0
$5:
	jmp 	$2
$3:
	mdsp	#0
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	lwia	#0
	jmp 	$7
$6:
	mspa	#6
	lwpa	
	lbpa	
	asex	
	psha	
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
	asex	
	popb	
	asub	
$7:
	jmp 	$1
$1:
	mdsp	#0
	ret 	
;	Data Segment
;	globl	strncmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncpy:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$2:
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aslt	
	jpnz	$4
	jmp 	$5
$3:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$2
$4:
	mspa	#10
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#10
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	popb	
	sbqa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$6
$7:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aslt	
	jpz 	$8
	mspa	#10
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
	jmp 	$7
$8:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
	mdsp	#0
$6:
	jmp 	$3
$5:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	globl	strncpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

