	.text
	.align
_read_line:
	.global	_read_line
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	ld.r.p.off.w r1 sp 12
	ld.r.i r2 0
l13:
	ld.r.i ra 1
	push.r.sp ra sp
	push.r.sp r1 sp
	push.r.sp r3 sp
	call.j.sp sp _read
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l7
	ld.r.i re -1
	jmp.c.j LGlge l14
l7:
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l10
	ld.r.i re 0
	jmp.c.j LGlge l14
l10:
	mov.r.r r0 r1
	ld.r.p.b r0 r0
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l12
	ld.r.i ra 0
	st.r.p.b ra r1
	mov.r.r re r2
	jmp.c.j LGlge l14
l12:
	alu.r.i add r1 1
	alu.r.i add r2 1
	jmp.c.j LGlge l13
l14:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_line_to_initrc:
	.global	_line_to_initrc
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.p.off.w r1 sp 16
	ld.r.i r2 0
	ld.r.i rc 3
	cmp.r.f r1 rc
	jmp.c.j Ge l18
	ld.r.i ra 2
	call.j.sp sp _exit
l18:
	ld.r.p.off.w r0 sp 14
	alu.r.r add r0 r2
	alu.r.i add r2 1
	mov.r.r ra r0
	ld.r.p.b ra ra
	st.r.p.b ra r3
	ld.r.p.off.w r0 sp 14
	alu.r.r add r0 r2
	alu.r.i add r2 1
	ld.r.p.b r0 r0
	ld.r.i rc 58
	cmp.r.f r0 rc
	jmp.c.j e l20
	ld.r.i ra 2
	call.j.sp sp _exit
l20:
	ld.r.p.off.w ra sp 14
	alu.r.r add ra r2
	st.r.p.w ra sp
	ld.r.ra r0 _line_buf+0
	alu.r.r add r0 r2
	alu.r.i add r2 1
	ld.r.p.b r0 r0
	ld.r.i rc 58
	cmp.r.f r0 rc
	jmp.c.j e l29
	mov.r.r r0 r1
	cmp.r.f r2 r0
	jmp.c.j ge l29
l28:
	ld.r.ra r0 _line_buf+0
	alu.r.r add r0 r2
	alu.r.i add r2 1
	ld.r.p.b r0 r0
	ld.r.i rc 58
	cmp.r.f r0 rc
	jmp.c.j e l29
	mov.r.r r0 r1
	cmp.r.f r2 r0
	jmp.c.j l l28
l29:
	mov.r.r r0 r1
	cmp.r.f r2 r0
	jmp.c.j l l27
	ld.r.i ra 2
	call.j.sp sp _exit
l27:
	ld.r.ra r0 _line_buf+-1
	alu.r.r add r0 r2
	ld.r.i ra 0
	st.r.p.b ra r0
	ld.r.p.off.w r0 sp 14
	alu.r.r add r0 r2
	ld.r.i ra 32
	push.r.sp ra sp
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	mov.r.r r1 r3
	alu.r.i add r1 1
	push.r.sp r1 sp
	call.j.sp sp _strncpy
	alu.r.i add sp 6
	ld.r.i ra 32
	push.r.sp ra sp
	push.r.sp r0 sp
	mov.r.r r0 r3
	alu.r.i add r0 33
	push.r.sp r0 sp
	call.j.sp sp _strncpy
	alu.r.i add sp 6
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_exec_cmd:
	.global	_exec_cmd
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w ra sp 6
	alu.r.i add ra 1
	ld.r.i rb 3
	call.j.sp sp _open
	mov.r.r r4 re
	ld.r.i rc -1
	cmp.r.f r4 rc
	jmp.c.j GLgl l33
	ld.r.i re 3
	jmp.c.j LGlge l30
l33:
	mov.r.r ra r4
	ld.r.i rb 4
	call.j.sp sp _dup2
	mov.r.r r1 re
	ld.r.i rc -1
	cmp.r.f r1 rc
	jmp.c.j GLgl l35
	ld.r.i re 4
	jmp.c.j LGlge l30
l35:
	mov.r.r ra r1
	ld.r.i rb 0
	call.j.sp sp _dup2
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l37
	ld.r.i re 4
	jmp.c.j LGlge l30
l37:
	mov.r.r ra r1
	ld.r.i rb 1
	call.j.sp sp _dup2
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l39
	ld.r.i re 4
	jmp.c.j LGlge l30
l39:
	mov.r.r ra r1
	ld.r.i rb 2
	call.j.sp sp _dup2
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l41
	ld.r.i re 4
	jmp.c.j LGlge l30
l41:
	mov.r.r ra r1
	call.j.sp sp _close
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l43
	ld.r.i re 4
	jmp.c.j LGlge l30
l43:
	ld.r.p.off.w ra sp 6
	alu.r.i add ra 33
	ld.r.i rb 0
	call.j.sp sp _execv
	ld.r.i re 5
l30:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_wait_respawn_cmd:
	.global	_wait_respawn_cmd
	push.r.sp r0 sp
	ld.r.p.off.w r4 sp 4
	mov.r.r r0 r4
	ld.r.p.b r0 r0
	ld.r.i rc 119
	cmp.r.f r0 rc
	jmp.c.j GLgl l47
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _wait
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l54
	ld.r.i ra 6
	call.j.sp sp _exit
	jmp.c.j LGlge l54
