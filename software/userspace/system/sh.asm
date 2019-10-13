	.text
	.align
_branch_new:
	.global	_branch_new
	push.r.sp r0 sp
	ld.r.i ra 8
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l4
	ld.r.i re 0
	jmp.c.j LGlge l1
l4:
	ld.r.i ra 8
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _memset
	alu.r.i add sp 6
	mov.r.r re r0
l1:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_branch_set_cmd:
	.global	_branch_set_cmd
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	ld.r.p.off.w ra sp 10
	push.r.sp ra sp
	call.j.sp sp _strlen
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r4 r0
	alu.r.i add r4 1
	mov.r.r r0 r2
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l8
	push.r.sp r4 sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r2
	alu.r.i add r0 2
	st.r.p.w r1 r0
	jmp.c.j LGlge l9
l8:
	push.r.sp r4 sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.p.w re r0
l9:
	ld.r.p.off.w ra sp 10
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcpy
	alu.r.i add sp 4
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_branch_add_child:
	.global	_branch_add_child
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r4 sp 6
	mov.r.r r0 r4
	alu.r.i add r0 4
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i add ra 1
	st.r.p.w ra r0
	mov.r.r r1 r0
	ld.r.p.w r1 r1
	alu.r.i mul r1 2
	push.r.sp r1 sp
	mov.r.r r1 r4
	alu.r.i add r1 6
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.p.w re r1
	ld.r.p.w r0 r0
	alu.r.i sub r0 1
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	ld.r.p.off.w ra sp 8
	st.r.p.w ra r0
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_branch_set_type:
	.global	_branch_set_type
	ld.r.p.off.w r4 sp 2
	ld.r.p.off.w ra sp 4
	st.r.p.w ra r4
	ret.n.sp sp
	.text
	.align
_branch_free:
	.global	_branch_free
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l17
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _free
	alu.r.i add sp 2
l17:
	ld.r.i r2 0
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j le l23
l22:
	mov.r.r r1 r3
	alu.r.i add r1 6
	mov.r.r r0 r2
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _branch_free
	alu.r.i add sp 2
	alu.r.i add r2 1
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r rc r0
	ld.r.p.w rc rc
	cmp.r.f r2 rc
	jmp.c.j l l22
l23:
	mov.r.r r0 r3
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _free
	alu.r.i add sp 2
	push.r.sp r3 sp
	call.j.sp sp _free
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_print_branch:
	.global	_print_branch
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	ld.r.p.off.w r3 sp 10
	ld.r.i r0 0
	ld.r.p.off.w ra sp 12
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j Le l28
	ld.r.p.off.w r1 sp 12
l26:
	ld.r.ra ra l30+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	alu.r.i add r0 1
	cmp.r.f r0 r1
	jmp.c.j L l26
	st.r.p.off.w r1 sp 12
l28:
	mov.r.r ra r3
	ld.r.p.w ra ra
	ld.r.i rc 5
	cmp.r.f ra rc
	jmp.c.j GLgl l32
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l33+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	jmp.c.j LGlge l43
l32:
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r ra r3
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r1 r3
	alu.r.i add r1 2
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l35+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 8
	ld.r.i r2 0
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j le l43
l41:
	ld.r.p.off.w r0 sp 12
	alu.r.i add r0 1
	push.r.sp r0 sp
	mov.r.r r1 r3
	alu.r.i add r1 6
	mov.r.r r0 r2
	alu.r.i mul r0 2
	mov.r.r rc r0
	mov.r.r r0 r1
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _print_branch
	alu.r.i add sp 4
	alu.r.i add r2 1
	mov.r.r r1 r2
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r rc r0
	ld.r.p.w rc rc
	cmp.r.f r1 rc
	jmp.c.j l l41
l43:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l30:
	.dc.bs	32
	.dc.bs	32
	.dc.bs	0

	.rodata
l33:
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	108
	.dc.bs	101
	.dc.bs	97
	.dc.bs	102
	.dc.bs	10
	.dc.bs	0

	.rodata
