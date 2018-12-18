;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
hexdump:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mspa	#5
	psha	
	lwia	$0+#0
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	popb	
	swqa	
$106:
	mspa	#3
	lwpa	
	psha	
	mspa	#13
	lwpa	
	popb	
	ault	
	jpnz	$108
	jmp 	$109
$107:
	mspa	#3
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$106
$108:
	mspa	#5
	lwpa	
	psha	
	mspa	#11
	lwpa	
	lbpa	
	psha	
	lwia	#4
	popb	
	ashr	
	popb	
	aadd	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	mspa	#5
	lwpa	
	psha	
	mspa	#11
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	psha	
	lwia	#15
	popb	
	abnd	
	popb	
	aadd	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	mspa	#0
	psha	
	mspa	#5
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccudiv
	xswp	
	psha	
	lwia	#9
	popb	
	aequ	
	popb	
	sbqa	
	mspa	#0
	lbpa	
	jpz 	$110
	lwia	#124
	jmp 	$111
$110:
	lwia	#32
$111:
	psha	
	call	putchar
	mdsp	#2
	mspa	#0
	lbpa	
	jpz 	$112
	mspa	#9
	psha	
	mspa	#11
	lwpa	
	psha	
	lwia	#10
	popb	
	asub	
	popb	
	swqa	
	mspa	#1
	psha	
	lwia	#0
	popb	
	swqa	
$113:
	mspa	#1
	lwpa	
	psha	
	lwia	#10
	popb	
	ault	
	jpnz	$115
	jmp 	$116
$114:
	mspa	#1
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$113
$115:
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#10
	popb	
	aneq	
	jpz 	$118
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#9
	popb	
	aneq	
$118:
	aclv	
	jpz 	$119
	mspa	#9
	lwpa	
	lbpa	
	psha	
	lwia	#8
	popb	
	aneq	
$119:
	aclv	
	jpz 	$117
	mspa	#9
	lwpa	
	lbpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$120
$117:
	lwia	#219
	psha	
	call	putchar
	mdsp	#2
$120:
	mspa	#9
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$114
$116:
$112:
	jmp 	$107
$109:
$105:
	mdsp	#7
	ret 	
list_dir:
	mdsp	#-2
	mdsp	#-14
	mspa	#14
	psha	
	mspa	#2
	psha	
	mspa	#22
	lwpa	
	psha	
	call	dir_next_entry
	mdsp	#4
	popb	
	swqa	
$122:
	mspa	#14
	lwpa	
	jpz 	$123
	mspa	#0
	psha	
	mspa	#16
	lwpa	
	psha	
	lwia	$0+#17
	psha	
	call	printf
	mdsp	#6
	mspa	#14
	psha	
	mspa	#2
	psha	
	mspa	#22
	lwpa	
	psha	
	call	dir_next_entry
	mdsp	#4
	popb	
	swqa	
	jmp 	$122
$123:
$121:
	mdsp	#16
	ret 	
debug:

        .db #254
        .db #1
    
$124:
	ret 	
switch_to_user:

        lbia    #0
        aptb
        prvu
    
$125:
	ret 	
switch_to_sys:

        lbia    #0
        aptb
        prvs
    
$126:
	ret 	
serial_load:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-8
	mdsp	#-1
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#11
	psha	
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	mspa	#25
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	popb	
	swqa	
	mspa	#13
	psha	
	lwia	#4
	psha	
	lwia	#2
	popb	
	abor	
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
$128:
	lwia	#1
	jpz 	$129
	mspa	#2
	psha	
	call	serial_read
	popb	
	sbqa	
	mspa	#2
	lbpa	
	psha	
	call	serial_write
	mdsp	#2
	mspa	#0
	lwpa	
	psha	
	lwia	#3
	popb	
	aule	
	alng	
	jpz 	$130
	lwia	#1
	psha	
	mspa	#5
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#17
	lwpa	
	psha	
	call	file_write
	mdsp	#6
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#5
	popb	
	aadd	
	popb	
	swqa	
$130:
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#5
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	psha	
	mspa	#4
	lbpa	
	popb	
	swqa	
	mspa	#3
	psha	
	lwia	#0
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$132
	mspa	#3
	psha	
	lwia	#1
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#255
	popb	
	aequ	
$132:
	aclv	
	jpz 	$133
	mspa	#3
	psha	
	lwia	#2
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#15
	popb	
	aequ	
$133:
	aclv	
	jpz 	$134
	mspa	#3
	psha	
	lwia	#3
	lbib	#2
	amul	
	popb	
	aadd	
	lwpa	
	psha	
	lwia	#240
	popb	
	aequ	
$134:
	aclv	
	jpz 	$131
	mspa	#13
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	jmp 	$127
$131:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$128
$129:
$127:
	mdsp	#15
	ret 	
file_print:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-1
	mdsp	#-2
	mspa	#3
	psha	
	mspa	#11
	lwpa	
	psha	
	mspa	#15
	lwpa	
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#3
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$136
	mspa	#11
	lwpa	
	psha	
	lwia	$0+#25
	psha	
	call	printf
	mdsp	#4
	jmp 	$135
