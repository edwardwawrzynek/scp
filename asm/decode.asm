	.text
	.align
_is_whitespace:
	.global	_is_whitespace
	push.r.sp r0 sp
	ld.r.p.off.bs r4 sp 4
	mov.r.r r0 r4
	ld.r.i rc 32
	cmp.r.f r0 rc
	jmp.c.j e l5
l7:
	mov.r.r r0 r4
	ld.r.i rc 9
	cmp.r.f r0 rc
	jmp.c.j e l5
l3:
	mov.r.r r0 r4
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j e l5
l4:
	ld.r.i r0 0
	jmp.c.j LGlge l6
l5:
	ld.r.i r0 1
l6:
	mov.r.r re r0
l1:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_blanks:
	.global	_blanks
	push.r.sp r0 sp
	jmp.c.j LGlge l11
l10:
	ld.r.m.w ra _lptr+0
	alu.r.i add ra 1
	st.r.m.w ra _lptr+0
l11:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _is_whitespace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l12
l13:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l10
l12:
l8:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_read_line:
	.global	_read_line
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.i r3 0
	ld.r.i ra 0
	st.r.m.w ra _lptr+0
l16:
	call.j.sp sp _read_byte
	mov.r.r r0 re
	mov.r.r r2 r0
	mov.r.r r0 r2
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l20
l19:
	ld.r.i r3 1
l20:
	mov.r.r r0 r2
	ld.r.i rc 10
	cmp.r.f r0 rc
	jmp.c.j e l21
l23:
	mov.r.r r0 r2
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j GLgl l22
l21:
	ld.r.i r2 0
l22:
	ld.r.m.w r0 _lptr+0
	ld.r.m.w ra _lptr+0
	alu.r.i add ra 1
	st.r.m.w ra _lptr+0
	ld.r.ra r1 _line+0
	alu.r.r add r1 r0
	st.r.p.bs r2 r1
l18:
	mov.r.r r0 r2
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l16
l17:
	ld.r.i ra 0
	st.r.m.w ra _lptr+0
	mov.r.r r0 r3
	mov.r.r re r0
l14:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_read_good_line:
	.global	_read_good_line
	push.r.sp r0 sp
l26:
	call.j.sp sp _read_line
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l30
	call.j.sp sp _blanks
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l32
l31:
	ld.r.i re 1
	jmp.c.j LGlge l24
l32:
l30:
	call.j.sp sp _blanks
l28:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 59
	cmp.r.f r0 rc
	jmp.c.j e l26
l33:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l26
l27:
	ld.r.i re 0
l24:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_get_instr_entry:
	.global	_get_instr_entry
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	push.r.sp r3 sp
	ld.r.ra ra l36+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.m.w ra _instructions+0
	push.r.sp ra sp
	ld.r.ra ra _instructions+0
	push.r.sp ra sp
	ld.r.ra ra l37+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.i r2 0
	jmp.c.j LGlge l39
l38:
	mov.r.r r0 r2
	alu.r.i mul r0 28
	ld.r.ra r1 _instructions+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l42+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	push.r.sp r3 sp
	mov.r.r r0 r2
	alu.r.i mul r0 28
	ld.r.ra r1 _instructions+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l44
l43:
	mov.r.r r0 r2
	alu.r.i mul r0 28
	ld.r.ra r1 _instructions+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l34
l44:
l41:
	alu.r.i add r2 1
l39:
	mov.r.r r0 r2
	alu.r.i mul r0 28
	ld.r.ra r1 _instructions+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l38
l40:
	ld.r.ra ra l45+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
	ld.r.i re 0
l34:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l42:
	.dc.bs	116
	.dc.bs	101
	.dc.bs	115
	.dc.bs	116
	.dc.bs	32
	.dc.bs	110
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l36:
	.dc.bs	110
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l37:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	115
	.dc.bs	116
	.dc.bs	114
	.dc.bs	117
	.dc.bs	99
	.dc.bs	116
	.dc.bs	105
	.dc.bs	111
	.dc.bs	110
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	117
	.dc.bs	44
	.dc.bs	32
	.dc.bs	110
	.dc.bs	97
	.dc.bs	109
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l45:
	.dc.bs	78
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	99
	.dc.bs	111
	.dc.bs	109
	.dc.bs	109
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	0
	.text
	.align
_get_dir_type:
	.global	_get_dir_type
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	ld.r.i r2 0
	jmp.c.j LGlge l49
l48:
	push.r.sp r3 sp
	mov.r.r r0 r2
	alu.r.i mul r0 2
	ld.r.ra r1 _dir_names+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l53
