	.text
	.align
_filesort:
	.global	_filesort
	push.r.sp r0 sp
	ld.r.p.off.w r5 sp 6
	ld.r.p.off.w r4 sp 4
	mov.r.r ra r5
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r4
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r re r0
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_print_file:
	.global	_print_file
	push.r.sp r0 sp
	alu.r.i sub sp 14
	mov.r.r r0 sp
	ld.r.p.off.w ra sp 18
	mov.r.r rb r0
	call.j.sp sp _stat
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l6
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	ld.r.ra ra l7+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _perror
	alu.r.i add sp 2
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
	ld.r.i re 0
	jmp.c.j LGlge l3
l6:
	ld.r.m.b ra _i_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l9
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	ld.r.ra ra l10+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
l9:
	ld.r.m.b ra _l_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l12
	ld.r.ra ra l13+0
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 12
	push.r.sp r0 sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 16
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l15
	ld.r.i ra 99
	st.r.p.off.bs ra sp 10
	jmp.c.j LGlge l21
l15:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 8
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l18
	ld.r.i ra 112
	st.r.p.off.bs ra sp 10
	jmp.c.j LGlge l21
l18:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l21
	ld.r.i ra 100
	st.r.p.off.bs ra sp 10
l21:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 2
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l23
	ld.r.i ra 120
	st.r.p.off.bs ra sp 11
l23:
	mov.r.r r0 sp
	alu.r.i add r0 10
	push.r.sp r0 sp
	ld.r.ra ra l24+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
l12:
	ld.r.m.b ra _s_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l26
	ld.r.i ra 1024
	push.r.sp ra sp
	ld.r.p.off.w ra sp 10
	push.r.sp ra sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l27+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
l26:
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	ld.r.ra ra l28+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	ld.r.m.b ra _f_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l44
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 16
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l32
	ld.r.ra ra l33+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	jmp.c.j LGlge l44
l32:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 8
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l36
	ld.r.ra ra l37+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	jmp.c.j LGlge l44
l36:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l40
	ld.r.ra ra l41+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	jmp.c.j LGlge l44
l40:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 2
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l44
	ld.r.ra ra l45+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
l44:
	ld.r.m.b ra _l_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l47
	ld.r.ra ra l48+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	jmp.c.j LGlge l49
l47:
	ld.r.ra ra l50+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
l49:
	ld.r.p.off.w r0 sp 2
	alu.r.i band r0 1
	mov.r.r re r0
l3:
	alu.r.i add sp 14
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l7:
	.dc.bs	108
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	115
	.dc.bs	116
	.dc.bs	97
	.dc.bs	116
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	0

	.rodata
l10:
	.dc.bs	37
	.dc.bs	117
	.dc.bs	9
	.dc.bs	0

	.rodata
l13:
	.dc.bs	45
	.dc.bs	45
	.dc.bs	45
	.dc.bs	0

	.rodata
l24:
	.dc.bs	37
	.dc.bs	115
	.dc.bs	32
	.dc.bs	0

	.rodata
l27:
	.dc.bs	37
	.dc.bs	117
	.dc.bs	32
	.dc.bs	75
	.dc.bs	98
	.dc.bs	9
	.dc.bs	0

	.rodata
l33:
	.dc.bs	35
	.dc.bs	0

	.rodata
l37:
	.dc.bs	124
	.dc.bs	0

	.rodata
l41:
	.dc.bs	47
	.dc.bs	0

	.rodata
l45:
	.dc.bs	42
	.dc.bs	0

	.rodata
l48:
	.dc.bs	10
	.dc.bs	0

	.rodata
l50:
	.dc.bs	9
	.dc.bs	0

	.rodata
l28:
	.dc.bs	37
	.dc.bs	115
	.dc.bs	0
	.text
	.align