l35:
	.dc.bs	37
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	98
	.dc.bs	114
	.dc.bs	97
	.dc.bs	110
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	116
	.dc.bs	121
	.dc.bs	112
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	44
	.dc.bs	32
	.dc.bs	99
	.dc.bs	104
	.dc.bs	105
	.dc.bs	108
	.dc.bs	100
	.dc.bs	114
	.dc.bs	101
	.dc.bs	110
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_io_raw_char:
	.global	_io_raw_char
	push.r.sp r0 sp
	ld.r.m.w ra _fin+0
	push.r.sp ra sp
	call.j.sp sp _fgetc
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r re r0
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_io_back:
	.global	_io_back
	ld.r.i ra 2
	push.r.sp ra sp
	ld.r.i ra -1
	push.r.sp ra sp
	ld.r.m.w ra _fin+0
	push.r.sp ra sp
	call.j.sp sp _fseek
	alu.r.i add sp 6
	ret.n.sp sp
	.text
	.align
_io_char:
	.global	_io_char
	push.r.sp r0 sp
l73:
	call.j.sp sp _io_raw_char
	mov.r.r r4 re
	mov.r.r r0 r4
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l56
	ld.r.i re -1
	jmp.c.j LGlge l48
l56:
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l58
	ld.r.m.w ra _io_line+0
	alu.r.i add ra 1
	st.r.m.w ra _io_line+0
l58:
	ld.r.m.b ra l50+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l60
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l60
	ld.r.i ra 0
	st.r.m.b ra l50+0
	jmp.c.j LGlge l69
l60:
	ld.r.m.b ra l50+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l63
	mov.r.r r0 r4
	ld.r.i rc 35
	cmp.r.f r0 rc
	jmp.c.j GLgl l63
	ld.r.i ra 1
	st.r.m.b ra l50+0
l63:
	ld.r.m.b ra l50+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l66
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j GLgl l66
	ld.r.i ra 1
	st.r.m.b ra l51+0
	ld.r.i ra 0
	st.r.m.b ra l50+0
l66:
	ld.r.m.b ra l51+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l69
	ld.r.m.b r0 l50+0
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j GLgl l69
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j GLgl l69
	ld.r.i ra 0
	st.r.m.b ra l50+0
	ld.r.i ra 0
	st.r.m.b ra l51+0
l69:
	ld.r.m.b ra l50+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l73
	ld.r.m.b ra l51+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l73
	mov.r.r re r4
l48:
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
l50:
	.dc.bs	0

	.data
l51:
	.dc.bs	0
	.text
	.align
_io_skip_whitespace:
	.global	_io_skip_whitespace
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.b r2 sp 8
l77:
	call.j.sp sp _io_char
	mov.r.r r1 re
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _isspace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l83
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j GLgl l77
	mov.r.r r0 r1
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l77
l83:
	call.j.sp sp _io_back
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_io_read_symbol:
	.global	_io_read_symbol
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.i r2 0
	ld.r.m.w ra l87+0
	ld.r.i rc 256
	cmp.r.f ra rc
	jmp.c.j le l112
	ld.r.i ra 32
	push.r.sp ra sp
	ld.r.m.w ra l86+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re l86+0
	ld.r.i ra 32
	st.r.m.w ra l87+0
l112:
	call.j.sp sp _io_char
	mov.r.r r1 re
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _isalnum
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l94
	mov.r.r r0 r1
	ld.r.i rc 95
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 34
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 39
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 43
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 45
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 42
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 47
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 37
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 61
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 33
	cmp.r.f r0 rc
	jmp.c.j e l94
	mov.r.r r0 r1
	ld.r.i rc 46
	cmp.r.f r0 rc
	jmp.c.j e l94
	ld.r.i r1 0
l94:
	mov.r.r r0 r2
	alu.r.i add r0 1
	ld.r.m.w rc l87+0
	cmp.r.f r0 rc
	jmp.c.j le l109
	ld.r.m.w r0 l87+0
	alu.r.i add r0 32
	push.r.sp r0 sp
	ld.r.m.w ra l86+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re l86+0
	ld.r.m.w ra l87+0
	alu.r.i add ra 32
	st.r.m.w ra l87+0