l52:
	mov.r.r re r2
	jmp.c.j LGlge l46
l53:
l51:
	alu.r.i add r2 1
l49:
	mov.r.r r0 r2
	alu.r.i mul r0 2
	ld.r.ra r1 _dir_names+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l48
l50:
	ld.r.ra ra l54+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
	ld.r.i re 0
l46:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l54:
	.dc.bs	78
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	100
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	105
	.dc.bs	118
	.dc.bs	101
	.dc.bs	0
	.text
	.align
_hex2int:
	.global	_hex2int
	push.r.sp r0 sp
	ld.r.p.off.bs r4 sp 4
	mov.r.r r0 r4
	ld.r.i rc 48
	cmp.r.f r0 rc
	jmp.c.j L l58
l59:
	mov.r.r r0 r4
	ld.r.i rc 57
	cmp.r.f r0 rc
	jmp.c.j G l58
l57:
	mov.r.r r0 r4
	alu.r.i sub r0 48
	mov.r.r re r0
	jmp.c.j LGlge l55
l58:
	mov.r.r r0 r4
	ld.r.i rc 65
	cmp.r.f r0 rc
	jmp.c.j L l61
l62:
	mov.r.r r0 r4
	ld.r.i rc 70
	cmp.r.f r0 rc
	jmp.c.j G l61
l60:
	mov.r.r r0 r4
	alu.r.i sub r0 65
	alu.r.i add r0 10
	mov.r.r re r0
	jmp.c.j LGlge l55
l61:
	mov.r.r r0 r4
	ld.r.i rc 97
	cmp.r.f r0 rc
	jmp.c.j L l64
l65:
	mov.r.r r0 r4
	ld.r.i rc 102
	cmp.r.f r0 rc
	jmp.c.j G l64
l63:
	mov.r.r r0 r4
	alu.r.i sub r0 97
	alu.r.i add r0 10
	mov.r.r re r0
	jmp.c.j LGlge l55
l64:
	ld.r.i re -1
l55:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_read_in_arg:
	.global	_read_in_arg
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	jmp.c.j LGlge l69
l68:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	mov.r.r r1 r2
	alu.r.i add r2 1
	mov.r.r ra r0
	ld.r.p.bs ra ra
	st.r.p.bs ra r1
	ld.r.m.w ra _lptr+0
	alu.r.i add ra 1
	st.r.m.w ra _lptr+0
l69:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _is_whitespace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l70
l71:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l68
l70:
l66:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_line_into_instr:
	.global	_line_into_instr
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 8
	ld.r.i ra 852
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 22
	push.r.sp ra sp
	call.j.sp sp _memset
	alu.r.i add sp 6
	mov.r.r r0 re
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 64
	ld.r.i ra -1
	st.r.p.w ra r0
	ld.r.i ra 0
	st.r.m.w ra _lptr+0
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _is_whitespace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l75
l74:
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 68
	ld.r.i ra 1
	st.r.p.b ra r0
	jmp.c.j LGlge l77
l76:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _is_whitespace
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l79
l81:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l80
l79:
	ld.r.ra ra l82+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l80:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.m.w rc _lptr+0
	ld.r.p.off.w r1 sp 18
	alu.r.r add r1 rc
	mov.r.r ra r0
	ld.r.p.bs ra ra
	st.r.p.bs ra r1
	ld.r.m.w ra _lptr+0
	alu.r.i add ra 1
	st.r.m.w ra _lptr+0
l77:
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 58
	cmp.r.f r0 rc
	jmp.c.j GLgl l76
l78:
	ld.r.m.w rc _lptr+0
	ld.r.p.off.w r0 sp 18
	alu.r.r add r0 rc
	ld.r.i ra 0
	st.r.p.bs ra r0
	jmp.c.j LGlge l83
l75:
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 68
	ld.r.i ra 0
	st.r.p.b ra r0
	call.j.sp sp _blanks
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	call.j.sp sp _read_in_arg
	alu.r.i add sp 2
	ld.r.p.off.w r0 sp 18
	ld.r.p.bs r0 r0
	ld.r.i rc 46
	cmp.r.f r0 rc
	jmp.c.j GLgl l85
l84:
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 69
	ld.r.i ra 1
	st.r.p.b ra r0
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	call.j.sp sp _get_dir_type
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 18
	alu.r.i add r1 70
	st.r.p.w r0 r1
	jmp.c.j LGlge l86
