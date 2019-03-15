;	C Runtime 0 for SCP
;	For now, we just call the main function and halt afterwords
;	Edward Wawrzynek

	.module CRT0

	.text
	.align
_start:
	call.j.sp sp _main
;	Call exit (load return value into ra)
	mov.r.r ra re
	call.j.sp sp _exit
	hlt.n.n
	.extern _main
	.extern _exit

	.module