l109:
	mov.r.r r0 r2
	alu.r.i add r2 1
	mov.r.r rc r0
	ld.r.m.w r0 l86+0
	alu.r.r add r0 rc
	st.r.p.bs r1 r0
	mov.r.r r0 r1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l112
	ld.r.i rc 1
	cmp.r.f r2 rc
	jmp.c.j g l111
	ld.r.i re 0
	jmp.c.j LGlge l84
l111:
	call.j.sp sp _io_back
	ld.r.m.w re l86+0
l84:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
l86:
	.align
	.dc.w	0

	.data
l87:
	.align
	.dc.w	0
	.text
	.align
_io_test_char:
	.global	_io_test_char
	push.r.sp r0 sp
	push.r.sp r1 sp
	call.j.sp sp _io_char
	mov.r.r r1 re
	ld.r.p.off.bs r0 sp 6
	cmp.r.f r1 r0
	jmp.c.j GLgl l117
	ld.r.i re 1
	jmp.c.j LGlge l114
l117:
	call.j.sp sp _io_back
	ld.r.i re 0
l114:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_parse_error:
	.global	_parse_error
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.i r1 0
	ld.r.m.w ra _io_line+0
	push.r.sp ra sp
	ld.r.ra ra l120+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
	call.j.sp sp _io_back
	call.j.sp sp _io_char
	mov.r.r r0 re
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j e l137
l134:
	call.j.sp sp _io_back
	call.j.sp sp _io_back
	alu.r.i add r1 1
	call.j.sp sp _io_char
	mov.r.r r0 re
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l134
l137:
	call.j.sp sp _io_char
	mov.r.r r4 re
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j e l138
l135:
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	mov.r.r r0 r4
	push.r.sp r0 sp
	call.j.sp sp _fputc
	alu.r.i add sp 4
	call.j.sp sp _io_char
	mov.r.r r4 re
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l135
l138:
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.i ra 10
	push.r.sp ra sp
	call.j.sp sp _fputc
	alu.r.i add sp 4
	ld.r.i r2 0
	mov.r.r r0 r1
	alu.r.i sub r0 1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j Le l139
l136:
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.i ra 32
	push.r.sp ra sp
	call.j.sp sp _fputc
	alu.r.i add sp 4
	alu.r.i add r2 1
	mov.r.r r0 r1
	alu.r.i sub r0 1
	cmp.r.f r2 r0
	jmp.c.j L l136
l139:
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.ra ra l131+0
	push.r.sp ra sp
	call.j.sp sp _fputs
	alu.r.i add sp 4
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.ra ra l132+0
	push.r.sp ra sp
	call.j.sp sp _fputs
	alu.r.i add sp 4
	mov.r.r r0 sp
	alu.r.i add r0 8
	alu.r.i add r0 2
	push.r.sp r0 sp
	ld.r.p.off.w ra sp 10
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _vfprintf
	alu.r.i add sp 6
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.ra ra l133+0
	push.r.sp ra sp
	call.j.sp sp _fputs
	alu.r.i add sp 4
	ld.r.i ra 1
	call.j.sp sp _exit
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l120:
	.dc.bs	115
	.dc.bs	99
	.dc.bs	112
	.dc.bs	45
	.dc.bs	115
	.dc.bs	104
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	108
	.dc.bs	105
	.dc.bs	110
	.dc.bs	101
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	10
	.dc.bs	10
	.dc.bs	0

	.rodata
l131:
	.dc.bs	94
	.dc.bs	10
	.dc.bs	0

	.rodata
l132:
	.dc.bs	112
	.dc.bs	97
	.dc.bs	114
	.dc.bs	115
	.dc.bs	101
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	0

	.rodata