l85:
	ld.r.p.off.w ra sp 18
	push.r.sp ra sp
	call.j.sp sp _get_instr_entry
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 18
	alu.r.i add r1 66
	st.r.p.w r0 r1
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 66
	ld.r.p.w r0 r0
	alu.r.i add r0 2
	ld.r.p.off.w r1 sp 18
	alu.r.i add r1 64
	mov.r.r ra r0
	ld.r.p.b ra ra
	st.r.p.w ra r1
l86:
	ld.r.i ra 0
	st.r.p.w ra sp
	jmp.c.j LGlge l88
l87:
	ld.r.p.off.w r0 sp 18
	alu.r.i add r0 72
	ld.r.p.w r1 sp
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	mov.r.r r3 r0
	ld.r.i ra 1
	st.r.p.b ra r3
	mov.r.r r0 r3
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _read_in_arg
	alu.r.i add sp 2
	mov.r.r r0 r3
	alu.r.i add r0 76
	ld.r.i ra 0
	st.r.p.w ra r0
	ld.r.i ra 0
	st.r.p.off.w ra sp 4
	jmp.c.j LGlge l91
l90:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.off.w rc sp 4
	alu.r.r add r0 rc
	ld.r.p.bs r0 r0
	ld.r.i rc 43
	cmp.r.f r0 rc
	jmp.c.j GLgl l94
l93:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.off.w rc sp 4
	alu.r.r add r0 rc
	ld.r.i ra 0
	st.r.p.bs ra r0
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.off.w rc sp 4
	alu.r.r add r0 rc
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _atoi
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r3
	alu.r.i add r1 76
	st.r.p.w r0 r1
	jmp.c.j LGlge l92
l94:
	ld.r.p.off.w ra sp 4
	alu.r.i add ra 1
	st.r.p.off.w ra sp 4
l91:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.off.w rc sp 4
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l90
l92:
	mov.r.r r0 r3
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _atoi
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r3
	alu.r.i add r1 76
	mov.r.r rc r1
	ld.r.p.w rc rc
	alu.r.r add r0 rc
	mov.r.r r1 r3
	alu.r.i add r1 66
	st.r.p.w r0 r1
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _isdigit
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l95
l97:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	ld.r.i rc 45
	cmp.r.f r0 rc
	jmp.c.j GLgl l96
l95:
	mov.r.r r0 r3
	alu.r.i add r0 68
	ld.r.i ra 1
	st.r.p.b ra r0
	jmp.c.j LGlge l98
l96:
	mov.r.r r0 r3
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _find_def
	alu.r.i add sp 2
	st.r.p.off.w re sp 6
	ld.r.p.off.w ra sp 6
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l100
l99:
	mov.r.r r0 r3
	alu.r.i add r0 68
	ld.r.i ra 1
	st.r.p.b ra r0
	ld.r.p.off.w r0 sp 6
	alu.r.i add r0 64
	mov.r.r r1 r3
	alu.r.i add r1 66
	mov.r.r ra r0
	ld.r.p.w ra ra
	st.r.p.w ra r1
l100:
l98:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	ld.r.i rc 114
	cmp.r.f r0 rc
	jmp.c.j GLgl l102
l103:
	mov.r.r r0 r3
	alu.r.i add r0 1
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l102
l101:
	mov.r.r r0 r3
	alu.r.i add r0 69
	ld.r.i ra 1
	st.r.p.b ra r0
	mov.r.r r0 r3
	alu.r.i add r0 1
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _hex2int
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r3
	alu.r.i add r1 70
	st.r.p.b r0 r1
	jmp.c.j LGlge l104
l102:
	mov.r.r r0 r3
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	ld.r.i rc 115
	cmp.r.f r0 rc
	jmp.c.j GLgl l106
l108:
	mov.r.r r0 r3
	alu.r.i add r0 1
	alu.r.i add r0 1
	ld.r.p.bs r0 r0
	ld.r.i rc 112
	cmp.r.f r0 rc
	jmp.c.j GLgl l106
l107:
	mov.r.r r0 r3
	alu.r.i add r0 1
	alu.r.i add r0 2
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l106
l105:
	mov.r.r r0 r3
	alu.r.i add r0 69
	ld.r.i ra 1
	st.r.p.b ra r0
	mov.r.r r0 r3
	alu.r.i add r0 70
	ld.r.i ra 15
	st.r.p.b ra r0
l106:
l104:
	ld.r.i ra 0
	st.r.p.off.b ra sp 6
	jmp.c.j LGlge l110
