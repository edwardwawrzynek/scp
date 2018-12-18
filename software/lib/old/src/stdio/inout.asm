;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
outp:
	mspa	#2
	lbpa	

		xswp
		
	mspa	#4
	lwpa	

		outa
		
$1:
	ret 	
inp:
	mspa	#2
	lbpa	

		xswp
		ina 
		
$2:
	ret 	
;	Data Segment
;	globl	outp
;	globl	inp

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:51
;	.end