l133:
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_isbracket:
	.global	_isbracket
	push.r.sp r0 sp
	ld.r.p.off.bs r4 sp 4
	mov.r.r r0 r4
	ld.r.i rc 40
	cmp.r.f r0 rc
	jmp.c.j e l144
	mov.r.r r0 r4
	ld.r.i rc 41
	cmp.r.f r0 rc
	jmp.c.j e l144
	mov.r.r r0 r4
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l144
	mov.r.r r0 r4
	ld.r.i rc 125
	cmp.r.f r0 rc
	jmp.c.j e l144
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l144
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j e l144
	ld.r.i r5 0
	jmp.c.j LGlge l145
l144:
	ld.r.i r5 1
l145:
	mov.r.r r0 r5
	mov.r.r re r0
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_isopenbracket:
	.global	_isopenbracket
	push.r.sp r0 sp
	ld.r.p.off.bs r5 sp 4
	mov.r.r r0 r5
	ld.r.i rc 40
	cmp.r.f r0 rc
	jmp.c.j e l154
	mov.r.r r0 r5
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l154
	mov.r.r r0 r5
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l154
	ld.r.i r4 0
	jmp.c.j LGlge l155
l154:
	ld.r.i r4 1
l155:
	mov.r.r r0 r4
	mov.r.r re r0
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_isclosebracket:
	.global	_isclosebracket
	push.r.sp r0 sp
	ld.r.p.off.bs r0 sp 4
	push.r.sp r0 sp
	call.j.sp sp _isbracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l161
	ld.r.p.off.bs r0 sp 4
	push.r.sp r0 sp
	call.j.sp sp _isopenbracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l161
	ld.r.i r4 1
	jmp.c.j LGlge l162
l161:
	ld.r.i r4 0
l162:
	mov.r.r r0 r4
	mov.r.r re r0
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_parse_bracket_to_type:
	.global	_parse_bracket_to_type
	push.r.sp r0 sp
	ld.r.p.off.bs r4 sp 4
	mov.r.r r0 r4
	ld.r.i rc 40
	cmp.r.f r0 rc
	jmp.c.j e l165
	mov.r.r r0 r4
	ld.r.i rc 41
	cmp.r.f r0 rc
	jmp.c.j GLgl l166
l165:
	ld.r.i re 1
	jmp.c.j LGlge l163
l166:
	mov.r.r r0 r4
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l168
	mov.r.r r0 r4
	ld.r.i rc 125
	cmp.r.f r0 rc
	jmp.c.j GLgl l169
l168:
	ld.r.i re 4
	jmp.c.j LGlge l163
l169:
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l171
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j GLgl l172
l171:
	ld.r.i re 3
	jmp.c.j LGlge l163
l172:
	ld.r.i re 0
l163:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_branch_get_closing_bracket:
	.global	_branch_get_closing_bracket
	ld.r.p.off.w r5 sp 2
	mov.r.r r4 r5
	ld.r.p.w r4 r4
	ld.r.i rc 1
	cmp.r.f r4 rc
	jmp.c.j e l176
	ld.r.i rc 2
	cmp.r.f r4 rc
	jmp.c.j e l176
	ld.r.i rc 6
	cmp.r.f r4 rc
	jmp.c.j GLgl l177
l176:
	ld.r.i re 41
	jmp.c.j LGlge l183
l177:
	ld.r.i rc 4
	cmp.r.f r4 rc
	jmp.c.j GLgl l181
	ld.r.i re 125
	jmp.c.j LGlge l183
l181:
	ld.r.i rc 3
	cmp.r.f r4 rc
	jmp.c.j GLgl l183
	ld.r.i re 62
l183:
	ret.n.sp sp
	.text
	.align
_parse:
	.global	_parse
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r2 sp 12
	ld.r.i r0 1
	push.r.sp r0 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
	call.j.sp sp _io_char
	mov.r.r r8 re
	mov.r.r r0 r8
	push.r.sp r0 sp
	st.r.p.off.bs r8 sp 2
	call.j.sp sp _isopenbracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.p.bs r8 sp
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l190
	ld.r.i r3 0
	mov.r.r r0 r8
	push.r.sp r0 sp
	call.j.sp sp _parse_bracket_to_type
	alu.r.i add sp 2
	st.r.p.w re r2
	ld.r.i r0 1
	push.r.sp r0 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
	jmp.c.j LGlge l194
