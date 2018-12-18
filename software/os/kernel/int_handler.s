;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
_int0_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#2
$65:
	ret 	
_int1_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#22
	psha	
	call	printf
	mdsp	#2
$66:
	ret 	
_int2_handler:

    swma  int_handler_reg_a
    swmb  int_handler_reg_b
    mspa  #0
    swma  int_handler_reg_sp
    cpca
    swma  int_handler_reg_pc

	lwma	int_handler_reg_pc
	deca	
	swma	int_handler_reg_pc
	inca	
    lwia    #0
    masp

	lwma	int_handler_reg_sp
	psha	
	lwma	int_handler_reg_pc
	psha	
	lwma	int_handler_reg_b
	psha	
	lwma	int_handler_reg_a
	psha	
	lwma	proc_current_proc
	psha	
	call	proc_set_cpu_state
	mdsp	#10
	call	shed_shedule
	lwia	$0+#44
	psha	
	call	printf
	mdsp	#2
$67:
	ret 	
_int3_handler:
	lwia	$0+#66
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$69:
	lwia	#1
	jpz 	$70
	jmp 	$69
$70:
$68:
	ret 	
_int4_handler:
	lwia	$0+#83
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$72:
	lwia	#1
	jpz 	$73
	jmp 	$72
$73:
$71:
	ret 	
_int5_handler:
	lwia	$0+#100
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
$75:
	lwia	#1
	jpz 	$76
	jmp 	$75
$76:
$74:
	ret 	
_int_reset_timer:
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	psha	
	call	outp
	mdsp	#4
$77:
	ret 	
;	Data Segment
$0:	.db	#83,#111,#109,#101,#116,#104,#105,#110
	.db	#103,#32,#119,#101,#110,#116,#32,#119
	.db	#114,#111,#110,#103,#10,#0,#83,#111
	.db	#109,#101,#116,#104,#105,#110,#103,#32
	.db	#119,#101,#110,#116,#32,#119,#114,#111
	.db	#110,#103,#10,#0,#83,#111,#109,#101
	.db	#116,#104,#105,#110,#103,#32,#119,#101
	.db	#110,#116,#32,#119,#114,#111,#110,#103
	.db	#10,#0,#73,#110,#116,#32,#51,#32
	.db	#116,#114,#105,#103,#103,#101,#114,#101
	.db	#100,#10,#0,#73,#110,#116,#32,#52
	.db	#32,#116,#114,#105,#103,#103,#101,#114
	.db	#101,#100,#10,#0,#73,#110,#116,#32
	.db	#53,#32,#116,#114,#105,#103,#103,#101
	.db	#114,#101,#100,#10,#0
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
int_handler_reg_a:
	.dw	#0
int_handler_reg_b:
	.dw	#0
int_handler_reg_sp:
	.dw	#0
int_handler_reg_pc:
	.dw	#0
;	globl	_int0_handler
;	extrn	proc_set_cpu_state
;	extrn	shed_shedule
;	extrn	printf
;	globl	_int1_handler
;	globl	_int2_handler
;	globl	_int3_handler
;	extrn	switch_to_user
;	globl	_int4_handler
;	globl	_int5_handler
;	globl	_int_reset_timer
;	extrn	outp

;	0 error(s) in compilation
;	literal pool:117
;	global pool:23
;	Macro pool:51
;	.end