l47:
	mov.r.r r0 r4
	ld.r.p.b r0 r0
	ld.r.i rc 114
	cmp.r.f r0 rc
	jmp.c.j GLgl l54
	ld.r.p.off.w ra sp 6
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l54
	ld.r.i ra 68
	push.r.sp ra sp
	push.r.sp r4 sp
	ld.r.m.w r0 _respawn_index+0
	mov.r.r ra r0
	alu.r.i add ra 1
	st.r.m.w ra _respawn_index+0
	alu.r.i mul r0 68
	mov.r.r rc r0
	ld.r.ra r0 _respawn+0
	alu.r.r add r0 rc
	push.r.sp r0 sp
	call.j.sp sp _memcpy
	alu.r.i add sp 6
l54:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_run:
	.global	_run
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp _fork
	mov.r.r r1 re
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l58
	ld.r.p.off.w ra sp 10
	call.j.sp sp _close
	ld.r.p.off.w ra sp 6
	push.r.sp ra sp
	call.j.sp sp _exec_cmd
	alu.r.i add sp 2
l58:
	ld.r.p.off.w r0 sp 6
	alu.r.i add r0 66
	st.r.p.w r1 r0
	ld.r.p.off.w ra sp 8
	push.r.sp ra sp
	ld.r.p.off.w ra sp 8
	push.r.sp ra sp
	call.j.sp sp _wait_respawn_cmd
	alu.r.i add sp 4
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.ra ra l61+0
	ld.r.i rb 1
	call.j.sp sp _open
	st.r.p.w re sp
	ld.r.p.w ra sp
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l63
	ld.r.i ra 1
	call.j.sp sp _exit
l63:
	ld.r.p.w r0 sp
	mov.r.r ra r0
	ld.r.i rb 0
	ld.r.i rc 2
	call.j.sp sp _lseek
	ld.r.ra ra _line_buf+0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _read_line
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r4 r0
	ld.r.i rc 0
	cmp.r.f r4 rc
	jmp.c.j Le l66
	ld.r.p.w r1 sp
l64:
	push.r.sp r4 sp
	ld.r.ra ra _line_buf+0
	push.r.sp ra sp
	ld.r.ra ra _cur_cmd+0
	push.r.sp ra sp
	call.j.sp sp _line_to_initrc
	alu.r.i add sp 6
	mov.r.r r0 r1
	push.r.sp r0 sp
	ld.r.i ra 1
	push.r.sp ra sp
	ld.r.ra ra _cur_cmd+0
	push.r.sp ra sp
	call.j.sp sp _run
	alu.r.i add sp 6
	ld.r.ra ra _line_buf+0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _read_line
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r4 r0
	ld.r.i rc 0
	cmp.r.f r4 rc
	jmp.c.j G l64
	st.r.p.w r1 sp
l66:
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _wait
	alu.r.i add sp 2
	mov.r.r r3 re
	ld.r.i rc -1
	cmp.r.f r3 rc
	jmp.c.j e l84
l80:
	ld.r.i r2 0
	ld.r.m.w ra _respawn_index+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j le l85
l81:
	mov.r.r r1 r3
	mov.r.r r0 r2
	alu.r.i mul r0 68
	mov.r.r rc r0
	ld.r.ra r0 _respawn+0
	alu.r.r add r0 rc
	alu.r.i add r0 66
	mov.r.r rc r0
	ld.r.p.w rc rc
	cmp.r.f r1 rc
	jmp.c.j GLgl l75
	ld.r.p.w r0 sp
	push.r.sp r0 sp
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i mul r0 68
	mov.r.r rc r0
	ld.r.ra r0 _respawn+0
	alu.r.r add r0 rc
	push.r.sp r0 sp
	call.j.sp sp _run
	alu.r.i add sp 6
l75:
	alu.r.i add r2 1
	mov.r.r r0 r2
	ld.r.m.w rc _respawn_index+0
	cmp.r.f r0 rc
	jmp.c.j l l81
l85:
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _wait
	alu.r.i add sp 2
	mov.r.r r3 re
	ld.r.i rc -1
	cmp.r.f r3 rc
	jmp.c.j GLgl l80
l84:
	jmp.c.j LGlge l84
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l61:
	.dc.bs	47
	.dc.bs	105
	.dc.bs	110
	.dc.bs	105
	.dc.bs	116
	.dc.bs	114
	.dc.bs	99
	.dc.bs	0

	.bss
	.extern	_fork

	.bss
	.extern	_open

	.bss
	.extern	_read

	.bss
	.extern	_dup2

	.bss
	.extern	_close

	.bss
	.extern	_execv

	.bss
	.extern	_exit

	.bss
	.extern	_wait

	.bss
	.extern	_lseek

	.bss
	.extern	_memcpy

	.bss
	.extern	_strncpy

	.bss
_line_buf:
	.global	_line_buf
	.ds	128

	.bss
_respawn:
	.global	_respawn
	.align
	.ds	1088

	.bss
_respawn_index:
	.global	_respawn_index
	.align
	.ds	2

	.bss
_cur_cmd:
	.global	_cur_cmd
	.align
	.ds	68
;	End of VBCC generated section
	.module

