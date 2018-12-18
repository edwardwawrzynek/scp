;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
serial_in_waiting:
	lwia	#2
	psha	
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	ret 	
serial_async_read:
	mdsp	#-2
	call	serial_in_waiting
	jpz 	$3
	mspa	#0
	psha	
	lwia	#1
	psha	
	call	inp
	mdsp	#2
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#1
	psha	
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	jmp 	$2
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#2
	ret 	
serial_read:
	mdsp	#-2
$5:
	mspa	#0
	psha	
	call	serial_async_read
	popb	
	swqa	
$6:
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$5
$7:
	mspa	#0
	lwpa	
	jmp 	$4
$4:
	mdsp	#2
	ret 	
serial_async_write:
	lwia	#4
	psha	
	call	inp
	mdsp	#2
	jpz 	$9
	lwia	#1
	aneg	
	jmp 	$8
$9:
	mspa	#2
	lbpa	
	psha	
	lwia	#3
	psha	
	call	outp
	mdsp	#4
$8:
	ret 	
serial_write:
$11:
	lwia	#4
	psha	
	call	inp
	mdsp	#2
	jpz 	$12
	jmp 	$11
$12:
	mspa	#2
	lbpa	
	psha	
	lwia	#3
	psha	
	call	outp
	mdsp	#4
$10:
	ret 	
;	Data Segment
;	globl	serial_in_waiting
;	extrn	inp
;	globl	serial_async_read
;	extrn	outp
;	globl	serial_read
;	globl	serial_async_write
;	globl	serial_write

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:177
;	.end