$136:
	mspa	#5
	psha	
	lwia	#1
	psha	
	mspa	#7
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
$137:
	lwia	#1
	psha	
	mspa	#2
	psha	
	mspa	#9
	lwpa	
	psha	
	call	file_read
	mdsp	#6
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$138
	mspa	#0
	lwpa	
	psha	
	call	putchar
	mdsp	#2
	jmp 	$137
$138:
$135:
	mdsp	#7
	ret 	
main:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-3
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	call	switch_to_sys
	lwia	_MEM_END
	swma	brk
	lwia	$0+#43
	psha	
	call	printf
	mdsp	#2
	call	kernel_init
	lwia	$0+#59
	psha	
	call	printf
	mdsp	#2
	call	switch_to_user
	mspa	#11
	psha	
	lwia	#2
	popb	
	swqa	
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	lwia	buf
	psha	
	lwia	#2
	popb	
	aadd	
	swma	arg
$140:
	lwia	#1
	jpz 	$141
	mspa	#11
	lwpa	
	psha	
	lwia	$0+#74
	psha	
	call	printf
	mdsp	#4
	lwia	$0+#84
	psha	
	call	printf
	mdsp	#2
	lwia	buf
	psha	
	call	gets
	mdsp	#2
	mspa	#0
	psha	
	lwma	arg
	popb	
	swqa	
$142:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aneq	
	jpz 	$143
	jmp 	$142
$143:
	mspa	#0
	lwpa	
	swma	arg2
	mspa	#0
	lwpa	
	psha	
	lwia	buf
	psha	
	lwia	#256
	popb	
	aadd	
	popb	
	ault	
	jpz 	$145
	mspa	#0
	lwpa	
	psha	
	lwia	buf
	popb	
	ault	
	alng	
$145:
	aclv	
	jpz 	$144
	mspa	#0
	lwpa	
	psha	
	lwia	#1
	popb	
	asub	
	psha	
	lwia	#0
	popb	
	sbqa	
$144:
	mspa	#19
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	lwia	#1
	psha	
	lwia	#0
	psha	
	mspa	#23
	lwpa	
	psha	
	call	file_seek
	mdsp	#6
	lwia	#10
	psha	
	call	putchar
	mdsp	#2
	lwia	$146
	psha	
	lwia	buf
	psha	
	lwia	#0
	popb	
	aadd	
	lbpa	
	asex	
	jmp 	cccase
$148:
	call	fs_close

                .db #255
                
	jmp 	$147
$149:
	mspa	#19
	lwpa	
	psha	
	call	list_dir
	mdsp	#2
	jmp 	$147
$150:
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	lwia	#0
	psha	
	lwia	#0
	psha	
	lwma	arg
	psha	
	mspa	#23
	lwpa	
	psha	
	call	dir_make_file
	mdsp	#8
	psha	
	lwia	$0+#87
	psha	
	call	printf
	mdsp	#10
	jmp 	$147
$151:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	dir_delete_file
	mdsp	#4
	jmp 	$147
$152:
	lwma	arg
	psha	
	lwma	arg
	psha	
	mspa	#15
	lwpa	
	psha	
	call	dir_name_inum
	mdsp	#4
	psha	
	lwia	$0+#91
	psha	
	call	printf
	mdsp	#6
	jmp 	$147
$153:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	dir_make_dir
	mdsp	#4
	jmp 	$147
$154:
	mspa	#13
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#13
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$155
	lwia	$0+#95
	psha	
	call	printf
	mdsp	#2
	jmp 	$147
$155:
	mspa	#11
	psha	
	mspa	#15
	lwpa	
	popb	
	swqa	
	mspa	#19
	lwpa	
	psha	
	call	file_put
	mdsp	#2
	mspa	#19
	psha	
	lwia	#1
	psha	
	mspa	#15
	lwpa	
	psha	
	call	file_get
	mdsp	#4
	popb	
	swqa	
	jmp 	$147
$156:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	serial_load
	mdsp	#4
	jmp 	$147
$157:
	lwma	arg
	psha	
	mspa	#13
	lwpa	
	psha	
	call	file_print
	mdsp	#4
	jmp 	$147
$158:
	call	debug
	jmp 	$147
$159:
	call	switch_to_sys
	mspa	#4
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#17
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#100
	psha	
	call	proc_create_new
	mdsp	#4
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#13
	lwpa	
	psha	
	lwma	arg2
	psha	
	call	fs_path_to_inum
	mdsp	#4
	popb	
	swqa	
	mspa	#15
	psha	
	mspa	#4
	lwpa	
	psha	
	lwia	#101
	psha	
	call	proc_create_new
	mdsp	#4
	popb	
	swqa	
	mspa	#17
	lwpa	
	jpz 	$161
	mspa	#15
	lwpa	
$161:
	aclv	
	jpz 	$160
	call	shed_shedule
	jmp 	$162
