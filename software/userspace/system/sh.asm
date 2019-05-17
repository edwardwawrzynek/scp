	.text
	.align
_branch_new:
	.global	_branch_new
	push.r.sp r0 sp
	ld.r.ra ra l3+0
	call.j.sp sp _test_syscall
	ld.r.i ra 8
	push.r.sp ra sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.ra ra l4+0
	call.j.sp sp _test_syscall
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l6
	ld.r.i re 0
	jmp.c.j LGlge l1
l6:
	ld.r.ra ra l7+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	ld.r.i ra 8
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _memset
	alu.r.i add sp 6
	ld.r.ra ra l8+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	mov.r.r re r0
l1:
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l3:
	.dc.bs	115
	.dc.bs	116
	.dc.bs	97
	.dc.bs	114
	.dc.bs	116
	.dc.bs	32
	.dc.bs	98
	.dc.bs	114
	.dc.bs	97
	.dc.bs	110
	.dc.bs	99
	.dc.bs	104
	.dc.bs	10
	.dc.bs	0

	.rodata
l4:
	.dc.bs	109
	.dc.bs	97
	.dc.bs	108
	.dc.bs	108
	.dc.bs	111
	.dc.bs	99
	.dc.bs	39
	.dc.bs	100
	.dc.bs	0

	.rodata
l7:
	.dc.bs	109
	.dc.bs	101
	.dc.bs	115
	.dc.bs	101
	.dc.bs	116
	.dc.bs	116
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	10
	.dc.bs	0

	.rodata
l8:
	.dc.bs	109
	.dc.bs	101
	.dc.bs	109
	.dc.bs	115
	.dc.bs	101
	.dc.bs	116
	.dc.bs	0
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
	jmp.c.j GLgl l12
	push.r.sp r4 sp
	call.j.sp sp _malloc
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r2
	alu.r.i add r0 2
	st.r.p.w r1 r0
	jmp.c.j LGlge l13
l12:
	push.r.sp r4 sp
	mov.r.r r0 r2
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.p.w re r0
l13:
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
	jmp.c.j e l21
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _free
	alu.r.i add sp 2
l21:
	ld.r.i r2 0
	mov.r.r r0 r3
	alu.r.i add r0 4
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j le l27
l26:
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
	jmp.c.j l l26
l27:
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
	jmp.c.j Le l32
	ld.r.p.off.w r1 sp 12
l30:
	ld.r.ra ra l34+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	alu.r.i add r0 1
	cmp.r.f r0 r1
	jmp.c.j L l30
	st.r.p.off.w r1 sp 12
l32:
	mov.r.r ra r3
	ld.r.p.w ra ra
	ld.r.i rc 5
	cmp.r.f ra rc
	jmp.c.j GLgl l36
	mov.r.r r0 r3
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l37+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	jmp.c.j LGlge l47
l36:
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
	ld.r.ra ra l39+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 8
	ld.r.i r2 0
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j le l47
l45:
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
	jmp.c.j l l45
l47:
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l34:
	.dc.bs	32
	.dc.bs	32
	.dc.bs	0

	.rodata
l37:
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
l39:
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
l77:
	call.j.sp sp _io_raw_char
	mov.r.r r4 re
	mov.r.r r0 r4
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l60
	ld.r.i re -1
	jmp.c.j LGlge l52
l60:
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l62
	ld.r.m.w ra _io_line+0
	alu.r.i add ra 1
	st.r.m.w ra _io_line+0
l62:
	ld.r.m.b ra l54+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l64
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l64
	ld.r.i ra 0
	st.r.m.b ra l54+0
	jmp.c.j LGlge l73
l64:
	ld.r.m.b ra l54+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l67
	mov.r.r r0 r4
	ld.r.i rc 35
	cmp.r.f r0 rc
	jmp.c.j GLgl l67
	ld.r.i ra 1
	st.r.m.b ra l54+0
l67:
	ld.r.m.b ra l54+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l70
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j GLgl l70
	ld.r.i ra 1
	st.r.m.b ra l55+0
	ld.r.i ra 0
	st.r.m.b ra l54+0
