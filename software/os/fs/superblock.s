;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
superblock_read:
	lwia	fs_global_buf
	psha	
	lwia	#383
	psha	
	call	disk_read
	mdsp	#4
	lwia	#13
	psha	
	lwia	fs_global_buf
	psha	
	lwia	superblk
	psha	
	call	memcpy
	mdsp	#6
$76:
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
;	globl	superblk
superblk:
	.dw	#0
	.dw	#0
	.ds	#9

;	globl	superblock_read
;	extrn	disk_read
;	extrn	memcpy

;	0 error(s) in compilation
;	literal pool:0
;	global pool:14
;	Macro pool:51
;	.end
