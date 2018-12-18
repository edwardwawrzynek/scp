;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
panic:
	mspa	#2
	lbpa	
	psha	
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#4
$2:
	lwia	#1
	jpz 	$3
	jmp 	$2
$3:
$1:
	ret 	
;	Data Segment
$0:	.db	#10,#10,#10,#84,#104,#101,#32,#75
	.db	#101,#114,#110,#101,#108,#32,#69,#120
	.db	#112,#101,#114,#105,#101,#110,#99,#101
	.db	#100,#32,#65,#110,#32,#69,#114,#114
	.db	#111,#114,#10,#69,#114,#114,#111,#114
	.db	#32,#67,#111,#100,#101,#58,#32,#37
	.db	#117,#10,#83,#116,#111,#112,#112,#105
	.db	#110,#103,#10,#0
;	globl	panic
;	extrn	printf

;	0 error(s) in compilation
;	literal pool:60
;	global pool:2
;	Macro pool:51
;	.end
