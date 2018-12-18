;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_half_unpack:
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	psha	
	lwia	#15
	popb	
	ashr	
	popb	
	swqa	
	mspa	#6
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#31744
	popb	
	abnd	
	psha	
	lwia	#10
	popb	
	ashr	
	psha	
	lwia	#15
	popb	
	asub	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1023
	popb	
	abnd	
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwpa	
	psha	
	lwia	#15
	popb	
	aadd	
	jpnz	$3
	mspa	#2
	lwpa	
$3:
	aclv	
	jpz 	$2
	mspa	#2
	psha	
	lwpa	
	psha	
	lwia	#1024
	popb	
	abor	
	popb	
	swqa	
$2:
	mspa	#2
	lwpa	
	jmp 	$1
$1:
	ret 	
_half_pack:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#15
	popb	
	ashl	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	lwia	#10
	popb	
	ashl	
	psha	
	lwia	#31744
	popb	
	abnd	
	popb	
	abor	
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#1023
	popb	
	abnd	
	popb	
	abor	
	popb	
	swqa	
	mspa	#0
	lwpa	
	jmp 	$4
$4:
	mdsp	#2
	ret 	
_half_normalize:
	mspa	#4
	lwpa	
	lwpa	
	jpz 	$6
$7:
	mspa	#4
	lwpa	
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	alng	
	jpz 	$8
	mspa	#4
	lwpa	
	psha	
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	jmp 	$7
$8:
	mspa	#4
	lwpa	
	psha	
	lwpa	
	psha	
	lwia	#5
	popb	
	assr	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwpa	
	psha	
	lwia	#5
	popb	
	aadd	
	popb	
	swqa	
	lwia	#1
	jmp 	$5
$6:
	mspa	#2
	lwpa	
	psha	
	lwia	#15
	aneg	
	popb	
	swqa	
	lwia	#0
	jmp 	$5
$5:
	ret 	
hadd:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	psha	
	mspa	#14
	psha	
	mspa	#22
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#6
	psha	
	mspa	#12
	psha	
	mspa	#24
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	popb	
	swqa	
	mspa	#12
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#12
	lwpa	
	psha	
	lwia	#0
	popb	
	asle	
	alng	
	jpz 	$10
	mspa	#0
	psha	
	lwpa	
	psha	
	mspa	#16
	lwpa	
	popb	
	assr	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	psha	
	mspa	#16
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$11
$10:
	mspa	#2
	psha	
	lwpa	
	psha	
	mspa	#16
	lwpa	
	aneg	
	popb	
	assr	
	popb	
	swqa	
	mspa	#6
	psha	
	lwpa	
	psha	
	mspa	#16
	lwpa	
	aneg	
	popb	
	aadd	
	popb	
	swqa	
$11:
	mspa	#10
	lwpa	
	jpz 	$12
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
$12:
	mspa	#8
	lwpa	
	jpz 	$13
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	aneg	
	popb	
	swqa	
$13:
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#10
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$14
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
	mspa	#10
	psha	
	lwia	#1
	popb	
	swqa	
$14:
	mspa	#2
	psha	
	mspa	#8
	psha	
	call	_half_normalize
	mdsp	#4
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	call	_half_pack
	mdsp	#6
	jmp 	$9
$9:
	mdsp	#14
	ret 	
hsub:
	mspa	#4
	psha	
	lwpa	
	psha	
	lwia	#32768
	popb	
	abxr	
	popb	
	swqa	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	hadd
	mdsp	#4
	jmp 	$15
$15:
	ret 	
hmul:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	psha	
	mspa	#14
	psha	
	mspa	#20
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	psha	
	lwia	#3
	popb	
	assr	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#6
	psha	
	mspa	#12
	psha	
	mspa	#22
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	psha	
	lwia	#3
	popb	
	assr	
	popb	
	swqa	
	mspa	#6
	psha	
	lwpa	
	psha	
	lwia	#3
	popb	
	aadd	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	psha	
	lwia	#3
	popb	
	aadd	
	popb	
	swqa	
	mspa	#10
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	abxr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	amul	
	popb	
	swqa	
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#10
	popb	
	asub	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#8
	psha	
	call	_half_normalize
	mdsp	#4
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	call	_half_pack
	mdsp	#6
	jmp 	$16
$16:
	mdsp	#12
	ret 	
hdiv:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#6
	psha	
	mspa	#4
	psha	
	mspa	#14
	psha	
	mspa	#20
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	psha	
	lwia	#5
	popb	
	ashl	
	popb	
	swqa	
	mspa	#4
	psha	
	mspa	#2
	psha	
	mspa	#12
	psha	
	mspa	#22
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	psha	
	lwia	#3
	popb	
	assr	
	popb	
	swqa	
	mspa	#2
	psha	
	lwpa	
	psha	
	lwia	#5
	popb	
	asub	
	popb	
	swqa	
	mspa	#0
	psha	
	lwpa	
	psha	
	lwia	#3
	popb	
	aadd	
	popb	
	swqa	
	mspa	#10
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	abxr	
	popb	
	swqa	
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	call	ccudiv
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	asub	
	psha	
	lwia	#10
	popb	
	aadd	
	popb	
	swqa	
	mspa	#6
	psha	
	mspa	#4
	psha	
	call	_half_normalize
	mdsp	#4
	mspa	#6
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	call	_half_pack
	mdsp	#6
	jmp 	$17
$17:
	mdsp	#12
	ret 	
hcmp:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#14
	lwpa	
	psha	
	mspa	#18
	lwpa	
	popb	
	aequ	
	jpz 	$19
	lwia	#0
	jmp 	$18
$19:
	mspa	#6
	psha	
	mspa	#4
	psha	
	mspa	#14
	psha	
	mspa	#20
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	popb	
	swqa	
	mspa	#4
	psha	
	mspa	#2
	psha	
	mspa	#12
	psha	
	mspa	#22
	lwpa	
	psha	
	call	_half_unpack
	mdsp	#6
	popb	
	swqa	
	mspa	#10
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	abxr	
	jpz 	$20
	mspa	#8
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	asub	
	jmp 	$18
$20:
	mspa	#10
	psha	
	mspa	#12
	lwpa	
	jpz 	$21
	lwia	#1
	aneg	
	jmp 	$22
$21:
	lwia	#1
$22:
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#2
	lwpa	
	jpz 	$23
	mspa	#2
	lwpa	
	psha	
	mspa	#12
	lwpa	
	popb	
	amul	
	jmp 	$18
$23:
	mspa	#6
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	asub	
	psha	
	mspa	#12
	lwpa	
	popb	
	amul	
	jmp 	$18
$18:
	mdsp	#12
	ret 	
;	Data Segment
;	globl	_half_unpack
;	globl	_half_pack
;	globl	_half_normalize
;	globl	hadd
;	globl	hsub
;	globl	hmul
;	globl	hdiv
;	globl	hcmp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:8
;	Macro pool:82
;	.end