l109:
	mov.r.r r0 r3
	alu.r.i add r0 1
	push.r.sp r0 sp
	ld.r.p.off.b r0 sp 8
	alu.r.i mul r0 2
	ld.r.ra r1 _alu_ops+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strcmp
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j GLgl l114
l113:
	mov.r.r r0 r3
	alu.r.i add r0 71
	ld.r.i ra 1
	st.r.p.b ra r0
	mov.r.r r0 r3
	alu.r.i add r0 72
	ld.r.p.off.b ra sp 6
	st.r.p.b ra r0
	jmp.c.j LGlge l111
l114:
l112:
	ld.r.p.off.b ra sp 6
	alu.r.i add ra 1
	st.r.p.off.b ra sp 6
l110:
	ld.r.p.off.b r0 sp 6
	alu.r.i mul r0 2
	ld.r.ra r1 _alu_ops+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l109
l111:
	mov.r.r r0 r3
	alu.r.i add r0 73
	ld.r.i ra 1
	st.r.p.b ra r0
	mov.r.r ra r3
	alu.r.i add ra 1
	st.r.p.off.w ra sp 6
	jmp.c.j LGlge l116
l115:
	ld.r.p.off.w r0 sp 6
	ld.r.p.bs r0 r0
	ld.r.i rc 71
	cmp.r.f r0 rc
	jmp.c.j e l124
	ld.r.i rc 76
	cmp.r.f r0 rc
	jmp.c.j e l123
	ld.r.i rc 95
	cmp.r.f r0 rc
	jmp.c.j e l125
	ld.r.i rc 101
	cmp.r.f r0 rc
	jmp.c.j e l120
	ld.r.i rc 103
	cmp.r.f r0 rc
	jmp.c.j e l122
	ld.r.i rc 108
	cmp.r.f r0 rc
	jmp.c.j e l121
	jmp.c.j LGlge l126
l120:
	mov.r.r r0 r3
	alu.r.i add r0 74
	mov.r.r r1 r0
	ld.r.p.b r1 r1
	mov.r.r r2 r1
	alu.r.i bor r2 1
	st.r.p.b r2 r0
	jmp.c.j LGlge l119
l121:
	mov.r.r r0 r3
	alu.r.i add r0 74
	mov.r.r r1 r0
	ld.r.p.b r1 r1
	mov.r.r r2 r1
	alu.r.i bor r2 2
	st.r.p.b r2 r0
	jmp.c.j LGlge l119
l122:
	mov.r.r r0 r3
	alu.r.i add r0 74
	mov.r.r r1 r0
	ld.r.p.b r1 r1
	mov.r.r r2 r1
	alu.r.i bor r2 4
	st.r.p.b r2 r0
	jmp.c.j LGlge l119
l123:
	mov.r.r r0 r3
	alu.r.i add r0 74
	mov.r.r r1 r0
	ld.r.p.b r1 r1
	mov.r.r r2 r1
	alu.r.i bor r2 8
	st.r.p.b r2 r0
	jmp.c.j LGlge l119
l124:
	mov.r.r r0 r3
	alu.r.i add r0 74
	mov.r.r r1 r0
	ld.r.p.b r1 r1
	mov.r.r r2 r1
	alu.r.i bor r2 16
	st.r.p.b r2 r0
	jmp.c.j LGlge l119
l125:
	jmp.c.j LGlge l119
l126:
	mov.r.r r0 r3
	alu.r.i add r0 73
	ld.r.i ra 0
	st.r.p.b ra r0
	mov.r.r r0 r3
	alu.r.i add r0 74
	ld.r.i ra 0
	st.r.p.b ra r0
l119:
l118:
	ld.r.p.off.w ra sp 6
	alu.r.i add ra 1
	st.r.p.off.w ra sp 6
l116:
	ld.r.p.off.w ra sp 6
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l117
l127:
	mov.r.r r0 r3
	alu.r.i add r0 73
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l115
l117:
	ld.r.p.w ra sp
	alu.r.i add ra 1
	st.r.p.w ra sp
l88:
	call.j.sp sp _blanks
	ld.r.m.w rc _lptr+0
	ld.r.ra r0 _line+0
	alu.r.r add r0 rc
	mov.r.r ra r0
	ld.r.p.bs ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l87
