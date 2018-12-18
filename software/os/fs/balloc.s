;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
balloc_alloc:
	mdsp	#-2
	mdsp	#-2
	lwia	balloc_buffer
	psha	
	lwia	superblk
	lwib	#2
	aadd	
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#2
	psha	
	lwia	superblk
	lwib	#2
	aadd	
	lwpa	
	popb	
	swqa	
$77:
	mspa	#2
	lwpa	
	psha	
	lwia	#65535
	popb	
	ault	
	jpnz	$79
	jmp 	$80
$78:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$77
$79:
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	alng	
	jpz 	$81
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
$81:
	mspa	#0
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$82
	mspa	#2
	lwpa	
	jmp 	$76
$82:
	jmp 	$78
$80:
	lwia	#2
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#4
	ret 	
balloc_put:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	popb	
	swqa	
$84:
	mspa	#8
	lwpa	
	lwpa	
	jpz 	$85
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	mspa	#10
	lwpa	
	lwpa	
	popb	
	aneq	
	jpz 	$86
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwpa	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$86:
	mspa	#0
	psha	
	mspa	#10
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	popb	
	swqa	
	jmp 	$84
$85:
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#1
	popb	
	aneq	
	jpz 	$87
	lwia	balloc_buffer
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$87:
$83:
	mdsp	#6
	ret 	
balloc_get:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	popb	
	swqa	
	lwia	balloc_get_buf
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
$89:
	lwia	#1
	jpz 	$90
	lwia	balloc_buffer
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#6
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#6
	lwpa	
	alng	
	jpnz	$92
	mspa	#6
	lwpa	
	psha	
	lwia	#65535
	popb	
	aequ	
$92:
	aclv	
	jpz 	$91
	lwia	#0
	jmp 	$88
$91:
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$93
	mspa	#2
	lwpa	
	psha	
	lwia	#129
	popb	
	ault	
	alng	
	jpz 	$94
	lwia	#4
	psha	
	call	panic
	mdsp	#2
$94:
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	sbqa	
	lwia	balloc_get_buf
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	call	kmalloc
	mdsp	#2
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	lwia	balloc_get_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#0
	lwpa	
	jmp 	$88
$93:
	lwia	balloc_get_buf
	psha	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	jmp 	$89
$90:
$88:
	mdsp	#4
	ret 	
balloc_free:
	mdsp	#-2
$96:
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_read
	mdsp	#4
	mspa	#0
	psha	
	lwia	balloc_buffer
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	lwia	balloc_buffer
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_write
	mdsp	#4
	mspa	#4
	psha	
	mspa	#2
	lwpa	
	popb	
	swqa	
$97:
	mspa	#4
	lwpa	
	jpz 	$99
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aneq	
$99:
	aclv	
	jpz 	$100
	mspa	#4
	lwpa	
	psha	
	lwia	#65535
	popb	
	aneq	
$100:
	aclv	
	jpnz	$96
$98:
$95:
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
;	globl	balloc_buffer
balloc_buffer:
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0
;	globl	balloc_get_buf
balloc_get_buf:
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0
;	globl	balloc_alloc
;	extrn	disk_read
;	extrn	panic
;	globl	balloc_put
;	extrn	disk_write
;	globl	balloc_get
;	extrn	kmalloc
;	extrn	memcpy
;	globl	balloc_free

;	0 error(s) in compilation
;	literal pool:0
;	global pool:21
;	Macro pool:51
;	.end
