	.text
	.align
_dir_first_pass:
	.global	_dir_first_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r2 sp 12
	mov.r.r r0 r2
	alu.r.i add r0 70
	mov.r.r r1 r0
	ld.r.p.w r1 r1
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l4
	ld.r.i rc 1
	cmp.r.f r1 rc
	jmp.c.j e l5
	ld.r.i rc 2
	cmp.r.f r1 rc
	jmp.c.j e l6
	ld.r.i rc 3
	cmp.r.f r1 rc
	jmp.c.j e l7
	ld.r.i rc 4
	cmp.r.f r1 rc
	jmp.c.j e l8
	ld.r.i rc 5
	cmp.r.f r1 rc
	jmp.c.j e l9
	ld.r.i rc 6
	cmp.r.f r1 rc
	jmp.c.j e l10
	ld.r.i rc 7
	cmp.r.f r1 rc
	jmp.c.j e l11
	ld.r.i rc 8
	cmp.r.f r1 rc
	jmp.c.j e l15
	ld.r.i rc 9
	cmp.r.f r1 rc
	jmp.c.j e l16
	ld.r.i rc 10
	cmp.r.f r1 rc
	jmp.c.j e l19
	ld.r.i rc 11
	cmp.r.f r1 rc
	jmp.c.j e l17
	ld.r.i rc 12
	cmp.r.f r1 rc
	jmp.c.j e l20
	ld.r.i rc 13
	cmp.r.f r1 rc
	jmp.c.j e l18
	ld.r.i rc 14
	cmp.r.f r1 rc
	jmp.c.j e l21
	jmp.c.j LGlge l22
l4:
l5:
	ld.r.i re 1
	jmp.c.j LGlge l1
l6:
	ld.r.i re 2
	jmp.c.j LGlge l1
l7:
	ld.r.i re 4
	jmp.c.j LGlge l1
l8:
	mov.r.r r0 r2
	alu.r.i add r0 72
	alu.r.i add r0 66
	mov.r.r re r0
	ld.r.p.w re re
	jmp.c.j LGlge l1
l9:
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	ld.r.p.w r1 r1
	alu.r.i band r1 1
	mov.r.r re r1
	jmp.c.j LGlge l1
l10:
	ld.r.m.w ra _cur_module+0
	alu.r.i add ra 1
	st.r.m.w ra _cur_module+0
	ld.r.i re 0
	jmp.c.j LGlge l1
l11:
	ld.r.i ra 1
	push.r.sp ra sp
	ld.r.m.w ra _cur_module+0
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 72
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _find_label
	alu.r.i add sp 6
	mov.r.r r3 re
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j GLgl l13
l12:
	ld.r.ra ra l14+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l13:
	mov.r.r r0 r3
	alu.r.i add r0 64
	ld.r.i ra -1
	st.r.p.w ra r0
	ld.r.i re 0
	jmp.c.j LGlge l1
l15:
	ld.r.i ra -1
	push.r.sp ra sp
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.i ra -1
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 72
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _add_label
	alu.r.i add sp 8
	mov.r.r r0 re
	ld.r.i re 0
	jmp.c.j LGlge l1
l16:
l17:
l18:
	ld.r.i ra 0
	st.r.m.b ra _cur_seg+0
	ld.r.i re 0
	jmp.c.j LGlge l1
l19:
l20:
	ld.r.i ra 1
	st.r.m.b ra _cur_seg+0
	ld.r.i re 0
	jmp.c.j LGlge l1
l21:
	mov.r.r r0 r2
	alu.r.i add r0 72
	alu.r.i add r0 78
	alu.r.i add r0 66
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r0 r2
	alu.r.i add r0 72
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _add_def
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.i re 0
	jmp.c.j LGlge l1
l22:
l3:
	ld.r.ra ra l23+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
	ld.r.i re 0
