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
