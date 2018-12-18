;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
main:
	mdsp	#-1
	mdsp	#-2
	lwma	av
	lwma	ap
	lwpa	
	mspa	#2
	lbpa	
	asex	
	mspa	#0
	lwpa	
	lbpa	
	asex	
$2:
	mdsp	#3
	ret 	
;	Data Segment
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	av
av:
	.dw	#0
;	globl	ap
ap:
	.dw	#0
;	globl	main

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end