l1:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l14:
	.dc.bs	78
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	108
	.dc.bs	97
	.dc.bs	98
	.dc.bs	101
	.dc.bs	108
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l23:
	.dc.bs	68
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	105
	.dc.bs	118
	.dc.bs	101
	.dc.bs	32
	.dc.bs	110
	.dc.bs	111
	.dc.bs	116
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	108
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	114
	.dc.bs	115
	.dc.bs	116
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_cmd_first_pass:
	.global	_cmd_first_pass
	push.r.sp r0 sp
	ld.r.p.off.w r4 sp 4
	mov.r.r r0 r4
	alu.r.i add r0 66
	ld.r.p.w r0 r0
	alu.r.i add r0 26
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l27
l26:
	ld.r.i r0 4
	jmp.c.j LGlge l28
l27:
	ld.r.i r0 2
l28:
	mov.r.r re r0
l24:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_label_first_pass:
	.global	_label_first_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	ld.r.m.b r0 _cur_seg+0
	push.r.sp r0 sp
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.m.w ra _cur_module+0
	push.r.sp ra sp
	push.r.sp r2 sp
	call.j.sp sp _add_label
	alu.r.i add sp 8
	mov.r.r r0 re
	ld.r.i re 0
l29:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_first_pass:
	.global	_first_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	mov.r.r r0 r2
	alu.r.i add r0 68
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l34
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	push.r.sp r2 sp
	call.j.sp sp _label_first_pass
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r rc r1
	ld.r.p.w rc rc
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra r1
	jmp.c.j LGlge l35
l34:
	mov.r.r r0 r2
	alu.r.i add r0 69
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l37
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	push.r.sp r2 sp
	call.j.sp sp _dir_first_pass
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r rc r1
	ld.r.p.w rc rc
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra r1
	jmp.c.j LGlge l38
l37:
	mov.r.r r0 r2
	alu.r.i add r0 64
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j e l40
l39:
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	push.r.sp r2 sp
	call.j.sp sp _cmd_first_pass
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r rc r1
	ld.r.p.w rc rc
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra r1
	jmp.c.j LGlge l41
l40:
	ld.r.ra ra l42+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l41:
l38:
l35:
l31:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l42:
	.dc.bs	70
	.dc.bs	105
	.dc.bs	114
	.dc.bs	115
	.dc.bs	116
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	108
	.dc.bs	101
	.dc.bs	32
	.dc.bs	116
	.dc.bs	104
	.dc.bs	105
	.dc.bs	115
	.dc.bs	32
	.dc.bs	99
	.dc.bs	111
	.dc.bs	109
	.dc.bs	109
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_first_pass_align:
	.global	_first_pass_align
	push.r.sp r0 sp
	ld.r.m.w r0 _seg_pos+0
	alu.r.i band r0 1
	ld.r.m.w rc _seg_pos+0
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.m.w ra _seg_pos+0
	ld.r.m.w r0 _seg_pos+2
	alu.r.i band r0 1
	ld.r.m.w rc _seg_pos+2
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.m.w ra _seg_pos+2
	ld.r.m.w r0 _seg_pos+4
	alu.r.i band r0 1
	ld.r.m.w rc _seg_pos+4
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.m.w ra _seg_pos+4
	ld.r.m.w r0 _seg_pos+6
	alu.r.i band r0 1
	ld.r.m.w rc _seg_pos+6
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.m.w ra _seg_pos+6
l43:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_type_get_value:
	.global	_type_get_value
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 10
	ld.r.p.off.w r1 sp 8
	mov.r.r r0 r2
	ld.r.i rc 1
	cmp.r.f r0 rc
	jmp.c.j e l48
	ld.r.i rc 2
	cmp.r.f r0 rc
	jmp.c.j e l52
	ld.r.i rc 3
	cmp.r.f r0 rc
	jmp.c.j e l56
	ld.r.i rc 5
	cmp.r.f r0 rc
	jmp.c.j e l60
	jmp.c.j LGlge l64
l48:
	mov.r.r r0 r1
	alu.r.i add r0 69
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l50
l49:
	ld.r.ra ra l51+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l50:
	mov.r.r r0 r1
	alu.r.i add r0 70
	ld.r.p.b r0 r0
	mov.r.r re r0
	jmp.c.j LGlge l45
l52:
	mov.r.r r0 r1
	alu.r.i add r0 71
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l54
l53:
	ld.r.ra ra l55+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l54:
	mov.r.r r0 r1
	alu.r.i add r0 72
	ld.r.p.b r0 r0
	mov.r.r re r0
	jmp.c.j LGlge l45
