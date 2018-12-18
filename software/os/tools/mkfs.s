;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
mkfs_disk_write:
	mspa	#4
	lwpa	
	psha	
	mspa	#4
	lwpa	
	psha	
	call	disk_write
	mdsp	#4
	lwma	blks_written
	inca	
	swma	blks_written
$41:
	ret 	
mkfs_set_sb:
	lwia	#9
	psha	
	lwia	NAME
	psha	
	lwia	mkfs_sb
	lwib	#4
	aadd	
	psha	
	call	memcpy
	mdsp	#6
	lwia	mkfs_sb
	lwib	#0
	aadd	
	psha	
	lwma	NUMBER_OF_INODES
	popb	
	swqa	
	lwia	mkfs_sb
	lwib	#2
	aadd	
	psha	
	lwma	NUMBER_OF_INODES
	psha	
	lwia	#64
	popb	
	call	ccudiv
	psha	
	lwia	#384
	popb	
	aadd	
	popb	
	swqa	
$42:
	ret 	
mkfs_write_sb:
	lwia	#13
	psha	
	lwia	mkfs_sb
	psha	
	lwia	mkfs_buf
	psha	
	call	memcpy
	mdsp	#6
	lwia	mkfs_buf
	psha	
	lwia	#383
	psha	
	call	mkfs_disk_write
	mdsp	#4
$43:
	ret 	
mkfs_clear_buf:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$45:
	mspa	#0
	lwpa	
	psha	
	lwia	#512
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
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$46
$48:
$44:
	mdsp	#2
	ret 	
mkfs_write_ll:
	mdsp	#-2
	call	mkfs_clear_buf
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$50:
	mspa	#0
	lwpa	
	psha	
	lwia	#65535
	popb	
	ault	
	jpnz	$52
	jmp 	$53
$51:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$50
$52:
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	psha	
	lwia	#2
	popb	
	amul	
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	ault	
	jpz 	$54
	lwia	#255
	jmp 	$55
$54:
	lwia	#0
$55:
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	psha	
	lwia	#2
	popb	
	amul	
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	aadd	
	psha	
	mspa	#2
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	ault	
	jpz 	$56
	lwia	#255
	jmp 	$57
$56:
	lwia	#0
$57:
	popb	
	sbqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#255
	popb	
	abnd	
	psha	
	lwia	#255
	popb	
	aequ	
	jpz 	$58
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	mkfs_disk_write
	mdsp	#4
	call	mkfs_clear_buf
	mspa	#0
	lwpa	
	psha	
	lwia	#4095
	popb	
	abnd	
	psha	
	lwia	#4095
	popb	
	aequ	
	jpz 	$59
	lwia	#46
	psha	
	call	putchar
	mdsp	#2
$59:
$58:
	jmp 	$51
$53:
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#8
	popb	
	ashr	
	psha	
	call	disk_write
	mdsp	#4
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
$49:
	mdsp	#2
	ret 	
mkfs_clear_inode_table:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	lwma	NUMBER_OF_INODES
	psha	
	lwia	#64
	popb	
	call	ccudiv
	popb	
	swqa	
	call	mkfs_clear_buf
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$61:
	mspa	#2
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	ault	
	jpnz	$63
	jmp 	$64
$62:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$61
$63:
	lwia	mkfs_buf
	psha	
	lwia	#384
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	psha	
	call	mkfs_disk_write
	mdsp	#4
	mspa	#2
	lwpa	
	psha	
	lwia	#15
	popb	
	abnd	
	psha	
	lwia	#15
	popb	
	aequ	
	jpz 	$65
	lwia	#46
	psha	
	call	putchar
	mdsp	#2
$65:
	jmp 	$62
$64:
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
$60:
	mdsp	#4
	ret 	
mkfs_create_inodes:
	mdsp	#-14
	call	mkfs_clear_buf
	mspa	#0
	lwib	#0
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#1
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwib	#2
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
	lwib	#5
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
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	#8
	psha	
	mspa	#2
	psha	
	lwia	mkfs_buf
	psha	
	call	memcpy
	mdsp	#6
	mspa	#0
	lwib	#7
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwib	#0
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwib	#5
	aadd	
	psha	
	lwia	#383
	popb	
	swqa	
	lwia	#8
	psha	
	mspa	#2
	psha	
	lwia	mkfs_buf
	psha	
	lwia	#8
	popb	
	aadd	
	psha	
	call	memcpy
	mdsp	#6
	lwia	mkfs_buf
	psha	
	lwia	#384
	psha	
	call	mkfs_disk_write
	mdsp	#4
	jmp 	$66
$66:
	mdsp	#14
	ret 	
mkfs_create_root:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#1
	psha	
	lwia	#1
	psha	
	lwia	#0
	psha	
	call	inode_new
	mdsp	#4
	psha	
	call	inode_get
	mdsp	#4
	popb	
	swqa	
	call	mkfs_clear_buf
	lwia	mkfs_buf
	psha	
	lwia	#0
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#14
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#15
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#16
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#17
	popb	
	aadd	
	psha	
	lwia	#46
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#30
	popb	
	aadd	
	psha	
	lwia	#2
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	lwia	#31
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	lwia	mkfs_buf
	psha	
	mspa	#2
	lwpa	
	lwib	#11
	aadd	
	lwpa	
	lwpa	
	psha	
	call	mkfs_disk_write
	mdsp	#4
	mspa	#0
	lwpa	
	lwib	#3
	aadd	
	psha	
	lwia	#32
	popb	
	swqa	
	mspa	#0
	lwpa	
	lwib	#2
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#1
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	mspa	#0
	lwpa	
	lwib	#0
	aadd	
	psha	
	lwia	#2
	popb	
	sbqa	
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
	psha	
	call	inode_put
	mdsp	#2
