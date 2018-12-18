;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
puts:
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
	call	putchar
	mdsp	#2
	jmp 	$2
$3:
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
$1:
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	puts
;	extrn	putchar

;	0 error(s) in compilation
;	literal pool:0
;	global pool:5
;	Macro pool:501
;	.end