l56:
	mov.r.r r0 r1
	alu.r.i add r0 68
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l58
l57:
	ld.r.ra ra l59+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l58:
	mov.r.r r0 r1
	alu.r.i add r0 66
	mov.r.r re r0
	ld.r.p.w re re
	jmp.c.j LGlge l45
l60:
	mov.r.r r0 r1
	alu.r.i add r0 73
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l62
l61:
	ld.r.ra ra l63+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l62:
	mov.r.r r0 r1
	alu.r.i add r0 74
	ld.r.p.b r0 r0
	mov.r.r re r0
	jmp.c.j LGlge l45
l64:
	ld.r.i re 0
l47:
l45:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l51:
	.dc.bs	65
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	115
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	98
	.dc.bs	101
	.dc.bs	32
	.dc.bs	114
	.dc.bs	101
	.dc.bs	103
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l55:
	.dc.bs	65
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	115
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	98
	.dc.bs	101
	.dc.bs	32
	.dc.bs	97
	.dc.bs	108
	.dc.bs	117
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l59:
	.dc.bs	65
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	115
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	98
	.dc.bs	101
	.dc.bs	32
	.dc.bs	97
	.dc.bs	32
	.dc.bs	118
	.dc.bs	97
	.dc.bs	108
	.dc.bs	117
	.dc.bs	101
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l63:
	.dc.bs	65
	.dc.bs	114
	.dc.bs	103
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	115
	.dc.bs	32
	.dc.bs	116
	.dc.bs	111
	.dc.bs	32
	.dc.bs	98
	.dc.bs	101
	.dc.bs	32
	.dc.bs	99
	.dc.bs	111
	.dc.bs	110
	.dc.bs	100
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_write_label_imd:
	.global	_write_label_imd
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 14
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.m.w ra _cur_module+0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 1
	push.r.sp r0 sp
	call.j.sp sp _find_label
	alu.r.i add sp 6
	mov.r.r r2 re
	ld.r.i rc 0
	cmp.r.f r2 rc
	jmp.c.j GLgl l68
l67:
	ld.r.ra ra l69+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l68:
	mov.r.r r0 r2
	alu.r.i add r0 66
	ld.r.p.bs r0 r0
	ld.r.i rc -1
	cmp.r.f r0 rc
	jmp.c.j e l71
l70:
	ld.r.p.off.b r0 sp 16
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i add r0 66
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i add r0 68
	mov.r.r r1 r3
	alu.r.i add r1 76
	mov.r.r rc r1
	ld.r.p.w rc rc
	ld.r.p.w r0 r0
	alu.r.r add r0 rc
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_offset
	alu.r.i add sp 8
	jmp.c.j LGlge l72
l71:
	mov.r.r r0 r3
	alu.r.i add r0 76
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l74
	ld.r.i ra 67
	push.r.sp ra sp
	ld.r.m.w ra _out+26
	push.r.sp ra sp
	call.j.sp sp ___crtudiv
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.b r1 sp 16
	alu.r.r add r0 r1
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_expand_extern
	alu.r.i add sp 4
	mov.r.r r0 r3
	alu.r.i add r0 76
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	push.r.sp r2 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_extern
	alu.r.i add sp 6
	st.r.p.off.w re sp 2
	ld.r.p.off.b r0 sp 16
	push.r.sp r0 sp
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_extern_offset
	alu.r.i add sp 6
	jmp.c.j LGlge l75
l74:
	ld.r.p.off.b r0 sp 16
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i add r0 70
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_extern_offset
	alu.r.i add sp 6
