;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
proc_init_table:
	mdsp	#-1
	mspa	#0
	psha	
	lwia	#0
	popb	
	sbqa	
$106:
	mspa	#0
	lbpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$108
	jmp 	$109
$107:
	mspa	#0
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	jmp 	$106
$108:
	lwia	proc_table
	psha	
	mspa	#2
	lbpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#63
	aadd	
	psha	
	mspa	#2
	lbpa	
	popb	
	sbqa	
	jmp 	$107
$109:
$105:
	mdsp	#1
	ret 	
proc_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$111:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$113
	jmp 	$114
$112:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$111
$113:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
	alng	
	jpz 	$115
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	jmp 	$110
$115:
	jmp 	$112
$114:
	lwia	#11
	psha	
	call	panic
	mdsp	#2
$110:
	mdsp	#2
	ret 	
proc_get:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$117:
	mspa	#0
	lwpa	
	psha	
	lwia	#16
	popb	
	ault	
	jpnz	$119
	jmp 	$120
$118:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$117
$119:
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#1
	aadd	
	lbpa	
	psha	
	mspa	#6
	lbpa	
	popb	
	aequ	
	jpz 	$122
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lbpa	
$122:
	aclv	
	jpz 	$121
	lwia	proc_table
	psha	
	mspa	#2
	lwpa	
	lwib	#64
	amul	
	popb	
	aadd	
	jmp 	$116
$121:
	jmp 	$118
$120:
	lwia	#0
	jmp 	$116
$116:
	mdsp	#2
	ret 	
proc_write_mem_map:
	mspa	#2
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
	psha	
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	call	mmu_proc_table_out
	mdsp	#4
$123:
	ret 	
proc_init_kernel_entry:
	mdsp	#-2
	mdsp	#-1
	mspa	#1
	psha	
	lwia	proc_table
	popb	
	swqa	
	mspa	#1
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	#0
	sbma	proc_current_pid
	mspa	#1
	lwpa	
	lwib	#1
	aadd	
	psha	
	lbma	proc_current_pid
	inca	
	sbma	proc_current_pid
	deca	
	popb	
	sbqa	
	mspa	#1
	lwpa	
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#1
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#255
	popb	
	sbqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	sbqa	
$125:
	mspa	#0
	lbpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$127
	jmp 	$128
$126:
	mspa	#0
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	jmp 	$125
$127:
	mspa	#1
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lbpa	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$126
$128:
	mspa	#1
	lwpa	
	psha	
	call	proc_write_mem_map
	mdsp	#2
$124:
	mdsp	#3
	ret 	
proc_init_mem_map:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$130:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#0
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$132
	jmp 	$133
$131:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$130
$132:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$131
$133:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$134:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#1
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$136
	jmp 	$137
$135:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$134
$136:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$135
$137:
	mspa	#2
	psha	
	lwia	#31
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$138:
	mspa	#0
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#2
	aadd	
	lbpa	
	popb	
	ault	
	jpnz	$140
	jmp 	$141
$139:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$138
$140:
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	popb	
	aadd	
	psha	
	call	palloc_new
	popb	
	sbqa	
	jmp 	$139
$141:
$129:
	mdsp	#4
	ret 	
proc_new_entry:
	mdsp	#-2
	mspa	#0
	psha	
	call	proc_alloc
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#1
	aadd	
	psha	
	lbma	proc_current_pid
	inca	
	sbma	proc_current_pid
	deca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#6
	lbpa	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#3
	popb	
	sbqa	
	mspa	#0
	lwpa	
	jmp 	$142
$142:
	mdsp	#2
	ret 	
proc_load_mem:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#1
	aadd	
	psha	
	mspa	#12
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	psha	
	lwia	#11
	popb	
	ashr	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	sbqa	
	mspa	#8
	lwpa	
	lwib	#44
	aadd	
	lwib	#2
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#8
	lwpa	
	psha	
	call	proc_init_mem_map
	mdsp	#2
	mspa	#8
	lwpa	
	psha	
	call	proc_write_mem_map
	mdsp	#2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#14
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
$144:
	mspa	#4
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	kernel_map_in_mem
	mdsp	#4
	popb	
	swqa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$147
	lwia	#1
	jmp 	$143
