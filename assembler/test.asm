;	Small C
;	Small C Processor Backend Coder (Doesn't work right now)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module SMALLC_GENERATED
	.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
	.nlist  (pag)
	.area  SMALLC_GENERATED  (REL,CON,CSEG)
func:
	mdsp	-2
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#5
	push	h
	lxi 	h,#8
	dad 	sp
	mov 	l,m
	mvi 	h,0
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#5
	pop 	d
	call	ccasl
	push	h
	lxi 	h,#17905
	pop 	d
	call	ccor
	jmp 	$1
$1:
	mdsp	2
	ret
main:
	mdsp	-2
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#2
	xthl
	push	h
	mvi 	a,#1
	lxi 	h,#.+5
	xthl
	pchl
	mdsp	2
	call	ccgint
$2:
	mdsp	2
	ret
	.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	func
	.globl	main

;	0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:51
;	.end