_list_dir:
	.global	_list_dir
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 24
	ld.r.ra ra l53+0
	ld.r.i rb 1
	call.j.sp sp _open
	st.r.p.off.w re sp 2
	ld.r.p.off.w ra sp 34
	call.j.sp sp _chdir
	mov.r.r r0 re
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l55
	ld.r.p.off.w ra sp 34
	push.r.sp ra sp
	ld.r.ra ra l56+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _perror
	alu.r.i add sp 2
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
	jmp.c.j LGlge l51
l55:
	ld.r.ra ra l57+0
	push.r.sp ra sp
	call.j.sp sp _opendir
	alu.r.i add sp 2
	mov.r.r r0 re
	st.r.p.off.w r0 sp 4
	ld.r.p.off.w ra sp 4
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l59
	ld.r.p.off.w ra sp 34
	push.r.sp ra sp
	ld.r.ra ra l60+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	ld.r.i ra 0
	push.r.sp ra sp
	call.j.sp sp _perror
	alu.r.i add sp 2
	ld.r.i ra 1
	st.r.m.b ra _did_error+0
	jmp.c.j LGlge l51
l59:
	ld.r.p.off.b ra sp 36
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l62
	ld.r.p.off.w ra sp 34
	push.r.sp ra sp
	ld.r.ra ra l63+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
l62:
	ld.r.i r2 0
	mov.r.r r0 sp
	alu.r.i add r0 8
	push.r.sp r0 sp
	ld.r.p.off.w ra sp 6
	push.r.sp ra sp
	call.j.sp sp _readdir
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j Le l66
	ld.r.p.off.w r1 sp 4
l64:
	alu.r.i add r2 1
	mov.r.r r0 sp
	alu.r.i add r0 8
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp _readdir
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j G l64
	st.r.p.off.w r1 sp 4
l66:
	ld.r.p.off.w ra sp 4
	ld.r.i rb 0
	ld.r.i rc 1
	call.j.sp sp _lseek
	mov.r.r r0 r2
	alu.r.i mul r0 2
	push.r.sp r0 sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r1 re
	ld.r.i r3 0
	mov.r.r r0 sp
	alu.r.i add r0 8
	push.r.sp r0 sp
	ld.r.p.off.w ra sp 6
	push.r.sp ra sp
	call.j.sp sp _readdir
	alu.r.i add sp 4
	mov.r.r r0 re
	st.r.p.w r1 sp
	st.r.p.off.w r2 sp 6
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j Le l118
l114:
	mov.r.r r1 sp
	alu.r.i add r1 10
	push.r.sp r1 sp
	call.j.sp sp _strlen
	alu.r.i add sp 2
	mov.r.r r0 re
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r2 re
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	ld.r.p.w r0 sp
	alu.r.r add r0 rc
	st.r.p.w r2 r0
	push.r.sp r1 sp
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	alu.r.i add r3 1
	mov.r.r r0 sp
	alu.r.i add r0 8
	push.r.sp r0 sp
	ld.r.p.off.w ra sp 6
	push.r.sp ra sp
	call.j.sp sp _readdir
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j G l114
l118:
	ld.r.p.off.w r2 sp 6
	ld.r.p.w r1 sp
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	call.j.sp sp _closedir
	alu.r.i add sp 2
	ld.r.m.b ra _f_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l71
	ld.r.ra ra _filesort+0
	push.r.sp ra sp
	ld.r.i ra 2
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r1 sp
	call.j.sp sp _qsort
	alu.r.i add sp 8
l71:
	ld.r.i r3 0
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j le l119
l115:
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	ld.r.p.w r0 r0
	ld.r.p.b r0 r0
	ld.r.i rc 46
	cmp.r.f r0 rc
	jmp.c.j GLgl l87
	ld.r.m.b ra _A_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l79
	ld.r.ra ra l83+0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l89
	ld.r.ra ra l84+0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l87
	jmp.c.j LGlge l89
l79:
	ld.r.m.b ra _a_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l89
l87:
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _print_file
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l89
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	ld.r.p.w r0 r0
	ld.r.i ra 0
	st.r.p.b ra r0