l190:
	ld.r.i r3 1
	ld.r.i ra 1
	st.r.p.w ra r2
	call.j.sp sp _io_back
l194:
	ld.r.i ra 94
	push.r.sp ra sp
	call.j.sp sp _io_test_char
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l196
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j GLgl l196
	ld.r.i ra 2
	st.r.p.w ra r2
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j GLgl l198
	ld.r.i r6 1
	jmp.c.j LGlge l199
l198:
	ld.r.i r6 0
l199:
	push.r.sp r6 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
l196:
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l201
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j GLgl l202
l201:
	call.j.sp sp _io_read_symbol
	mov.r.r r7 re
	ld.r.i rc 0
	cmp.r.f r7 rc
	jmp.c.j GLgl l205
	ld.r.ra ra l206+0
	push.r.sp ra sp
	st.r.p.off.w r7 sp 2
	call.j.sp sp _parse_error
	alu.r.i add sp 2
	ld.r.p.w r7 sp
l205:
	push.r.sp r7 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_set_cmd
	alu.r.i add sp 4
l202:
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l252
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l252
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 6
	cmp.r.f ra rc
	jmp.c.j GLgl l209
l252:
	ld.r.p.b r1 sp
l207:
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l212
	ld.r.i r4 1
	jmp.c.j LGlge l213
l212:
	ld.r.i r4 0
l213:
	push.r.sp r4 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
	call.j.sp sp _io_char
	mov.r.r r3 re
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isopenbracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l216
	call.j.sp sp _io_back
	call.j.sp sp _branch_new
	mov.r.r r0 re
	push.r.sp r0 sp
	call.j.sp sp _parse
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_add_child
	alu.r.i add sp 4
	jmp.c.j LGlge l232
l216:
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isclosebracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l218
	mov.r.r r0 r3
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l219
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l219
l218:
	st.r.p.b r1 sp
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l223
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r3
	cmp.r.f r1 r0
	jmp.c.j e l223
	ld.r.p.b r1 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l225+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 4
	st.r.p.b r1 sp
l223:
	ld.r.p.b r1 sp
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l255
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isclosebracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l255
	call.j.sp sp _io_back
	jmp.c.j LGlge l255
l219:
	call.j.sp sp _io_back
	ld.r.i ra 124
	push.r.sp ra sp
	call.j.sp sp _io_test_char
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l231
	ld.r.i ra 6
	st.r.p.w ra r2
	call.j.sp sp _branch_new
	mov.r.r r0 re
	push.r.sp r0 sp
	call.j.sp sp _parse
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_add_child
	alu.r.i add sp 4
	jmp.c.j LGlge l232
l231:
	call.j.sp sp _io_read_symbol
	mov.r.r r0 re
	st.r.p.w r0 sp
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l234
	ld.r.ra ra l235+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 2
	st.r.p.w r0 sp
l234:
	call.j.sp sp _branch_new
	mov.r.r r0 re
	ld.r.i ra 5
	st.r.p.w ra r0
	ld.r.p.w ra sp
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _branch_set_cmd
	alu.r.i add sp 4
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_add_child
	alu.r.i add sp 4
l232:
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l207
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l207
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 6
	cmp.r.f ra rc
	jmp.c.j e l207
	st.r.p.b r1 sp
l209:
	ld.r.p.b r3 sp
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 4
	cmp.r.f ra rc
	jmp.c.j e l253
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 3
	cmp.r.f ra rc
	jmp.c.j GLgl l255
l253:
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l242
	ld.r.i r1 1
	jmp.c.j LGlge l243
l242:
	ld.r.i r1 0
l243:
	push.r.sp r1 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
	call.j.sp sp _io_char
	mov.r.r r3 re
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isclosebracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l246
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l255
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r3
	cmp.r.f r1 r0
	jmp.c.j e l255
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l250+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 4
	jmp.c.j LGlge l255
