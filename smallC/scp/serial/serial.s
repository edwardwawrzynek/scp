;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
serial_in_waiting:
	lwia	#2
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	mdsp	#0
	ret 	
serial_async_read:
	mdsp	#-1
	lwib	#0
	call	serial_in_waiting
	mdsp	#0
	jpz 	$3
	mspa	#0
	psha	
	lwia	#1
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	popb	
	sbqa	
	lwia	#1
	psha	
	lwia	#1
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mspa	#0
	lbpa	
	jmp 	$2
	mdsp	#0
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#1
	ret 	
serial_read:
	mdsp	#-1
$5:
	mspa	#0
	psha	
	lwib	#0
	call	serial_async_read
	mdsp	#0
	popb	
	sbqa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpz 	$6
	jmp 	$5
$6:
	mdsp	#0
	mspa	#0
	lbpa	
	jmp 	$4
$4:
	mdsp	#1
	ret 	
serial_async_write:
	lwia	#4
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jpz 	$8
	lwia	#1
	aneg	
	jmp 	$7
	mdsp	#0
$8:
	lwia	#3
	psha	
	mspa	#4
	lbpa	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
$7:
	mdsp	#0
	ret 	
serial_write:
$10:
	lwia	#4
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jpz 	$11
	jmp 	$10
$11:
	mdsp	#0
	lwia	#3
	psha	
	mspa	#4
	lbpa	
	psha	
	lwib	#2
	call	outp
	mdsp	#4
$9:
	mdsp	#0
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
;	Macro pool:162
;	.end
