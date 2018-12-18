;	Small C
;	Small C Processor Backend Coder(Mostly Works)
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
	jmp 	$3
$2:
	mspa	#2
	lwpa	
	jmp 	$1
$3:
$1:
	ret 	
;	Data Segment
;	globl	abs

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
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$6:
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
	call	_isdigit
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
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	atoi
;	extrn	_isdigit

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
itoa:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$2
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
	lwia	#0
	popb	
	swqa	
$3:
	mspa	#8
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
	mspa	#8
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
	mspa	#6
	psha	
	mspa	#8
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
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$6
	mspa	#8
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
$6:
	mspa	#8
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
	mspa	#8
	lwpa	
	psha	
	call	_reverse
	mdsp	#2
$1:
	mdsp	#4
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	itoa
;	extrn	_reverse

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:500
;	.end

;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
srand:
	mspa	#2
	lwpa	
	swma	xxseed
	mspa	#2
	lwpa	
	psha	
	lwia	#53562
	popb	
	abxr	
	swma	xxseed2
$1:
	ret 	
rand:
	lwma	xxseed
	psha	
	lwia	#5
	popb	
	amul	
	psha	
	lwia	#123
	popb	
	aadd	
	psha	
	lwia	#64060
	popb	
	abxr	
	psha	
	lwia	#21671
	popb	
	amul	
	psha	
	lwia	#2
	popb	
	assr	
	psha	
	lwma	xxseed2
	popb	
	aadd	
	psha	
	lwia	#41906
	popb	
	abxr	
	swma	xxseed
	lwma	xxseed2
	psha	
	lwia	#87
	popb	
	amul	
	psha	
	lwia	#54
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	ashl	
	psha	
	lwia	#9121
	psha	
	lwma	xxseed
	psha	
	lwia	#13393
	popb	
	abxr	
	psha	
	lwia	#20274
	popb	
	abnd	
	popb	
	amul	
	popb	
	abxr	
	swma	xxseed2
	lwma	xxseed
	psha	
	call	abs
	mdsp	#2
	jmp 	$2
$2:
	ret 	
;	Data Segment
;	globl	xxseed
xxseed:
	.dw	#0
;	globl	xxseed2
xxseed2:
	.dw	#0
;	globl	srand
;	globl	rand
;	extrn	abs

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
_reverse:
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
	call	_strlen
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
	mspa	#7
	lwpa	
	jmp 	$1
$1:
	mdsp	#5
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	_reverse
;	extrn	_strlen

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
	jpz 	$2
	lwia	#1
	jmp 	$1
	jmp 	$3
$2:
	lwia	#0
	jmp 	$1
$3:
$1:
	ret 	
;	Data Segment
;	globl	_isdigit

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
_strlen:
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
;	globl	_strlen

;	0 error(s) in compilation
;	literal pool:0
;	global pool:4
;	Macro pool:494
;	.end