l70:
	ld.r.m.b ra l55+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l73
	ld.r.m.b r0 l54+0
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j GLgl l73
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j GLgl l73
	ld.r.i ra 0
	st.r.m.b ra l54+0
	ld.r.i ra 0
	st.r.m.b ra l55+0
l73:
	ld.r.m.b ra l54+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l77
	ld.r.m.b ra l55+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l77
	mov.r.r re r4
l52:
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
l54:
	.dc.bs	0

	.data
l55:
	.dc.bs	0
	.text
	.align
_io_skip_whitespace:
	.global	_io_skip_whitespace
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.b r2 sp 8
l81:
	call.j.sp sp _io_char
	mov.r.r r1 re
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _isspace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l87
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j GLgl l81
	mov.r.r r0 r1
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l81
l87:
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
	ld.r.m.w ra l91+0
	ld.r.i rc 256
	cmp.r.f ra rc
	jmp.c.j le l116
	ld.r.i ra 32
	push.r.sp ra sp
	ld.r.m.w ra l90+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re l90+0
	ld.r.i ra 32
	st.r.m.w ra l91+0
l116:
	call.j.sp sp _io_char
	mov.r.r r1 re
	mov.r.r r0 r1
	push.r.sp r0 sp
	call.j.sp sp _isalnum
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l98
	mov.r.r r0 r1
	ld.r.i rc 95
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 34
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 39
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 43
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 45
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 42
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 47
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 37
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 61
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 33
	cmp.r.f r0 rc
	jmp.c.j e l98
	mov.r.r r0 r1
	ld.r.i rc 46
	cmp.r.f r0 rc
	jmp.c.j e l98
	ld.r.i r1 0
l98:
	mov.r.r r0 r2
	alu.r.i add r0 1
	ld.r.m.w rc l91+0
	cmp.r.f r0 rc
	jmp.c.j le l113
	ld.r.m.w r0 l91+0
	alu.r.i add r0 32
	push.r.sp r0 sp
	ld.r.m.w ra l90+0
	push.r.sp ra sp
	call.j.sp sp _realloc
	alu.r.i add sp 4
	st.r.m.w re l90+0
	ld.r.m.w ra l91+0
	alu.r.i add ra 32
	st.r.m.w ra l91+0
l113:
	mov.r.r r0 r2
	alu.r.i add r2 1
	mov.r.r rc r0
	ld.r.m.w r0 l90+0
	alu.r.r add r0 rc
	st.r.p.bs r1 r0
	mov.r.r r0 r1
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l116
	ld.r.i rc 1
	cmp.r.f r2 rc
	jmp.c.j g l115
	ld.r.i re 0
	jmp.c.j LGlge l88
l115:
	call.j.sp sp _io_back
	ld.r.m.w re l90+0
l88:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.data
l90:
	.align
	.dc.w	0

	.data
l91:
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
	jmp.c.j GLgl l121
	ld.r.i re 1
	jmp.c.j LGlge l118
l121:
	call.j.sp sp _io_back
	ld.r.i re 0
l118:
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
	ld.r.ra ra l124+0
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
	jmp.c.j e l141
l138:
	call.j.sp sp _io_back
	call.j.sp sp _io_back
	alu.r.i add r1 1
	call.j.sp sp _io_char
	mov.r.r r0 re
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l138
l141:
	call.j.sp sp _io_char
	mov.r.r r4 re
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j e l142
l139:
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
	jmp.c.j GLgl l139
l142:
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
	jmp.c.j Le l143
l140:
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
	jmp.c.j L l140
l143:
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.ra ra l135+0
	push.r.sp ra sp
	call.j.sp sp _fputs
	alu.r.i add sp 4
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	ld.r.ra ra l136+0
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
	ld.r.ra ra l137+0
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
l124:
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
l135:
	.dc.bs	94
	.dc.bs	10
	.dc.bs	0

	.rodata
l136:
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
l137:
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
	jmp.c.j e l148
	mov.r.r r0 r4
	ld.r.i rc 41
	cmp.r.f r0 rc
	jmp.c.j e l148
	mov.r.r r0 r4
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l148
	mov.r.r r0 r4
	ld.r.i rc 125
	cmp.r.f r0 rc
	jmp.c.j e l148
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l148
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j e l148
	ld.r.i r5 0
	jmp.c.j LGlge l149
