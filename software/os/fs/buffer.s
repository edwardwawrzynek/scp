;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
buffer_alloc:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$77:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
	alng	
	jpz 	$81
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	psha	
	lwia	#512
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	lwia	#1
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
buffer_get:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$83:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$85
	jmp 	$86
$84:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$83
$85:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aequ	
	jpz 	$88
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
$88:
	aclv	
	jpz 	$87
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	jmp 	$82
$87:
	jmp 	$84
$86:
	mspa	#4
	lwpa	
	psha	
	call	buffer_alloc
	mdsp	#2
	jmp 	$82
$82:
	mdsp	#2
	ret 	
buffer_put:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lbpa	
	alng	
	jpz 	$90
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
$90:
$89:
	ret 	
buffer_flush_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$92:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$94
	jmp 	$95
$93:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$92
$94:
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#4
	aadd	
	lbpa	
	jpz 	$96
	lwia	buffer_table
	psha	
	mspa	#2
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#0
	aadd	
	lwpa	
	psha	
	lwia	buffer_table
	psha	
	mspa	#4
	lwpa	
	lwib	#5
	amul	
	popb	
	aadd	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$96:
	jmp 	$93
$95:
$91:
	mdsp	#2
	ret 	
;	Data Segment
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	globl	buffer_table
buffer_table:
	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

	.dw	#0
	.dw	#0
	.db	#0

;	globl	buffer_alloc
;	extrn	kmalloc
;	extrn	disk_read
;	extrn	panic
;	globl	buffer_get
;	globl	buffer_put
;	extrn	disk_write
;	extrn	kfree
;	globl	buffer_flush_all

;	0 error(s) in compilation
;	literal pool:0
;	global pool:20
;	Macro pool:51
;	.end
