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
	mdsp	#-2
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
	swqa	
	lwia	#7
	psha	
	lwia	#1
	psha	
	lwib	#2
	call	outp
	mdsp	#4
	mspa	#0
	lwpa	
	jmp 	$2
	mdsp	#0
$3:
	lwia	#1
	aneg	
	jmp 	$2
$2:
	mdsp	#2
	ret 	
_key_read:
	mdsp	#-2
$5:
	mspa	#0
	psha	
	lwib	#0
	call	_key_async_read
	mdsp	#0
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
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$4
$4:
	mdsp	#2
	ret 	
_key_press_read:
	mdsp	#-2
$9:
	mspa	#0
	psha	
	lwib	#0
	call	_key_read
	mdsp	#0
	popb	
	swqa	
$10:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	popb	
	abnd	
	jpnz	$9
$11:
	mdsp	#0
	mspa	#0
	lwpa	
	jmp 	$8
$8:
	mdsp	#2
	ret 	
getchar:
	mdsp	#-2
$12:
	mdsp	#2
	ret 	
;	Data Segment
;	globl	_key_in_waiting
;	extrn	inp
;	globl	_key_async_read
;	extrn	outp
;	globl	_key_read
;	globl	_key_press_read
;	globl	_getcharecho
_getcharecho:
	.db	#1
;	globl	_getcharshifted
_getcharshifted:
	.db	#0
;	globl	getchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:9
;	Macro pool:178
;	.end