l148:
	ld.r.i r5 1
l149:
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
	jmp.c.j e l158
	mov.r.r r0 r5
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l158
	mov.r.r r0 r5
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l158
	ld.r.i r4 0
	jmp.c.j LGlge l159
l158:
	ld.r.i r4 1
l159:
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
	jmp.c.j e l165
	ld.r.p.off.bs r0 sp 4
	push.r.sp r0 sp
	call.j.sp sp _isopenbracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l165
	ld.r.i r4 1
	jmp.c.j LGlge l166
l165:
	ld.r.i r4 0
l166:
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
	jmp.c.j e l169
	mov.r.r r0 r4
	ld.r.i rc 41
	cmp.r.f r0 rc
	jmp.c.j GLgl l170
l169:
	ld.r.i re 1
	jmp.c.j LGlge l167
l170:
	mov.r.r r0 r4
	ld.r.i rc 123
	cmp.r.f r0 rc
	jmp.c.j e l172
	mov.r.r r0 r4
	ld.r.i rc 125
	cmp.r.f r0 rc
	jmp.c.j GLgl l173
l172:
	ld.r.i re 4
	jmp.c.j LGlge l167
l173:
	mov.r.r r0 r4
	ld.r.i rc 60
	cmp.r.f r0 rc
	jmp.c.j e l175
	mov.r.r r0 r4
	ld.r.i rc 62
	cmp.r.f r0 rc
	jmp.c.j GLgl l176
l175:
	ld.r.i re 3
	jmp.c.j LGlge l167
l176:
	ld.r.i re 0
l167:
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
	jmp.c.j e l180
	ld.r.i rc 2
	cmp.r.f r4 rc
	jmp.c.j e l180
	ld.r.i rc 6
	cmp.r.f r4 rc
	jmp.c.j GLgl l181
l180:
	ld.r.i re 41
	jmp.c.j LGlge l187
l181:
	ld.r.i rc 4
	cmp.r.f r4 rc
	jmp.c.j GLgl l185
	ld.r.i re 125
	jmp.c.j LGlge l187
l185:
	ld.r.i rc 3
	cmp.r.f r4 rc
	jmp.c.j GLgl l187
	ld.r.i re 62
l187:
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
	jmp.c.j e l194
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
	jmp.c.j LGlge l198
l194:
	ld.r.i r3 1
	ld.r.i ra 1
	st.r.p.w ra r2
	call.j.sp sp _io_back
l198:
	ld.r.i ra 94
	push.r.sp ra sp
	call.j.sp sp _io_test_char
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l200
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j GLgl l200
	ld.r.i ra 2
	st.r.p.w ra r2
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j GLgl l202
	ld.r.i r6 1
	jmp.c.j LGlge l203
l202:
	ld.r.i r6 0
l203:
	push.r.sp r6 sp
	call.j.sp sp _io_skip_whitespace
	alu.r.i add sp 2
l200:
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l205
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j GLgl l206
l205:
	call.j.sp sp _io_read_symbol
	mov.r.r r7 re
	ld.r.i rc 0
	cmp.r.f r7 rc
	jmp.c.j GLgl l209
	ld.r.ra ra l210+0
	push.r.sp ra sp
	st.r.p.off.w r7 sp 2
	call.j.sp sp _parse_error
	alu.r.i add sp 2
	ld.r.p.w r7 sp
l209:
	push.r.sp r7 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_set_cmd
	alu.r.i add sp 4
l206:
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l256
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l256
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 6
	cmp.r.f ra rc
	jmp.c.j GLgl l213
l256:
	ld.r.p.b r1 sp
l211:
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l216
	ld.r.i r4 1
	jmp.c.j LGlge l217
l216:
	ld.r.i r4 0
l217:
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
	jmp.c.j e l220
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
	jmp.c.j LGlge l236
l220:
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isclosebracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l222
	mov.r.r r0 r3
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j GLgl l223
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l223
l222:
	st.r.p.b r1 sp
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j GLgl l227
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r3
	cmp.r.f r1 r0
	jmp.c.j e l227
	ld.r.p.b r1 sp
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l229+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 4
	st.r.p.b r1 sp
