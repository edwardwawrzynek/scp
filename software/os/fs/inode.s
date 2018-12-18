;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
inode_alloc:
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
	lwia	#24
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
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$81
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$82:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$84
	jmp 	$85
$83:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$82
$84:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#10
	aadd	
	lbpa	
	alng	
	jpz 	$86
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
	jpz 	$87
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	psha	
	call	inode_force_put
	mdsp	#2
$87:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$76
$86:
	jmp 	$83
$85:
	lwia	#3
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
inode_load:
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$89
	lwia	#5
	psha	
	call	panic
	mdsp	#2
$89:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#6
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#63
	popb	
	abnd	
	psha	
	lwia	#8
	popb	
	amul	
	popb	
	swqa	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	#8
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
$88:
	mdsp	#4
	ret 	
inode_write:
	mdsp	#-2
	mdsp	#-2
	mspa	#8
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$91
	lwia	#5
	psha	
	call	panic
	mdsp	#2
$91:
	mspa	#2
	psha	
	lwia	#384
	psha	
	mspa	#12
	lwpa	
	psha	
	lwia	#6
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#63
	popb	
	abnd	
	psha	
	lwia	#8
	popb	
	amul	
	popb	
	swqa	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_read
	mdsp	#4
	lwia	#8
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	psha	
	call	memcpy
	mdsp	#6
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
$90:
	mdsp	#4
	ret 	
inode_get:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$93:
	mspa	#2
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$95
	jmp 	$96
$94:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$93
$95:
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#8
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aequ	
	jpz 	$98
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#11
	aadd	
	lwpa	
$98:
	aclv	
	jpz 	$97
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	lwib	#10
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	lwia	inode_table
	psha	
	mspa	#4
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	jmp 	$92
$97:
	jmp 	$94
$96:
	mspa	#0
	psha	
	call	inode_alloc
	popb	
	swqa	
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	psha	
	call	inode_load
	mdsp	#4
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$99
	lwia	#0
	jmp 	$92
$99:
	mspa	#0
	lwpa	
	lwib	#10
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#8
	aadd	
	psha	
	mspa	#8
	lwpa	
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#13
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$100
	mspa	#0
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	lwia	#0
	jmp 	$92
$100:
	mspa	#0
	lwpa	
	jmp 	$92
$92:
	mdsp	#4
	ret 	
inode_put:
	mspa	#2
	lwpa	
	lwib	#10
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
$101:
	ret 	
inode_force_put:
	mspa	#2
	lwpa	
	lwib	#8
	aadd	
	lwpa	
	jpz 	$103
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	lwpa	
	lwib	#8
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	inode_write
	mdsp	#4
$103:
$102:
	ret 	
inode_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$105:
	mspa	#0
	lwpa	
	psha	
	lwia	#24
	popb	
	ault	
	jpnz	$107
	jmp 	$108
$106:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$105
$107:
	lwia	inode_table
	psha	
	mspa	#2
	lwpa	
	lwib	#14
	amul	
	popb	
	aadd	
	psha	
	call	inode_force_put
	mdsp	#2
	jmp 	$106
$108:
$104:
	mdsp	#2
	ret 	
inode_add_blk:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	popb	
	swqa	
$110:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$111:
	mspa	#0
	psha	
	lwpa	
	inca	
	inca	
	popb	
	swqa	
	deca	
	deca	
	lwpa	
	jpnz	$110
$112:
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	ashl	
	psha	
	mspa	#10
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	krealloc
	mdsp	#4
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	mspa	#4
	lwpa	
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#6
	lwpa	
	lwib	#13
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#6
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	balloc_put
	mdsp	#2
$109:
	mdsp	#4
	ret 	
inode_truncate:
	mdsp	#-4
	mdsp	#-2
	mspa	#8
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#8
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_free
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#5
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#2
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#2
	psha	
	call	balloc_put
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	psha	
	call	kfree
	mdsp	#2
	mspa	#8
	lwpa	
	lwib	#11
	aadd	
	psha	
	mspa	#10
	lwpa	
	lwib	#13
	aadd	
	psha	
	mspa	#12
	lwpa	
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_get
	mdsp	#4
	popb	
	swqa	
$113:
	mdsp	#6
	ret 	
inode_new:
	mdsp	#-2
	mdsp	#-14
	mdsp	#-4
	mspa	#18
	psha	
	lwia	#0
	popb	
	swqa	
$115:
	mspa	#18
	lwpa	
	psha	
	lwia	superblk
	lwib	#0
	aadd	
	lwpa	
	popb	
	ault	
	jpnz	$117
	jmp 	$118
$116:
	mspa	#18
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$115
$117:
	mspa	#18
	lwpa	
	psha	
	mspa	#6
	psha	
	call	inode_load
	mdsp	#4
	mspa	#4
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$119
	mspa	#4
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#4
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#4
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	lwib	#2
	aadd	
	psha	
	mspa	#24
	lwpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#1
	aadd	
	psha	
	mspa	#26
	lbpa	
	popb	
	sbqa	
	mspa	#4
	lwib	#5
	aadd	
	psha	
	call	balloc_alloc
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#6
	lwib	#5
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#0
	psha	
	lwia	#1
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
	call	balloc_put
	mdsp	#2
	mspa	#18
	lwpa	
	psha	
	mspa	#6
	psha	
	call	inode_write
	mdsp	#4
	mspa	#18
	lwpa	
	jmp 	$114
$119:
	jmp 	$116
$118:
	lwia	#8
	psha	
	call	panic
	mdsp	#2
$114:
	mdsp	#20
	ret 	
inode_delete:
	mdsp	#-14
	mspa	#16
	lwpa	
	psha	
	mspa	#2
	psha	
	call	inode_load
	mdsp	#4
	mspa	#0
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#3
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwib	#7
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#5
	aadd	
	lwpa	
	psha	
	call	balloc_free
	mdsp	#2
	mspa	#16
	lwpa	
	psha	
	mspa	#2
	psha	
	call	inode_write
	mdsp	#4
$120:
	mdsp	#14
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
;	globl	inode_table
inode_table:
	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

	.db	#0
	.db	#0
	.db	#0
	.dw	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0
	.dw	#0
	.db	#0

;	globl	inode_alloc
;	globl	inode_force_put
;	extrn	panic
;	globl	inode_load
;	extrn	disk_read
;	extrn	memcpy
;	globl	inode_write
;	extrn	disk_write
;	globl	inode_get
;	extrn	balloc_get
;	globl	inode_put
;	extrn	kfree
;	globl	inode_put_all
;	globl	inode_add_blk
;	extrn	krealloc
;	extrn	balloc_alloc
;	extrn	balloc_put
;	globl	inode_truncate
;	extrn	balloc_free
;	globl	inode_new
;	globl	inode_delete

;	0 error(s) in compilation
;	literal pool:0
;	global pool:32
;	Macro pool:51
;	.end