l75:
l72:
l65:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l69:
	.dc.bs	78
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
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
_dir_second_pass:
	.global	_dir_second_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 2
	ld.r.p.off.w r3 sp 12
	mov.r.r r0 r3
	alu.r.i add r0 70
	mov.r.r r1 r0
	ld.r.p.w r1 r1
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l79
	ld.r.i rc 1
	cmp.r.f r1 rc
	jmp.c.j e l80
	ld.r.i rc 2
	cmp.r.f r1 rc
	jmp.c.j e l81
	ld.r.i rc 3
	cmp.r.f r1 rc
	jmp.c.j e l85
	ld.r.i rc 4
	cmp.r.f r1 rc
	jmp.c.j e l86
	ld.r.i rc 5
	cmp.r.f r1 rc
	jmp.c.j e l91
	ld.r.i rc 6
	cmp.r.f r1 rc
	jmp.c.j e l94
	ld.r.i rc 7
	cmp.r.f r1 rc
	jmp.c.j e l95
	ld.r.i rc 8
	cmp.r.f r1 rc
	jmp.c.j e l96
	ld.r.i rc 9
	cmp.r.f r1 rc
	jmp.c.j e l97
	ld.r.i rc 10
	cmp.r.f r1 rc
	jmp.c.j e l100
	ld.r.i rc 11
	cmp.r.f r1 rc
	jmp.c.j e l98
	ld.r.i rc 12
	cmp.r.f r1 rc
	jmp.c.j e l101
	ld.r.i rc 13
	cmp.r.f r1 rc
	jmp.c.j e l99
	ld.r.i rc 14
	cmp.r.f r1 rc
	jmp.c.j e l102
	jmp.c.j LGlge l103
l79:
l80:
	ld.r.i ra 3
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 72
	push.r.sp r0 sp
	call.j.sp sp _type_get_value
	alu.r.i add sp 4
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_byte
	alu.r.i add sp 4
	ld.r.i re 1
	jmp.c.j LGlge l76
l81:
	mov.r.r r0 r3
	alu.r.i add r0 72
	alu.r.i add r0 68
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l83
l82:
	ld.r.i ra 0
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 72
	push.r.sp r0 sp
	call.j.sp sp _write_label_imd
	alu.r.i add sp 4
	jmp.c.j LGlge l84
l83:
	ld.r.i ra 3
	push.r.sp ra sp
	mov.r.r r0 r3
	alu.r.i add r0 72
	push.r.sp r0 sp
	call.j.sp sp _type_get_value
	alu.r.i add sp 4
	mov.r.r r0 re
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_word
	alu.r.i add sp 4
l84:
	ld.r.i re 2
	jmp.c.j LGlge l76
l85:
	mov.r.r r0 r3
	alu.r.i add r0 72
	alu.r.i add r0 66
	ld.r.p.w r0 r0
	alu.r.i band r0 65535
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_word
	alu.r.i add sp 4
	mov.r.r r0 r3
	alu.r.i add r0 72
	alu.r.i add r0 66
	ld.r.p.w r0 r0
	alu.r.i ursh r0 16
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_word
	alu.r.i add sp 4
	ld.r.i re 4
	jmp.c.j LGlge l76
l86:
	ld.r.i r2 0
	jmp.c.j LGlge l88
l87:
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_byte
	alu.r.i add sp 4
l90:
	alu.r.i add r2 1
l88:
	mov.r.r r0 r3
	alu.r.i add r0 72
	alu.r.i add r0 66
	mov.r.r rc r0
	ld.r.p.w rc rc
	cmp.r.f r2 rc
	jmp.c.j l l87
l89:
	mov.r.r r0 r3
	alu.r.i add r0 72
	alu.r.i add r0 66
	mov.r.r re r0
	ld.r.p.w re re
	jmp.c.j LGlge l76
l91:
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	ld.r.p.w r1 r1
	alu.r.i band r1 1
	ld.r.i rc 0
	cmp.r.f r1 rc
	jmp.c.j e l93
	ld.r.i ra 0
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_byte
	alu.r.i add sp 4
	ld.r.i re 1
	jmp.c.j LGlge l76
l93:
	ld.r.i re 0
	jmp.c.j LGlge l76
l94:
	ld.r.m.w ra _cur_module+0
	alu.r.i add ra 1
	st.r.m.w ra _cur_module+0
	ld.r.i re 0
	jmp.c.j LGlge l76
l95:
	ld.r.i re 0
	jmp.c.j LGlge l76
l96:
	ld.r.i re 0
	jmp.c.j LGlge l76
l97:
l98:
l99:
	ld.r.i ra 0
	st.r.m.b ra _cur_seg+0
	ld.r.m.b r0 _cur_seg+0
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_set_seg
	alu.r.i add sp 4
	ld.r.i re 0
	jmp.c.j LGlge l76