l89:
l83:
l72:
	alu.r.i add sp 8
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l82:
	.dc.bs	58
	.dc.bs	32
	.dc.bs	110
	.dc.bs	101
	.dc.bs	101
	.dc.bs	100
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	97
	.dc.bs	102
	.dc.bs	116
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	108
	.dc.bs	97
	.dc.bs	98
	.dc.bs	101
	.dc.bs	108
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_check_instr:
	.global	_check_instr
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 14
	mov.r.r r0 r3
	alu.r.i add r0 66
	mov.r.r ra r0
	ld.r.p.w ra ra
	st.r.p.w ra sp
	mov.r.r r0 r3
	alu.r.i add r0 64
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j L l131
l132:
	ld.r.p.w ra sp
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l131
l130:
	ld.r.i r2 0
	jmp.c.j LGlge l134
l133:
	mov.r.r r0 r3
	alu.r.i add r0 72
	mov.r.r r1 r2
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l137
l136:
	ld.r.ra ra l138+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l137:
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	mov.r.r r1 r2
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r r1 r0
	ld.r.p.w r1 r1
	ld.r.i rc 1
	cmp.r.f r1 rc
	jmp.c.j e l140
	ld.r.i rc 2
	cmp.r.f r1 rc
	jmp.c.j e l144
	ld.r.i rc 3
	cmp.r.f r1 rc
	jmp.c.j e l148
	ld.r.i rc 4
	cmp.r.f r1 rc
	jmp.c.j e l149
	ld.r.i rc 5
	cmp.r.f r1 rc
	jmp.c.j e l150
	jmp.c.j LGlge l154
l140:
	mov.r.r r0 r3
	alu.r.i add r0 72
	mov.r.r r1 r2
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	alu.r.i add r0 69
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l142
l141:
	ld.r.ra ra l143+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l142:
	jmp.c.j LGlge l139
l144:
	mov.r.r r0 r3
	alu.r.i add r0 72
	mov.r.r r1 r2
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	alu.r.i add r0 71
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l146
l145:
	ld.r.ra ra l147+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l146:
	jmp.c.j LGlge l139
l148:
	jmp.c.j LGlge l139
l149:
	jmp.c.j LGlge l139
l150:
	mov.r.r r0 r3
	alu.r.i add r0 72
	mov.r.r r1 r2
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	alu.r.i add r0 73
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l152
l151:
	ld.r.ra ra l153+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l152:
	jmp.c.j LGlge l139
l154:
l139:
	alu.r.i add r2 1
l134:
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	mov.r.r r1 r2
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l133
l135:
	mov.r.r r0 r3
	alu.r.i add r0 72
	mov.r.r r1 r2
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l156
	ld.r.ra ra l157+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l156:
l131:
l128:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l138:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	99
	.dc.bs	111
	.dc.bs	114
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	32
	.dc.bs	110
	.dc.bs	117
	.dc.bs	109
	.dc.bs	98
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	111
	.dc.bs	102
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	115
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l143:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	99
	.dc.bs	111
	.dc.bs	114
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	116
	.dc.bs	121
	.dc.bs	112
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	103
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	113
	.dc.bs	117
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l147:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	99
	.dc.bs	111
	.dc.bs	114
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	116
	.dc.bs	121
	.dc.bs	112
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	97
	.dc.bs	108
	.dc.bs	117
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	113
	.dc.bs	117
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l153:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	99
	.dc.bs	111
	.dc.bs	114
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	116
	.dc.bs	121
	.dc.bs	112
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	99
	.dc.bs	111
	.dc.bs	110
	.dc.bs	100
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	113
	.dc.bs	117
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.rodata
	.align
l157:
	.dc.bs	105
	.dc.bs	110
	.dc.bs	99
	.dc.bs	111
	.dc.bs	114
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	32
	.dc.bs	110
	.dc.bs	117
	.dc.bs	109
	.dc.bs	98
	.dc.bs	101
	.dc.bs	114
	.dc.bs	32
	.dc.bs	111
	.dc.bs	102
	.dc.bs	32
	.dc.bs	97
	.dc.bs	114
	.dc.bs	103
	.dc.bs	115
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	101
	.dc.bs	100
	.dc.bs	0

	.bss
	.align
	.extern	_printf

	.bss
	.align
	.extern	_dir_names

	.bss
	.align
	.extern	_line

	.bss
	.align
	.extern	_lptr

	.bss
	.align
	.extern	_alu_ops

	.bss
	.align
	.extern	_instructions

	.bss
	.align
	.extern	_read_byte

	.bss
	.align
	.extern	_error

	.bss
	.align
	.extern	_find_def

	.bss
	.align
	.extern	_memset

	.bss
	.align
	.extern	_strcmp

	.bss
	.align
	.extern	_atoi

	.bss
	.align
	.extern	_isdigit
;	End of VBCC generated section
	.module

