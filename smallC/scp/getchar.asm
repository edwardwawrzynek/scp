;	Small C
;	Small C Processor Backend Coder (Minimally works for some stuff)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_key_in_waiting:
	lwia	#8
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	jmp 	$1
$1:
	mdsp	#0
	ret 	
_key_async_read:
	mdsp	#-1
	lwib	#0
	call	_key_in_waiting
	mdsp	#0
	jpz 	$3
	mspa	#0
	psha	
	lwia	#7
	psha	
	lwib	#1
	call	inp
	mdsp	#2
	popb	
	sbqa	
	lwia	#7
	psha	
	lwia	#1
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mdsp	#0
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#1
	ret 	
_key_read:
	mdsp	#-1
$5:
	mspa	#0
	psha	
	lwib	#0
	call	_key_async_read
	mdsp	#0
	popb	
	sbqa	
$6:
	mspa	#0
	lbpa	
	psha	
	lwia	#1
	aneg	
	popb	
	aequ	
	jpnz	$5
$7:
	mdsp	#0
	mspa	#0
	lbpa	
	jmp 	$4
$4:
	mdsp	#1
	ret 	
getchar:
	mdsp	#-2
$8:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	_key_in_waiting
;	extrn	inp
;	globl	_key_async_read
;	extrn	outp
;	globl	_key_read
;	globl	_getcharecho
_getcharecho:
	.db	#1
;	globl	getchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:178
;	.end