$67:
	mdsp	#2
	ret 	
main:
	lwia	_MEM_END
	swma	brk
	lwma	NUMBER_OF_INODES
	psha	
	lwia	NAME
	psha	
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#6
	call	mkfs_set_sb
	lwia	$0+#70
	psha	
	call	printf
	mdsp	#2
	call	mkfs_write_sb
	lwia	$0+#90
	psha	
	call	printf
	mdsp	#2
	lwia	mkfs_sb
	lwib	#2
	aadd	
	lwpa	
	psha	
	call	mkfs_write_ll
	mdsp	#2
	lwia	$0+#117
	psha	
	call	printf
	mdsp	#2
	call	mkfs_clear_inode_table
	lwia	$0+#139
	psha	
	call	printf
	mdsp	#2
	call	mkfs_create_inodes
	lwia	$0+#163
	psha	
	call	printf
	mdsp	#2
	call	superblock_read
	call	mkfs_create_root
	lwia	$0+#184
	psha	
	call	printf
	mdsp	#2
	call	fs_close
	lwia	$0+#205
	psha	
	call	printf
	mdsp	#2
$69:
	lwia	#1
	jpz 	$70
	jmp 	$69
$70:
$68:
	ret 	
;	Data Segment
$0:	.db	#45,#45,#45,#45,#45,#32,#77,#97
	.db	#75,#101,#70,#105,#108,#101,#83,#121
	.db	#115,#116,#101,#109,#32,#45,#45,#45
	.db	#45,#45,#10,#10,#84,#111,#32,#98
	.db	#101,#32,#119,#114,#105,#116,#116,#101
	.db	#110,#58,#10,#68,#105,#115,#107,#32
	.db	#78,#97,#109,#101,#58,#32,#37,#115
	.db	#10,#73,#110,#111,#100,#101,#115,#58
	.db	#32,#37,#117,#10,#10,#0,#87,#114
	.db	#105,#116,#105,#110,#103,#32,#83,#117
	.db	#112,#101,#114,#98,#108,#111,#99,#107
	.db	#10,#0,#87,#114,#105,#116,#105,#110
	.db	#103,#32,#66,#108,#111,#99,#107,#32
	.db	#76,#105,#110,#107,#101,#100,#32,#76
	.db	#105,#115,#116,#10,#0,#67,#108,#101
	.db	#97,#114,#105,#110,#103,#32,#73,#110
	.db	#111,#100,#101,#32,#84,#97,#98,#108
	.db	#101,#10,#0,#67,#114,#101,#97,#116
	.db	#105,#110,#103,#32,#48,#32,#97,#110
	.db	#100,#32,#49,#32,#105,#110,#111,#100
	.db	#101,#10,#0,#67,#114,#101,#97,#116
	.db	#105,#110,#103,#32,#82,#111,#111,#116
	.db	#32,#105,#110,#111,#100,#101,#10,#0
	.db	#68,#117,#109,#112,#105,#110,#103,#32
	.db	#65,#108,#108,#32,#99,#104,#97,#110
	.db	#103,#101,#115,#10,#0,#109,#107,#102
	.db	#115,#32,#102,#105,#110,#105,#115,#104
	.db	#101,#100,#10,#0
;	extrn	balloc_get_buf
;	extrn	balloc_buffer
;	extrn	buffer_table
;	extrn	file_table
;	extrn	fs_global_buf
;	extrn	inode_table
;	extrn	superblk
;	extrn	brk
;	extrn	_MEM_END
;	globl	NUMBER_OF_INODES
NUMBER_OF_INODES:
	.dw	#16384
;	globl	NAME
NAME:
	.db	#83,#67,#80,#95,#68,#73,#83,#75,#0
;	globl	mkfs_buf
mkfs_buf:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0
;	globl	mkfs_buf2
mkfs_buf2:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0
;	globl	mkfs_sb
mkfs_sb:
	.dw	#0
	.dw	#0
	.ds	#9

;	globl	blks_written
blks_written:
	.dw	#0
;	globl	mkfs_disk_write
;	extrn	disk_write
;	globl	mkfs_set_sb
;	extrn	memcpy
;	globl	mkfs_write_sb
;	globl	mkfs_clear_buf
;	globl	mkfs_write_ll
;	extrn	putchar
;	globl	mkfs_clear_inode_table
;	globl	mkfs_create_inodes
;	globl	mkfs_create_root
;	extrn	inode_get
;	extrn	inode_new
;	extrn	inode_put
;	globl	main
;	extrn	printf
;	extrn	superblock_read
;	extrn	fs_close

;	0 error(s) in compilation
;	literal pool:220
;	global pool:33
;	Macro pool:51
;	.end
