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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
	xswp	
	aslt	
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
