;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
Xprint:
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
	alng	
	jpz 	$7
	mdsp	#0
	jmp 	$6
	mdsp	#0
$7:
	mspa	#6
	lbpa	
	psha	
	lwia	#37
	popb	
	aequ	
	jpz 	$8
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
	jpz 	$9
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
	jmp 	$10
$9:
	mspa	#6
	lbpa	
	psha	
	lwia	#105
	popb	
	aequ	
	jpnz	$12
	mspa	#6
	lbpa	
	psha	
	lwia	#100
	popb	
	aequ	
$12:
	aclv	
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
	lwia	#10
	psha	
	lwib	#2
	call	printn
	mdsp	#4
	mdsp	#0
	jmp 	$13
$11:
	mspa	#6
	lbpa	
	psha	
	lwia	#117
	popb	
	aequ	
	jpz 	$14
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
	call	uprintn
	mdsp	#4
	mdsp	#0
	jmp 	$15
$14:
	mspa	#6
	lbpa	
	psha	
	lwia	#115
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
	lwib	#1
	call	Xprint
	mdsp	#2
	mdsp	#0
	jmp 	$17
$16:
	mspa	#6
	lbpa	
	psha	
	lwia	#120
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
	lwia	#16
	psha	
	lwib	#2
	call	uprintn
	mdsp	#4
	mdsp	#0
$18:
	mdsp	#0
$17:
	mdsp	#0
$15:
	mdsp	#0
$13:
	mdsp	#0
$10:
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
	jmp 	$19
$8:
	mspa	#6
	lbpa	
	psha	
	lwib	#1
	call	putchar
	mdsp	#2
	mdsp	#0
$19:
	jmp 	$5
$6:
	mdsp	#0
$4:
	mdsp	#9
	ret 	
;	Data Segment
;	globl	Xprint
;	extrn	putchar
;	globl	printf
;	extrn	printn
;	extrn	uprintn

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:103
;	.end