l89:
	alu.r.i add r3 1
	cmp.r.f r3 r2
	jmp.c.j l l115
l119:
	ld.r.m.b ra _l_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l91
	ld.r.ra ra l92+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
l91:
	ld.r.m.b ra _R_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l120
	ld.r.i r3 0
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j le l120
l116:
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	ld.r.p.w r0 r0
	ld.r.p.b r0 r0
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	ld.r.p.w r0 r0
	ld.r.p.b r0 r0
	ld.r.i rc 46
	cmp.r.f r0 rc
	jmp.c.j GLgl l112
	ld.r.m.b ra _A_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l104
	ld.r.ra ra l108+0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l98
	ld.r.ra ra l109+0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l112
	jmp.c.j LGlge l98
l104:
	ld.r.m.b ra _a_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l98
l112:
	ld.r.p.off.b r0 sp 36
	push.r.sp r0 sp
	mov.r.r r0 r3
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _list_dir
	alu.r.i add sp 4
l98:
	alu.r.i add r3 1
	cmp.r.f r3 r2
	jmp.c.j l l116
l120:
	ld.r.p.off.w r0 sp 2
	mov.r.r ra r0
	call.j.sp sp _fchdir
	mov.r.r ra r0
	call.j.sp sp _close
l51:
	alu.r.i add sp 24
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l56:
	.dc.bs	108
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	99
	.dc.bs	104
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	0

	.rodata
l60:
	.dc.bs	108
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	32
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	111
	.dc.bs	114
	.dc.bs	121
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	0

	.rodata
l63:
	.dc.bs	10
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	10
	.dc.bs	0

	.rodata
l83:
	.dc.bs	46
	.dc.bs	0

	.rodata
l84:
	.dc.bs	46
	.dc.bs	46
	.dc.bs	0

	.rodata
l92:
	.dc.bs	10
	.dc.bs	0

	.rodata
l108:
	.dc.bs	46
	.dc.bs	0

	.rodata
l109:
	.dc.bs	46
	.dc.bs	46
	.dc.bs	0

	.rodata
l53:
	.dc.bs	46
	.dc.bs	0

	.rodata
l57:
	.dc.bs	46
	.dc.bs	0
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r2 sp 12
	ld.r.p.off.w r1 sp 10
	ld.r.ra ra l126+0
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r1 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r5 re
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j e l151
l149:
	mov.r.r r0 r5
	ld.r.i rc 65
	cmp.r.f r5 rc
	jmp.c.j e l131
	ld.r.i rc 70
	cmp.r.f r0 rc
	jmp.c.j e l133
	ld.r.i rc 82
	cmp.r.f r0 rc
	jmp.c.j e l134
	ld.r.i rc 97
	cmp.r.f r0 rc
	jmp.c.j e l130
	ld.r.i rc 102
	cmp.r.f r0 rc
	jmp.c.j e l132
	ld.r.i rc 105
	cmp.r.f r0 rc
	jmp.c.j e l135
	ld.r.i rc 108
	cmp.r.f r0 rc
	jmp.c.j e l128
	ld.r.i rc 115
	cmp.r.f r0 rc
	jmp.c.j e l129
	jmp.c.j LGlge l136
l128:
	ld.r.i ra 1
	st.r.m.b ra _l_flag+0
	ld.r.i ra 1
	st.r.m.b ra _s_flag+0
	ld.r.i ra 1
	st.r.m.b ra _f_flag+0
	jmp.c.j LGlge l136
l129:
	ld.r.i ra 1
	st.r.m.b ra _s_flag+0
	jmp.c.j LGlge l136
l130:
	ld.r.i ra 1
	st.r.m.b ra _a_flag+0
	jmp.c.j LGlge l136
l131:
	ld.r.i ra 1
	st.r.m.b ra _A_flag+0
	jmp.c.j LGlge l136