l100:
l101:
	ld.r.i ra 1
	st.r.m.b ra _cur_seg+0
	ld.r.m.b r0 _cur_seg+0
	push.r.sp r0 sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_set_seg
	alu.r.i add sp 4
	ld.r.i re 0
	jmp.c.j LGlge l76
l102:
	ld.r.i re 0
	jmp.c.j LGlge l76
l103:
l78:
	ld.r.ra ra l104+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
	ld.r.i re 0
l76:
	alu.r.i add sp 2
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l104:
	.dc.bs	68
	.dc.bs	105
	.dc.bs	114
	.dc.bs	101
	.dc.bs	99
	.dc.bs	116
	.dc.bs	105
	.dc.bs	118
	.dc.bs	101
	.dc.bs	32
	.dc.bs	110
	.dc.bs	111
	.dc.bs	116
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	108
	.dc.bs	101
	.dc.bs	100
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	32
	.dc.bs	115
	.dc.bs	101
	.dc.bs	99
	.dc.bs	111
	.dc.bs	110
	.dc.bs	100
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_cmd_second_pass:
	.global	_cmd_second_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 30
	ld.r.p.off.w r0 sp 40
	alu.r.i add r0 66
	mov.r.r ra r0
	ld.r.p.w ra ra
	st.r.p.w ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	ld.r.p.off.w r0 sp 40
	alu.r.i add r0 64
	mov.r.r ra r0
	ld.r.p.w ra ra
	st.r.p.off.w ra sp 4
	ld.r.i r3 0
	jmp.c.j LGlge l108
l107:
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.p.off.w r0 sp 42
	alu.r.i add r0 72
	mov.r.r r1 r3
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	push.r.sp r0 sp
	call.j.sp sp _type_get_value
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r1 sp
	alu.r.i add r1 4
	mov.r.r r2 r3
	alu.r.i add r2 1
	alu.r.i mul r2 2
	alu.r.r add r1 r2
	st.r.p.w r0 r1
	alu.r.i add r3 1
l108:
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	mov.r.r r1 r3
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l107
l109:
	ld.r.p.w r0 sp
	alu.r.i add r0 24
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _strlen
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r3 r0
	alu.r.i sub r3 1
	jmp.c.j LGlge l111
l110:
	ld.r.p.w r0 sp
	alu.r.i add r0 24
	ld.r.p.w r0 r0
	alu.r.r add r0 r3
	ld.r.p.bs r0 r0
	push.r.sp r0 sp
	call.j.sp sp _hex2int
	alu.r.i add sp 2
	mov.r.r r0 re
	st.r.p.off.b r0 sp 28
	ld.r.p.off.w ra sp 2
	alu.r.i ursh ra 1
	st.r.p.off.w ra sp 2
	ld.r.p.w r0 sp
	alu.r.i add r0 24
	ld.r.p.w r0 r0
	alu.r.r add r0 r3
	ld.r.p.bs r0 r0
	ld.r.i rc 45
	cmp.r.f r0 rc
	jmp.c.j e l114
l113:
	mov.r.r r0 sp
	alu.r.i add r0 4
	ld.r.p.off.b r1 sp 28
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	ld.r.p.w r0 r0
	alu.r.i band r0 1
	alu.r.i lsh r0 15
	ld.r.p.off.w rc sp 2
	mov.r.r ra r0
	alu.r.r bor ra rc
	st.r.p.off.w ra sp 2
l114:
	mov.r.r r0 sp
	alu.r.i add r0 4
	ld.r.p.off.b r1 sp 28
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	alu.r.i ursh ra 1
	st.r.p.w ra r0
	alu.r.i sub r3 1
l111:
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j Ge l110
l112:
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_word
	alu.r.i add sp 4
	ld.r.p.w r0 sp
	alu.r.i add r0 26
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l116
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	ld.r.p.w r1 sp
	alu.r.i add r1 26
	ld.r.p.b r1 r1
	alu.r.i sub r1 1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 3
	cmp.r.f ra rc
	jmp.c.j GLgl l118
