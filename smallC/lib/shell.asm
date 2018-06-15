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
