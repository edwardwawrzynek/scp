;	C Runtime 0 for SCP
;	For now, we just call the main function and halt afterwords
;	Edward Wawrzynek

	.module CRT0

	.text
	.align
_start:
	call.j.sp sp _main
	hlt.n.n
	hlt.n.n

;	Int vectors

;	Int Vector 0
	jmp.c.j elgLG _int_handler_0
	.extern _int_handler_0

;	Int Vector 1
	jmp.c.j elgLG _int_handler_1
	.extern _int_handler_1

;	Int Vector 2
	jmp.c.j elgLG _int_handler_2
	.extern _int_handler_2

;	Int Vector 3
	jmp.c.j elgLG _int_handler_3
	.extern _int_handler_3

;	Int Vector 4
	jmp.c.j elgLG _int_handler_4
	.extern _int_handler_4

;	Int Vector 5
	jmp.c.j elgLG _int_handler_5
	.extern _int_handler_5

;	Int Vector 6
	jmp.c.j elgLG _int_handler_6
	.extern _int_handler_6

;	Int Vector 7
	jmp.c.j elgLG _int_handler_7
	.extern _int_handler_7



	.extern _main

	.module