$160:
	lwia	$0+#108
	psha	
	call	printf
	mdsp	#2
$162:
	call	switch_to_user
	jmp 	$147
$163:
	lwia	buf
	psha	
	lwia	#0
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	$0+#117
	psha	
	call	printf
	mdsp	#4
	jmp 	$147
	jmp 	$147
;	Data Segment
$146:
	.dw	#101,$148,#108,$149,#109,$150,#114,$151
	.dw	#105,$152,#100,$153,#99,$154,#115,$156
	.dw	#112,$157,#120,$158,#110,$159
	.dw	$163,#0
;	Code Segment
$147:
	jmp 	$140
$141:
$139:
	mdsp	#21
	ret 	
atoi:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$165:
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#32
	popb	
	aequ	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#10
	popb	
	aequ	
	popb	
	abor	
	psha	
	mspa	#10
	lwpa	
	psha	
	mspa	#8
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#9
	popb	
	aequ	
	popb	
	abor	
	jpnz	$167
	jmp 	$168
$166:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$165
$167:
	jmp 	$166
$168:
	mspa	#0
	psha	
	lwia	#1
	popb	
	swqa	
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#45
	popb	
	aequ	
	jpz 	$169
	mspa	#0
	psha	
	lwia	#1
	aneg	
	popb	
	swqa	
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
$169:
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$170:
	mspa	#8
	lwpa	
	psha	
	mspa	#6
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	call	_isdigit
	mdsp	#2
	jpnz	$172
	jmp 	$173
$171:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$170
$172:
	mspa	#2
	psha	
	lwia	#10
	psha	
	mspa	#6
	lwpa	
	popb	
	amul	
	psha	
	mspa	#12
	lwpa	
	psha	
	mspa	#10
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	popb	
	aadd	
	psha	
	lwia	#48
	popb	
	asub	
	popb	
	swqa	
	jmp 	$171
$173:
	mspa	#0
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	amul	
	jmp 	$164
$164:
	mdsp	#6
	ret 	
_isdigit:
	mspa	#2
	lbpa	
	asex	
	psha	
	lwia	#48
	popb	
	aslt	
	alng	
	psha	
	mspa	#4
	lbpa	
	asex	
	psha	
	lwia	#57
	popb	
	asle	
	popb	
	abnd	
	jpz 	$175
	lwia	#1
	jmp 	$174
	jmp 	$176
$175:
	lwia	#0
	jmp 	$174
$176:
$174:
	ret 	
;	Data Segment
$0:	.db	#48,#49,#50,#51,#52,#53,#54,#55
	.db	#56,#57,#97,#98,#99,#100,#101,#102
	.db	#0,#37,#117,#58,#32,#37,#115,#10
	.db	#0,#110,#111,#32,#115,#117,#99,#104
	.db	#32,#102,#105,#108,#101,#58,#32,#37
	.db	#115,#10,#0,#73,#110,#105,#116,#105
	.db	#110,#103,#32,#75,#101,#114,#110,#101
	.db	#108,#10,#0,#75,#101,#114,#110,#101
	.db	#108,#32,#73,#110,#105,#116,#101,#100
	.db	#10,#0,#10,#67,#87,#68,#58,#32
	.db	#37,#117,#10,#0,#36,#32,#0,#37
	.db	#117,#10,#0,#37,#117,#10,#0,#78
	.db	#111,#32,#115,#117,#99,#104,#32,#100
	.db	#105,#114,#10,#0,#70,#97,#105,#108
	.db	#117,#114,#101,#10,#0,#78,#111,#32
	.db	#115,#117,#99,#104,#32,#99,#111,#109
	.db	#109,#97,#110,#100,#58,#32,#37,#99
	.db	#10,#0
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
;	extrn	_getcharshifted
;	extrn	_getcharecho
;	extrn	_screenpos
;	extrn	brk
;	extrn	_MEM_END
;	globl	buf
buf:
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
	.db	#0,#0,#0,#0,#0,#0
;	globl	arg
arg:
	.dw	#0
;	globl	arg2
arg2:
	.dw	#0
;	globl	arg3
arg3:
	.dw	#0
;	globl	hexdump
;	extrn	putchar
;	globl	list_dir
;	extrn	dir_next_entry
;	extrn	printf
;	globl	debug
;	globl	switch_to_user
;	globl	switch_to_sys
;	globl	serial_load
;	extrn	dir_make_file
;	extrn	file_get
;	extrn	serial_read
;	extrn	serial_write
;	extrn	file_write
;	extrn	file_put
;	globl	file_print
;	extrn	fs_path_to_inum
;	extrn	file_read
;	globl	main
;	extrn	kernel_init
;	extrn	gets
;	extrn	file_seek
;	extrn	fs_close
;	extrn	dir_delete_file
;	extrn	dir_name_inum
;	extrn	dir_make_dir
;	extrn	proc_create_new
;	extrn	shed_shedule
;	globl	atoi
;	globl	_isdigit

;	0 error(s) in compilation
;	literal pool:138
;	global pool:50
;	Macro pool:51
;	.end
