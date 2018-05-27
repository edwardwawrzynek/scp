;	Small C
;	Small C Processor Backend Coder (Doesn't work right now)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module SMALLC_GENERATED
	.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
	.nlist  (pag)
	.area  SMALLC_GENERATED  (REL,CON,CSEG)
open_asm:
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,$0+#0
	push	h
	mvi 	a,#2
	call	fopen
	mdsp	4
	shld	asm_file
	lhld	asm_file
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$2
	lxi 	h,$0+#2
	push	h
	mvi 	a,#1
	call	print
	mdsp	2
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	print
	mdsp	2
	lxi 	h,$0+#17
	push	h
	mvi 	a,#1
	call	print
	mdsp	2
	mdsp	0
$2:
	lxi 	h,#0
	jmp 	$1
$1:
	mdsp	0
	ret
file_restart:
	lhld	asm_file
	push	h
	lxi 	h,#0
	push	h
; fseek(asm_file, 0, SEEK_SET);
;                            ^
;******  undeclared variable  ******
	lxi 	h,SEEK_SET
	push	h
	mvi 	a,#3
	call	fseek
	mdsp	6
$3:
	mdsp	0
	ret
print:
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	printf
	mdsp	2
$4:
	mdsp	0
	ret
printn:
	lxi 	h,$0+#19
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	printf
	mdsp	4
$5:
	mdsp	0
	ret
err_exit:
	lxi 	h,#1
	push	h
	mvi 	a,#1
	call	exit
	mdsp	2
$6:
	mdsp	0
	ret
main:
;main(int argc, char **argv){
;                     ^
;******  illegal argument name  ******
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$8
	mvi 	a,#0
	call	usage
	mdsp	0
	mdsp	0
$8:
; open_asm(argv[1]);
;              ^
;******  undeclared variable  ******
; open_asm(argv[1]);
;               ^
;******  can't subscript  ******
	push	h
	lxi 	h,#1
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	mvi 	a,#1
	call	open_asm
	mdsp	2
	mvi 	a,#0
	call	file_restart
	mdsp	0
$7:
	mdsp	0
	ret
usage:
	lxi 	h,$0+#22
	push	h
	mvi 	a,#1
	call	print
	mdsp	2
	mvi 	a,#0
	call	err_exit
	mdsp	0
$9:
	mdsp	0
	ret
	.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$0:	.db	#114,#0,#78,#111,#32,#115,#117,#99
	.db	#104,#32,#102,#105,#108,#101,#58,#32
	.db	#0,#10,#0,#37,#105,#0,#85,#115
	.db	#97,#103,#101,#58,#32,#115,#99,#112
	.db	#97,#115,#109,#32,#91,#111,#110,#101
	.db	#32,#111,#114,#32,#109,#111,#114,#101
	.db	#32,#97,#115,#109,#32,#102,#105,#108
	.db	#101,#115,#93,#10,#0
	.globl	asm_file
asm_file:
	.dw	#0
	.globl	open_asm
	;extrn	fopen
	.globl	print
	.globl	file_restart
	;extrn	fseek
	;extrn	SEEK_SET
	;extrn	printf
	.globl	printn
	.globl	err_exit
	;extrn	exit
	.globl	main
	.globl	usage
	;extrn	argv

;	4 error(s) in compilation
;	literal pool:61
;	global pool:14
;	Macro pool:68
;	.end
