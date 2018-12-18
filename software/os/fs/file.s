;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
file_alloc:
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
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$81
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	jmp 	$76
$81:
	jmp 	$78
$80:
	lwia	#9
	psha	
	call	panic
	mdsp	#2
$76:
	mdsp	#2
	ret 	
file_get:
	mdsp	#-2
	mspa	#0
	psha	
	call	file_alloc
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#6
	aadd	
	psha	
	mspa	#8
	lbpa	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	mspa	#6
	lwpa	
	psha	
	call	inode_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	alng	
	jpz 	$83
	mspa	#0
	lwpa	
	lwib	#7
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	#0
	jmp 	$82
$83:
	mspa	#6
	lbpa	
	psha	
	lwia	#4
	popb	
	abnd	
	jpz 	$84
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_truncate
	mdsp	#2
$84:
	mspa	#6
	lbpa	
	psha	
	lwia	#8
	popb	
	abnd	
	jpz 	$85
	mspa	#0
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	swqa	
$85:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	lwpa	
	alng	
	jpz 	$86
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_add_blk
	mdsp	#2
$86:
	mspa	#0
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	lwpa	
	psha	
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	jmp 	$82
$82:
	mdsp	#2
	ret 	
file_put:
	mspa	#2
	lwpa	
	lwib	#7
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#2
	lwpa	
	lwib	#7
	aadd	
	lbpa	
	alng	
	jpz 	$88
	mspa	#2
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	mspa	#2
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	buffer_put
	mdsp	#2
$88:
$87:
	ret 	
file_put_all:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$90:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	ault	
	jpnz	$92
	jmp 	$93
$91:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$90
$92:
	lwia	file_table
	psha	
	mspa	#2
	lwpa	
	lwib	#8
	amul	
	popb	
	aadd	
	psha	
	call	file_put
	mdsp	#2
	jmp 	$91
$93:
$89:
	mdsp	#2
	ret 	
file_set_buf:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#9
	popb	
	ashr	
	popb	
	swqa	
$95:
	mspa	#0
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#13
	aadd	
	lbpa	
	popb	
	ault	
	alng	
	jpz 	$96
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	call	inode_add_blk
	mdsp	#2
	jmp 	$95
$96:
	mspa	#0
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
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
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	aneq	
	jpz 	$97
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	buffer_put
	mdsp	#2
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	call	buffer_get
	mdsp	#2
	popb	
	swqa	
$97:
$94:
	mdsp	#2
	ret 	
file_write:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#2
	popb	
	abnd	
	alng	
	jpz 	$99
	lwia	#0
	jmp 	$98
$99:
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$100:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$101
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$102
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$102:
	mspa	#4
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#511
	popb	
	abnd	
	popb	
	aadd	
	psha	
	mspa	#8
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	popb	
	sbqa	
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	aule	
	alng	
	jpz 	$103
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	psha	
	mspa	#6
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	popb	
	swqa	
$103:
	jmp 	$100
$101:
	mspa	#0
	lwpa	
	jmp 	$98
$98:
	mdsp	#2
	ret 	
file_read:
	mdsp	#-2
	mspa	#0
	psha	
	mspa	#10
	lwpa	
	popb	
	swqa	
	mspa	#4
	lwpa	
	lwib	#6
	aadd	
	lbpa	
	psha	
	lwia	#1
	popb	
	abnd	
	alng	
	jpz 	$105
	lwia	#0
	jmp 	$104
$105:
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$106:
	mspa	#8
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	inca	
	jpz 	$107
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	mspa	#6
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	popb	
	ault	
	alng	
	jpz 	$108
	mspa	#0
	lwpa	
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	asub	
	jmp 	$104
$108:
	mspa	#4
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	psha	
	lwia	#511
	popb	
	abnd	
	alng	
	jpz 	$109
	mspa	#4
	lwpa	
	psha	
	call	file_set_buf
	mdsp	#2
$109:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	mspa	#6
	lwpa	
	lwib	#2
	aadd	
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	psha	
	lwia	#511
	popb	
	abnd	
	popb	
	aadd	
	lbpa	
	popb	
	sbqa	
	jmp 	$106
$107:
	mspa	#0
	lwpa	
	jmp 	$104
$104:
	mdsp	#2
	ret 	
file_seek:
	lwia	$111
	psha	
	mspa	#8
	lbpa	
	jmp 	cccase
$113:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$112
$114:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#4
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#3
	aadd	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$112
$115:
$116:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	psha	
	mspa	#6
	lwpa	
	popb	
	swqa	
	jmp 	$112
	jmp 	$112
;	Data Segment
$111:
	.dw	#2,$113,#3,$114,#1,$115
	.dw	$116,#0
;	Code Segment
$112:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$110
$110:
	ret 	
file_tell:
	mspa	#2
	lwpa	
	lwib	#4
	aadd	
	lwpa	
	jmp 	$117
$117:
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
;	globl	file_table
file_table:
	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

	.ds	#14
	.ds	#5
	.dw	#0
	.db	#0
	.db	#0

;	globl	file_alloc
;	extrn	panic
;	globl	file_get
;	extrn	inode_get
;	extrn	inode_truncate
;	extrn	inode_add_blk
;	extrn	buffer_get
;	globl	file_put
;	extrn	inode_put
;	extrn	buffer_put
;	globl	file_put_all
;	globl	file_set_buf
;	globl	file_write
;	globl	file_read
;	globl	file_seek
;	globl	file_tell

;	0 error(s) in compilation
;	literal pool:0
;	global pool:27
;	Macro pool:51
;	.end