l117:
	ld.r.p.off.w r0 sp 40
	alu.r.i add r0 72
	ld.r.p.w r1 sp
	alu.r.i add r1 26
	ld.r.p.b r1 r1
	alu.r.i sub r1 1
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	alu.r.i add r0 66
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_const_word
	alu.r.i add sp 4
	jmp.c.j LGlge l119
l118:
	ld.r.p.w r0 sp
	alu.r.i add r0 4
	ld.r.p.w r1 sp
	alu.r.i add r1 26
	ld.r.p.b r1 r1
	alu.r.i sub r1 1
	alu.r.i mul r1 2
	alu.r.r add r0 r1
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 4
	cmp.r.f ra rc
	jmp.c.j GLgl l121
l120:
	ld.r.i ra 1
	push.r.sp ra sp
	ld.r.p.off.w r0 sp 42
	alu.r.i add r0 72
	ld.r.p.off.w r1 sp 2
	alu.r.i add r1 26
	ld.r.p.b r1 r1
	alu.r.i sub r1 1
	alu.r.i mul r1 78
	alu.r.r add r0 r1
	push.r.sp r0 sp
	call.j.sp sp _write_label_imd
	alu.r.i add sp 4
l121:
l119:
	ld.r.i re 4
	jmp.c.j LGlge l105
l116:
	ld.r.i re 2
l105:
	alu.r.i add sp 30
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_second_pass:
	.global	_second_pass
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	ld.r.p.off.w r2 sp 8
	mov.r.r r0 r2
	alu.r.i add r0 68
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l126
l125:
	mov.r.r r0 r2
	alu.r.i add r0 69
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l128
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	push.r.sp r2 sp
	call.j.sp sp _dir_second_pass
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r rc r1
	ld.r.p.w rc rc
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra r1
	jmp.c.j LGlge l129
l128:
	mov.r.r r0 r2
	alu.r.i add r0 64
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j e l131
l130:
	ld.r.m.b r0 _cur_seg+0
	alu.r.i mul r0 2
	ld.r.ra r1 _seg_pos+0
	alu.r.r add r1 r0
	push.r.sp r2 sp
	call.j.sp sp _cmd_second_pass
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r rc r1
	ld.r.p.w rc rc
	mov.r.r ra r0
	alu.r.r add ra rc
	st.r.p.w ra r1
	jmp.c.j LGlge l132
l131:
	ld.r.ra ra l133+0
	push.r.sp ra sp
	call.j.sp sp _error
	alu.r.i add sp 2
l132:
l129:
l126:
l122:
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l133:
	.dc.bs	70
	.dc.bs	105
	.dc.bs	114
	.dc.bs	115
	.dc.bs	116
	.dc.bs	32
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	115
	.dc.bs	32
	.dc.bs	99
	.dc.bs	97
	.dc.bs	110
	.dc.bs	39
	.dc.bs	116
	.dc.bs	32
	.dc.bs	104
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	108
	.dc.bs	101
	.dc.bs	32
	.dc.bs	116
	.dc.bs	104
	.dc.bs	105
	.dc.bs	115
	.dc.bs	32
	.dc.bs	99
	.dc.bs	111
	.dc.bs	109
	.dc.bs	109
	.dc.bs	97
	.dc.bs	110
	.dc.bs	100
	.dc.bs	10
	.dc.bs	0

	.bss
	.align
	.extern	___crtudiv

	.bss
	.align
	.extern	_strlen

	.bss
	.align
	.extern	_obj_write_extern_offset

	.bss
	.align
	.extern	_obj_write_offset

	.bss
	.align
	.extern	_obj_write_const_word

	.bss
	.align
	.extern	_obj_write_const_byte

	.bss
	.align
	.extern	_obj_set_seg

	.bss
	.align
	.extern	_obj_write_extern

	.bss
	.align
	.extern	_obj_expand_extern

	.bss
	.align
	.extern	_find_label

	.bss
	.align
	.extern	_add_label

	.bss
	.align
	.extern	_cur_module

	.bss
	.align
	.extern	_seg_pos

	.bss
	.align
	.extern	_cur_seg

	.bss
	.align
	.extern	_error

	.bss
	.align
	.extern	_out

	.bss
	.align
	.extern	_hex2int

	.bss
	.align
	.extern	_add_def
;	End of VBCC generated section
	.module