l227:
	ld.r.p.b r1 sp
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l259
	mov.r.r r0 r3
	push.r.sp r0 sp
	call.j.sp sp _isclosebracket
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l259
	call.j.sp sp _io_back
	jmp.c.j LGlge l259
l223:
	call.j.sp sp _io_back
	ld.r.i ra 124
	push.r.sp ra sp
	call.j.sp sp _io_test_char
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l235
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
	jmp.c.j LGlge l236
l235:
	call.j.sp sp _io_read_symbol
	mov.r.r r0 re
	st.r.p.w r0 sp
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l238
	ld.r.ra ra l239+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 2
	st.r.p.w r0 sp
l238:
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
l236:
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 1
	cmp.r.f ra rc
	jmp.c.j e l211
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l211
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 6
	cmp.r.f ra rc
	jmp.c.j e l211
	st.r.p.b r1 sp
l213:
	ld.r.p.b r3 sp
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 4
	cmp.r.f ra rc
	jmp.c.j e l257
	st.r.p.b r3 sp
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 3
	cmp.r.f ra rc
	jmp.c.j GLgl l259
l257:
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l246
	ld.r.i r1 1
	jmp.c.j LGlge l247
l246:
	ld.r.i r1 0
l247:
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
	jmp.c.j e l250
	ld.r.p.b ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l259
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r1 re
	mov.r.r r0 r3
	cmp.r.f r1 r0
	jmp.c.j e l259
	push.r.sp r2 sp
	call.j.sp sp _branch_get_closing_bracket
	alu.r.i add sp 2
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra l254+0
	push.r.sp ra sp
	call.j.sp sp _parse_error
	alu.r.i add sp 4
	jmp.c.j LGlge l259
l250:
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
	jmp.c.j e l257
	mov.r.r ra r2
	ld.r.p.w ra ra
	ld.r.i rc 3
	cmp.r.f ra rc
	jmp.c.j e l257
l259:
	mov.r.r re r2
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l210:
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
l229:
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
l239:
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
l254:
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
	ld.r.p.off.w ra sp 4
	ld.r.i rc 2
	cmp.r.f ra rc
	jmp.c.j e l263
	ld.r.ra ra l264+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 4
	ld.r.i ra 1
	call.j.sp sp _exit
l263:
	ld.r.ra ra l265+0
	call.j.sp sp _test_syscall
	ld.r.ra ra l266+0
	push.r.sp ra sp
	ld.r.p.off.w r0 sp 8
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	st.r.m.w re _fin+0
	ld.r.m.w ra _fin+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l268
	ld.r.p.off.w r0 sp 6
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l269+0
	push.r.sp ra sp
	ld.r.m.w ra _stderr+0
	push.r.sp ra sp
	call.j.sp sp _fprintf
	alu.r.i add sp 6
l268:
	ld.r.ra ra l270+0
	call.j.sp sp _test_syscall
	call.j.sp sp _branch_new
	mov.r.r r0 re
	ld.r.ra ra l271+0
	call.j.sp sp _test_syscall
	push.r.sp r0 sp
	call.j.sp sp _parse
	alu.r.i add sp 2
	ld.r.ra ra l272+0
	call.j.sp sp _test_syscall
	ld.r.i ra 0
	push.r.sp ra sp
	push.r.sp r0 sp
	call.j.sp sp _print_branch
	alu.r.i add sp 4
	ld.r.ra ra l273+0
	call.j.sp sp _test_syscall
	ld.r.i re 0
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
l264:
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
l269:
	.dc.bs	99
	.dc.bs	111
	.dc.bs	117
	.dc.bs	108
	.dc.bs	100
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
l265:
	.dc.bs	97
	.dc.bs	0

	.rodata
l266:
	.dc.bs	114
	.dc.bs	0

	.rodata
l270:
	.dc.bs	98
	.dc.bs	0

	.rodata
l271:
	.dc.bs	99
	.dc.bs	0

	.rodata
l272:
	.dc.bs	100
	.dc.bs	0

	.rodata
l273:
	.dc.bs	101
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