l132:
	ld.r.i ra 1
	st.r.m.b ra _f_flag+0
	jmp.c.j LGlge l136
l133:
	ld.r.i ra 1
	st.r.m.b ra _F_flag+0
	jmp.c.j LGlge l136
l134:
	ld.r.i ra 1
	st.r.m.b ra _R_flag+0
	jmp.c.j LGlge l136
l135:
	ld.r.i ra 1
	st.r.m.b ra _i_flag+0
l136:
	ld.r.ra ra l137+0
	push.r.sp ra sp
	push.r.sp r2 sp
	push.r.sp r1 sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	mov.r.r r5 re
	ld.r.i rc -1
	cmp.r.f r5 rc
	jmp.c.j GLgl l149
l151:
	mov.r.r r0 r1
	alu.r.i sub r0 1
	ld.r.m.w ra _optind+0
	cmp.r.f ra r0
	jmp.c.j L l140
	ld.r.m.b ra _R_flag+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l140
	ld.r.i r6 0
	jmp.c.j LGlge l141
l140:
	ld.r.i r6 1
l141:
	mov.r.r r3 r6
	ld.r.m.w ra _optind+0
	cmp.r.f ra r1
	jmp.c.j L l143
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.ra ra l144+0
	push.r.sp ra sp
	call.j.sp sp _list_dir
	alu.r.i add sp 4
l143:
	ld.r.m.w ra _optind+0
	cmp.r.f ra r1
	jmp.c.j Ge l152
l150:
	mov.r.r r0 r3
	push.r.sp r0 sp
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r2
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _list_dir
	alu.r.i add sp 4
	ld.r.m.w r0 _optind+0
	alu.r.i add r0 1
	st.r.m.w r0 _optind+0
	cmp.r.f r0 r1
	jmp.c.j L l150
l152:
	ld.r.m.b r0 _did_error+0
	mov.r.r re r0
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l144:
	.dc.bs	46
	.dc.bs	0

	.rodata
l126:
	.dc.bs	108
	.dc.bs	97
	.dc.bs	65
	.dc.bs	102
	.dc.bs	70
	.dc.bs	82
	.dc.bs	115
	.dc.bs	105
	.dc.bs	0

	.rodata
l137:
	.dc.bs	108
	.dc.bs	97
	.dc.bs	65
	.dc.bs	102
	.dc.bs	70
	.dc.bs	82
	.dc.bs	115
	.dc.bs	105
	.dc.bs	0

	.data
_did_error:
	.global	_did_error
	.dc.bs	1

	.bss
	.extern	___crtudiv

	.bss
	.extern	_open

	.bss
	.extern	_close

	.bss
	.extern	_chdir

	.bss
	.extern	_fchdir

	.bss
	.extern	_readdir

	.bss
	.extern	_opendir

	.bss
	.extern	_closedir

	.bss
	.extern	_lseek

	.bss
	.extern	_stat

	.bss
	.extern	_optind

	.bss
	.extern	_getopt

	.bss
	.extern	_stderr

	.bss
	.extern	_perror

	.bss
	.extern	_printf

	.bss
	.extern	_fprintf

	.bss
	.extern	_qsort

	.bss
	.extern	_malloc

	.bss
	.extern	_strlen

	.bss
	.extern	_strcmp

	.bss
	.extern	_strcpy

	.bss
_l_flag:
	.global	_l_flag
	.ds	1

	.bss
_a_flag:
	.global	_a_flag
	.ds	1

	.bss
_A_flag:
	.global	_A_flag
	.ds	1

	.bss
_f_flag:
	.global	_f_flag
	.ds	1

	.bss
_F_flag:
	.global	_F_flag
	.ds	1

	.bss
_R_flag:
	.global	_R_flag
	.ds	1

	.bss
_s_flag:
	.global	_s_flag
	.ds	1

	.bss
_i_flag:
	.global	_i_flag
	.ds	1
;	End of VBCC generated section
	.module