l246:
	call.j.sp sp _io_back
	call.j.sp sp _branch_new
	mov.r.r r0 re
	push.r.sp r0 sp
	call.j.sp sp _parse
	alu.r.i add sp 2
	push.r.sp r0 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_add_child
	alu.r.i add sp 4
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 4
	cmp.r.f ra rc
	jmp.c.j e l253
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 3
	cmp.r.f ra rc
	jmp.c.j e l253
l255:
	mov.r.r re r2
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l206:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	102
	.dc.bs	117
	.dc.bs	110
	.dc.bs	99
	.dc.bs	116
	.dc.bs	105
	.dc.bs	111
	.dc.bs	110
	.dc.bs	32
	.dc.bs	110
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	0

	.rodata
l225:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	39
	.dc.bs	37
	.dc.bs	99
	.dc.bs	39
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	99
	.dc.bs	108
	.dc.bs	111
	.dc.bs	115
	.dc.bs	101
	.dc.bs	0

	.rodata
l235:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	0

	.rodata
l250:
	.dc.bs	101
	.dc.bs	120
	.dc.bs	112
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	39
	.dc.bs	37
	.dc.bs	99
	.dc.bs	39
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	99
	.dc.bs	108
	.dc.bs	111
	.dc.bs	115
	.dc.bs	101
	.dc.bs	0
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	ld.r.ra ra l258+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.p.off.w ra sp 4
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l260
	ld.r.ra ra l261+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 4
	ld.r.i ra 1
	call.j.sp sp _exit
l260:
	ld.r.ra ra l262+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.p.off.w r0 sp 6
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.ra ra l263+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.ra ra l264+0
	push.r.sp ra sp
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	st.r.m.w re _fin+0
	ld.r.ra ra l265+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.ra ra l268+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	call.j.sp sp _branch_new
	mov.r.r r0 re
	ld.r.ra ra l269+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	push.r.sp r0 sp
	call.j.sp sp _parse
	alu.r.i add sp 2
	ld.r.ra ra l270+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.i ra 0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _print_branch
	alu.r.i add sp 4
	ld.r.ra ra l271+0
	ld.r.i rb 0
	ld.r.i rc 0
	ld.r.i rd 0
	call.j.sp sp _test_syscall
	ld.r.i re 0
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l261:
	.dc.bs	117
	.dc.bs	115
	.dc.bs	97
	.dc.bs	103
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	115
	.dc.bs	104
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	10
	.dc.bs	0

	.rodata
l258:
	.dc.bs	98
	.dc.bs	49
	.dc.bs	0

	.rodata
l262:
	.dc.bs	98
	.dc.bs	50
	.dc.bs	0

	.rodata
l263:
	.dc.bs	98
	.dc.bs	51
	.dc.bs	0

	.rodata
l264:
	.dc.bs	114
	.dc.bs	0

	.rodata
l265:
	.dc.bs	98
	.dc.bs	52
	.dc.bs	0

	.rodata
l268:
	.dc.bs	98
	.dc.bs	53
	.dc.bs	0

	.rodata
l269:
	.dc.bs	98
	.dc.bs	54
	.dc.bs	0

	.rodata
l270:
	.dc.bs	98
	.dc.bs	55
	.dc.bs	0

	.rodata
l271:
	.dc.bs	98
	.dc.bs	56
	.dc.bs	0

	.data
_io_line:
	.global	_io_line
	.align
	.dc.w	1

	.bss
	.extern	_test_syscall

	.bss
	.extern	_exit

	.bss
	.extern	_fgetc

	.bss
	.extern	_fputc

	.bss
	.extern	_fopen

	.bss
	.extern	_fseek

	.bss
	.extern	_fputs

	.bss
	.extern	_stderr

	.bss
	.extern	_printf

	.bss
	.extern	_fprintf

	.bss
	.extern	_vfprintf

	.bss
	.extern	_realloc

	.bss
	.extern	_free

	.bss
	.extern	_malloc

	.bss
	.extern	_memset

	.bss
	.extern	_strlen

	.bss
	.extern	_strcpy

	.bss
	.extern	_isspace

	.bss
	.extern	_isalnum

	.bss
_fin:
	.global	_fin
	.align
	.ds	2
;	End of VBCC generated section
	.module

