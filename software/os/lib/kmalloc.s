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
