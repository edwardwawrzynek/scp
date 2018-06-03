;	Small C
;	8080 Backend Coder (2.4,84/11/27)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module SMALLC_GENERATED
	.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
	.nlist  (pag)
	.area  SMALLC_GENERATED  (REL,CON,CSEG)
abs:
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$2
	lxi 	h,#2
	dad 	sp
	call	ccgint
	call	ccneg
	jmp 	$1
	jmp 	$3
$2:
	lxi 	h,#2
	dad 	sp
	call	ccgint
	jmp 	$1
$3:
$1:
	ret
	.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	abs

;	0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
;	.end
