;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
kernel_init:
	call	mmu_init_clear_table
	call	fs_init
	call	proc_init_table
	call	proc_init_kernel_entry
$105:
	ret 	
kernel_map_in_mem:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#11
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#12
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#128
	popb	
	abnd	
	alng	
	jpz 	$107
	lwia	#0
	jmp 	$106
$107:
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	swqa	
	mspa	#4
	lwpa	
	psha	
	lwia	#31
	popb	
	aneq	
	jpz 	$108
	mspa	#0
	psha	
	mspa	#12
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#128
	popb	
	abnd	
	alng	
	jpz 	$109
	lwia	#0
	jmp 	$106
$109:
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#127
	popb	
	abnd	
	popb	
	swqa	
	jmp 	$110
$108:
	mspa	#0
	psha	
	lwia	#127
	popb	
	swqa	
$110:
	mspa	#2
	lwpa	
	psha	
	lwia	#29
	psha	
	call	mmu_set_page
	mdsp	#4
	mspa	#0
	lwpa	
	psha	
	lwia	#30
	psha	
	call	mmu_set_page
	mdsp	#4
	lwia	#29
	psha	
	lwia	#11
	popb	
	ashl	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#2047
	popb	
	abnd	
	popb	
	aadd	
	jmp 	$106
$106:
	mdsp	#6
	ret 	
;	Data Segment
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	globl	kernel_init
;	extrn	mmu_init_clear_table
;	extrn	fs_init
;	extrn	proc_init_table
;	extrn	proc_init_kernel_entry
;	globl	kernel_map_in_mem
;	extrn	mmu_set_page

;	0 error(s) in compilation
;	literal pool:0
;	global pool:21
;	Macro pool:51
;	.end
