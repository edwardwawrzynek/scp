;	Small C
;	Small C Processor Backend Coder(Mostly Works)
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
	mspa	#16
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
	mspa	#14
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
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
	jmp 	$7
$6:
	mspa	#2
	lwpa	
	jmp 	$1
$7:
$5:
	jmp 	$2
$3:
	lwia	#1
	aneg	
	jmp 	$1
$1:
	mdsp	#8
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	binary
;	extrn	strcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:494
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
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
	mspa	#14
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
	mspa	#14
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
	mspa	#10
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	aadd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	call	strcmp
	mdsp	#4
	psha	
	lwia	#0
	popb	
	asle	
	jpz 	$14
	jmp 	$13
$14:
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#10
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	aadd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#10
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	aadd	
	lbib	#2
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
	jmp 	$7
$9:
	jmp 	$3
$5:
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
;	Small C Processor Backend Coder(Mostly Works)
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
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:494
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcat:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
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
	jpz 	$3
	jmp 	$2
$3:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	lbpa	
$4:
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
	jpz 	$5
	jmp 	$4
$5:
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
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strcmp:
$2:
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
	jpz 	$3
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
	jpz 	$4
	lwia	#0
	jmp 	$1
$4:
	jmp 	$2
$3:
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
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	strcmp

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
strcpy:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
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
	jpz 	$3
	jmp 	$2
$3:
	mspa	#0
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	strcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:494
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
;	Data Segment
;	globl	strchr

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
strstr:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	psha	
	call	strlen
	mdsp	#2
	popb	
	swqa	
$2:
	mspa	#4
	lwpa	
	lbpa	
	jpz 	$3
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	call	memcmp
	mdsp	#6
	alng	
	jpz 	$4
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	jmp 	$1
$4:
	jmp 	$2
$3:
	lwia	#0
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	strstr
;	extrn	strlen
;	extrn	memcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:51
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncat:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
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
	jpz 	$3
	jmp 	$2
$3:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
$4:
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
	jpz 	$5
	mspa	#8
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
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$5
$6:
	jmp 	$4
$5:
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
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
strncmp:
$2:
	mspa	#6
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
$4:
	aclv	
	jpz 	$3
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
	jpz 	$5
	lwia	#0
	jmp 	$1
$5:
	jmp 	$2
$3:
	mspa	#6
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	lwia	#0
	jmp 	$7
$6:
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
$7:
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	strncmp

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
strncpy:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
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
	mspa	#12
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
	mspa	#6
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
	mspa	#12
	lwpa	
	popb	
	aslt	
	jpz 	$8
	mspa	#6
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
	mspa	#0
	lwpa	
	jmp 	$1
$6:
	jmp 	$3
$5:
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

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
memcmp:
$2:
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$3
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	lbpa	
	popb	
	aneq	
	jpz 	$4
	mspa	#2
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
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
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
	mspa	#6
	lwpa	
	popb	
	swqa	
$2:
	mspa	#8
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
	mspa	#4
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
memchr:
$2:
	mspa	#6
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$3
	mspa	#2
	lwpa	
	lbpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aneq	
	jpz 	$4
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$5
$4:
	mspa	#2
	lwpa	
	jmp 	$1
$5:
	jmp 	$2
$3:
	lwia	#0
	jmp 	$1
$1:
	ret 	
;	Data Segment
;	globl	memchr

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
memset:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
$2:
	mspa	#8
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
	lwpa	
	popb	
	sbqa	
	jmp 	$2
$3:
	mspa	#4
	lwpa	
	jmp 	$1
$1:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	memset

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end