$147:
	mspa	#0
	psha	
	lwia	#2048
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	popb	
	swqa	
	mspa	#2
	psha	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
$145:
	mspa	#0
	lwpa	
	psha	
	lwia	#2048
	popb	
	aequ	
	jpnz	$144
$146:
	mspa	#2
	lwpa	
	psha	
	mspa	#12
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	aneq	
	jmp 	$143
$143:
	mdsp	#6
	ret 	
proc_create_new:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	mspa	#8
	lbpa	
	psha	
	call	proc_new_entry
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#1
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$149
	mspa	#2
	lwpa	
	psha	
	call	proc_put
	mdsp	#2
	lwia	#0
	jmp 	$148
$149:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	proc_load_mem
	mdsp	#4
	jpz 	$150
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#2
	lwpa	
	psha	
	call	proc_put
	mdsp	#2
	lwia	#0
	jmp 	$148
$150:
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#2
	lwpa	
	jmp 	$148
$148:
	mdsp	#4
	ret 	
proc_set_cpu_state:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	psha	
	mspa	#12
	lwpa	
	popb	
	swqa	
$151:
	ret 	
proc_begin_execute:
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	aneq	
	jpz 	$153
	lwia	#1
	jmp 	$152
$153:
	mspa	#2
	lwpa	
	swma	proc_current_proc
	mspa	#2
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
  aptb

	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#0
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_a
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#2
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_b
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#4
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_sp
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwib	#6
	aadd	
	lwpa	
	swma	proc_begin_execute_reg_pc
	lwma	proc_begin_execute_reg_sp
  psha

	lwma	proc_begin_execute_reg_pc
  psha

	lwma	proc_begin_execute_reg_b
  xswp

	lwma	proc_begin_execute_reg_a
  ktou

	lwia	#12
	psha	
	call	panic
	mdsp	#2
$152:
	ret 	
proc_put:
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	psha	
	call	proc_put_memory
	mdsp	#2
$154:
	ret 	
proc_put_memory:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$156:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$158
	jmp 	$159
$157:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$156
$158:
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
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
	jpz 	$160
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	psha	
	call	palloc_free
	mdsp	#2
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$161
$160:
	mspa	#4
	lwpa	
	lwib	#12
	aadd	
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
$161:
	jmp 	$157
$159:
	mspa	#4
	lwpa	
	lwib	#63
	aadd	
	lbpa	
	psha	
	lwia	#5
	popb	
	ashl	
	psha	
	mspa	#6
	lwpa	
	lwib	#12
	aadd	
	psha	
	call	mmu_proc_table_out
	mdsp	#4
$155:
	mdsp	#2
	ret 	
;	Data Segment
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
;	extrn	palloc_page_in_use
;	extrn	proc_current_proc
;	extrn	proc_current_pid
;	extrn	proc_table
;	globl	proc_table
proc_table:
	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

;	globl	proc_current_pid
proc_current_pid:
	.db	#0
;	globl	proc_current_proc
proc_current_proc:
	.db	#0
	.db	#0
	.db	#0
	.db	#0
	.ds	#8
	.ds	#32
	.ds	#3
	.ds	#16
	.db	#0

proc_begin_execute_reg_a:
	.dw	#0
proc_begin_execute_reg_b:
	.dw	#0
proc_begin_execute_reg_sp:
	.dw	#0
proc_begin_execute_reg_pc:
	.dw	#0
;	globl	proc_init_table
;	globl	proc_alloc
;	extrn	panic
;	globl	proc_get
;	globl	proc_write_mem_map
;	extrn	mmu_proc_table_out
;	globl	proc_init_kernel_entry
;	extrn	palloc_new
;	globl	proc_init_mem_map
;	globl	proc_new_entry
;	globl	proc_load_mem
;	extrn	file_seek
;	extrn	kernel_map_in_mem
;	extrn	file_read
;	globl	proc_create_new
;	extrn	file_get
;	globl	proc_put
;	extrn	file_put
;	globl	proc_set_cpu_state
;	globl	proc_begin_execute
;	globl	proc_put_memory
;	extrn	palloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:43
;	Macro pool:51
;	.end
