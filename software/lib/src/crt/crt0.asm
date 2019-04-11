;	C Runtime 0 for SCP
;	For now, we just call the main function and halt afterwords
;	Edward Wawrzynek

	.module CRT0

	.text
	.align
_START:
	.global _START
	call.j.sp sp __init_stdio
	call.j.sp sp _main
;	Call exit (load return value into ra)
	st.r.m.w re _START_RET
	call.j.sp sp __close_stdio
	ld.r.m.w ra _START_RET
	call.j.sp sp _exit
	hlt.n.n
	.extern _main
	.extern _exit
	.extern __init_stdio
	.extern __close_stdio

	.data
	.align
_START_RET:
	.dc.w 0

	.module
