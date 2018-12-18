;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
mmu_proc_table_out:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$37:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$39
	jmp 	$40
$38:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$37
$39:
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	

	        aptb
        
	mspa	#4
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#128
	popb	
	abnd	
	jpz 	$41
	mspa	#4
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	

	            lbib	#0
	            mmus
            
	jmp 	$42
$41:
	lwia	#127

	            lbib	#0
	            mmus
            
$42:
	jmp 	$38
$40:
$36:
	mdsp	#2
	ret 	
mmu_set_page:
	mspa	#2
	lwpa	
  aptb

	mspa	#4
	lbpa	

        lbib  #0
        mmus
        
$43:
	ret 	
mmu_init_clear_table:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#32
	popb	
	swqa	
$45:
	mspa	#0
	lwpa	
	psha	
	lwia	#2048
	popb	
	ault	
	jpnz	$47
	jmp 	$48
$46:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$45
$47:
	mspa	#0
	lwpa	

            aptb
        
	lwia	#127

            lbib    #0
            mmus
        
	jmp 	$46
$48:
$44:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	mmu_proc_table_out
;	globl	mmu_set_page
;	globl	mmu_init_clear_table

;	0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:51
;	.end
