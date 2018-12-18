;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
dir_make_file:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#1
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#4
	lwpa	
	alng	
	jpz 	$77
	lwia	#0
	jmp 	$76
$77:
	mspa	#2
	psha	
	lwia	#1
	aneg	
	popb	
	swqa	
$78:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$81
	jmp 	$80
$81:
$79:
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
	jpnz	$78
$80:
	lwia	#1
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#16
	popb	
	amul	
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	mspa	#0
	psha	
	mspa	#16
	lbpa	
	psha	
	mspa	#16
	lwpa	
	psha	
	call	inode_new
	mdsp	#4
	popb	
	swqa	
	lwia	#16
	psha	
	lwia	#0
	psha	
	lwia	fs_global_buf
	psha	
	call	memset
	mdsp	#6
	mspa	#10
	lwpa	
	psha	
	lwia	fs_global_buf
	psha	
	call	strcpy
	mdsp	#4
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$82
	mspa	#0
	lwpa	
	psha	
	call	inode_delete
	mdsp	#2
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$76
$82:
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$76
$76:
	mdsp	#6
	ret 	
dir_make_dir:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#14
	lwpa	
	psha	
	mspa	#14
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	popb	
	swqa	
	mspa	#2
	lwpa	
	jpz 	$84
	mspa	#0
	psha	
	lwia	#2
	psha	
	mspa	#6
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$85
	lwia	#0
	jmp 	$83
$85:
	lwia	#32
	psha	
	lwia	#0
	psha	
	lwia	fs_global_buf
	psha	
	call	memset
	mdsp	#6
	lwia	fs_global_buf
	psha	
	lwia	#0
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#16
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#17
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#30
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#31
	popb	
	aadd	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	popb	
	sbqa	
	lwia	#32
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#4
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#32
	popb	
	aneq	
	jpz 	$86
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$83
$86:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$87
	lwia	#0
	jmp 	$83
$87:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	inca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#2
	lwpa	
	jmp 	$83
$84:
	lwia	#0
	jmp 	$83
$83:
	mdsp	#4
	ret 	
dir_delete_file:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#1
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#12
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#4
	lwpa	
	alng	
	jpz 	$89
	lwia	#1
	jmp 	$88
$89:
$90:
	lwia	#1
	jpz 	$91
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$92
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$92:
	lwia	fs_global_buf
	psha	
	mspa	#12
	lwpa	
	psha	
	call	strcmp
	mdsp	#4
	alng	
	jpz 	$94
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	jpnz	$95
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
$95:
	aclv	
$94:
	aclv	
	jpz 	$93
	jmp 	$91
$93:
	jmp 	$90
$91:
	mspa	#2
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	alng	
	jpz 	$96
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$96:
	lwia	#2
	psha	
	lwia	#16
	aneg	
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$97
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#1
	jmp 	$88
$97:
	mspa	#0
	psha	
	mspa	#4
	lwpa	
	psha	
	call	inode_get
	mdsp	#2
	popb	
	swqa	
	mspa	#0
	lwpa	
	alng	
	jpz 	$98
	lwia	#1
	jmp 	$88
$98:
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	lbpa	
	deca	
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	call	inode_put
	mdsp	#2
	mspa	#4
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$88
$88:
	mdsp	#6
	ret 	
dir_next_entry:
	mdsp	#-2
$100:
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#8
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aneq	
	jpz 	$103
	lwia	#0
	jmp 	$99
$103:
$101:
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
	alng	
	jpnz	$100
$102:
	mspa	#0
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	lwia	#14
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#10
	lwpa	
	psha	
	call	memcpy
	mdsp	#6
	mspa	#0
	lwpa	
	jmp 	$99
$99:
	mdsp	#2
	ret 	
dir_name_inum:
	mdsp	#-2
	mdsp	#-2
	mspa	#2
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	mspa	#2
	lwpa	
	alng	
	jpz 	$105
	lwia	#0
	jmp 	$104
$105:
$106:
	lwia	#16
	psha	
	lwia	fs_global_buf
	psha	
	mspa	#6
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#16
	popb	
	aequ	
	jpz 	$107
	lwia	fs_global_buf
	psha	
	mspa	#10
	lwpa	
	psha	
	call	strcmp
	mdsp	#4
	alng	
	jpz 	$109
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	popb	
	abor	
$109:
	aclv	
	jpz 	$108
	mspa	#0
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#14
	popb	
	aadd	
	lbpa	
	psha	
	lwia	fs_global_buf
	psha	
	lwia	#15
	popb	
	aadd	
	lbpa	
	psha	
	lwia	#8
	popb	
	ashl	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#0
	lwpa	
	jmp 	$104
$108:
	jmp 	$106
$107:
	mspa	#2
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	lwia	#0
	jmp 	$104
$104:
	mdsp	#4
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
;	globl	dir_make_file
;	extrn	file_get
;	extrn	file_read
;	extrn	file_seek
;	extrn	inode_new
;	extrn	memset
;	extrn	strcpy
;	extrn	file_write
;	extrn	inode_delete
;	extrn	file_put
;	globl	dir_make_dir
;	globl	dir_delete_file
;	extrn	strcmp
;	extrn	inode_get
;	extrn	inode_put
;	globl	dir_next_entry
;	extrn	memcpy
;	globl	dir_name_inum

;	0 error(s) in compilation
;	literal pool:0
;	global pool:28
;	Macro pool:51
;	.end
