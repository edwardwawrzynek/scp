	.text
	.align
_usage:
	.global	_usage
	push.r.sp r0 sp
	ld.r.ra ra l3+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 2
	mov.r.r r0 re
l1:
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l3:
	.dc.bs	85
	.dc.bs	115
	.dc.bs	97
	.dc.bs	103
	.dc.bs	101
	.dc.bs	58
	.dc.bs	32
	.dc.bs	115
	.dc.bs	99
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	109
	.dc.bs	32
	.dc.bs	91
	.dc.bs	111
	.dc.bs	112
	.dc.bs	116
	.dc.bs	105
	.dc.bs	111
	.dc.bs	110
	.dc.bs	115
	.dc.bs	93
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	115
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	10
	.dc.bs	79
	.dc.bs	112
	.dc.bs	116
	.dc.bs	105
	.dc.bs	111
	.dc.bs	110
	.dc.bs	115
	.dc.bs	58
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	10
	.dc.bs	45
	.dc.bs	111
	.dc.bs	9
	.dc.bs	111
	.dc.bs	117
	.dc.bs	116
	.dc.bs	46
	.dc.bs	111
	.dc.bs	9
	.dc.bs	58
	.dc.bs	115
	.dc.bs	101
	.dc.bs	116
	.dc.bs	32
	.dc.bs	111
	.dc.bs	117
	.dc.bs	116
	.dc.bs	112
	.dc.bs	117
	.dc.bs	116
	.dc.bs	32
	.dc.bs	98
	.dc.bs	105
	.dc.bs	110
	.dc.bs	97
	.dc.bs	114
	.dc.bs	121
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	32
	.dc.bs	10
	.dc.bs	45
	.dc.bs	100
	.dc.bs	9
	.dc.bs	100
	.dc.bs	101
	.dc.bs	98
	.dc.bs	117
	.dc.bs	103
	.dc.bs	9
	.dc.bs	58
	.dc.bs	111
	.dc.bs	117
	.dc.bs	116
	.dc.bs	112
	.dc.bs	117
	.dc.bs	116
	.dc.bs	32
	.dc.bs	100
	.dc.bs	101
	.dc.bs	98
	.dc.bs	117
	.dc.bs	103
	.dc.bs	103
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	102
	.dc.bs	111
	.dc.bs	32
	.dc.bs	105
	.dc.bs	110
	.dc.bs	32
	.dc.bs	100
	.dc.bs	101
	.dc.bs	98
	.dc.bs	117
	.dc.bs	103
	.dc.bs	10
	.dc.bs	0
	.text
	.align
_main:
	.global	_main
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 10
	ld.r.ra ra l6+0
	st.r.p.w ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	jmp.c.j LGlge l8
l7:
	ld.r.p.off.w r0 sp 4
	ld.r.i rc 63
	cmp.r.f r0 rc
	jmp.c.j e l13
	ld.r.i rc 100
	cmp.r.f r0 rc
	jmp.c.j e l12
	ld.r.i rc 111
	cmp.r.f r0 rc
	jmp.c.j e l11
	jmp.c.j LGlge l14
l11:
	ld.r.m.w ra _optarg+0
	st.r.p.w ra sp
	jmp.c.j LGlge l10
l12:
	ld.r.m.w ra _optarg+0
	st.r.p.off.w ra sp 2
	ld.r.i ra 1
	st.r.m.b ra _do_debug+0
	jmp.c.j LGlge l10
l13:
	call.j.sp sp _usage
	st.r.p.off.w ra sp 6
	ld.r.i ra 1
	call.j.sp sp _exit
	mov.r.r r0 re
	ld.r.p.off.w ra sp 6
l14:
	st.r.p.off.w ra sp 8
	ld.r.i ra 1
	call.j.sp sp _exit
	mov.r.r r0 re
	ld.r.p.off.w ra sp 8
l10:
l8:
	ld.r.ra ra l15+0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 24
	push.r.sp ra sp
	ld.r.p.off.w ra sp 24
	push.r.sp ra sp
	call.j.sp sp _getopt
	alu.r.i add sp 6
	st.r.p.off.w re sp 4
	ld.r.p.off.w ra sp 4
	ld.r.i rc -1
	cmp.r.f ra rc
	jmp.c.j GLgl l7
l9:
	ld.r.i r3 0
	jmp.c.j LGlge l17
l16:
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	ld.r.p.off.w r1 sp 22
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l20+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.ra ra l21+0
	push.r.sp ra sp
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	ld.r.p.off.w r1 sp 24
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r1 r3
	alu.r.i add r3 1
	alu.r.i mul r1 2
	ld.r.ra r2 _in_files+0
	alu.r.r add r2 r1
	st.r.p.w r0 r2
	mov.r.r r0 r3
	alu.r.i sub r0 1
	alu.r.i mul r0 2
	ld.r.ra r1 _in_files+0
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l23
l22:
	ld.r.m.w r0 _optind+0
	alu.r.i mul r0 2
	ld.r.p.off.w r1 sp 22
	alu.r.r add r1 r0
	mov.r.r ra r1
	ld.r.p.w ra ra
	push.r.sp ra sp
	ld.r.ra ra l24+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	st.r.p.off.w ra sp 8
	ld.r.i ra 1
	call.j.sp sp _exit
	mov.r.r r0 re
	ld.r.p.off.w ra sp 8
l23:
l19:
	ld.r.m.w ra _optind+0
	alu.r.i add ra 1
	st.r.m.w ra _optind+0
l17:
	ld.r.m.w ra _optind+0
	ld.r.p.off.w rc sp 20
	cmp.r.f ra rc
	jmp.c.j L l16
l18:
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_init
	alu.r.i add sp 2
	ld.r.p.w ra sp
	push.r.sp ra sp
	ld.r.ra ra l25+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.ra ra l26+0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	st.r.m.w re _out+0
	ld.r.m.b ra _do_debug+0
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l28
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	ld.r.ra ra l29+0
	push.r.sp ra sp
	call.j.sp sp _printf
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.ra ra l30+0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	call.j.sp sp _fopen
	alu.r.i add sp 4
	st.r.m.w re _debug_file+0
l28:
	ld.r.i rc 0
	cmp.r.f r3 rc
	jmp.c.j GLgl l32
l31:
	call.j.sp sp _usage
	st.r.p.off.w ra sp 8
	ld.r.i ra 1
	call.j.sp sp _exit
	mov.r.r r0 re
	ld.r.p.off.w ra sp 8
l32:
	call.j.sp sp _run_asm
	ld.r.m.w ra _out+0
	push.r.sp ra sp
	call.j.sp sp _fclose
	alu.r.i add sp 2
	mov.r.r r0 re
	ld.r.i re 0
l4:
	alu.r.i add sp 10
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.rodata
	.align
l24:
	.dc.bs	115
	.dc.bs	99
	.dc.bs	112
	.dc.bs	97
	.dc.bs	115
	.dc.bs	109
	.dc.bs	58
	.dc.bs	32
	.dc.bs	101
	.dc.bs	114
	.dc.bs	114
	.dc.bs	111
	.dc.bs	114
	.dc.bs	58
	.dc.bs	32
	.dc.bs	110
	.dc.bs	111
	.dc.bs	32
	.dc.bs	115
	.dc.bs	117
	.dc.bs	99
	.dc.bs	104
	.dc.bs	32
	.dc.bs	102
	.dc.bs	105
	.dc.bs	108
	.dc.bs	101
	.dc.bs	32
	.dc.bs	37
	.dc.bs	115
	.dc.bs	10
	.dc.bs	0

	.rodata
	.align
l20:
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
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
	.align
l21:
	.dc.bs	114
	.dc.bs	0

	.rodata
	.align
l29:
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
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
	.align
l30:
	.dc.bs	119
	.dc.bs	0

	.rodata
	.align
l6:
	.dc.bs	97
	.dc.bs	46
	.dc.bs	111
	.dc.bs	117
	.dc.bs	116
	.dc.bs	0

	.rodata
	.align
l15:
	.dc.bs	111
	.dc.bs	58
	.dc.bs	100
	.dc.bs	58
	.dc.bs	0

	.rodata
	.align
l25:
	.dc.bs	111
	.dc.bs	112
	.dc.bs	101
	.dc.bs	110
	.dc.bs	105
	.dc.bs	110
	.dc.bs	103
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
	.align
l26:
	.dc.bs	119
	.dc.bs	0
	.text
	.align
_run_asm:
	.global	_run_asm
	push.r.sp r0 sp
	alu.r.i sub sp 4
	jmp.c.j LGlge l36
l35:
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _line_into_instr
	alu.r.i add sp 2
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _check_instr
	alu.r.i add sp 2
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _first_pass
	alu.r.i add sp 2
l36:
	call.j.sp sp _read_good_line
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l35
l37:
	call.j.sp sp _first_pass_align
	call.j.sp sp _remove_defined_externs
	ld.r.i ra 0
	st.r.p.w ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	mov.r.r r0 sp
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp _labels_get_num
	alu.r.i add sp 4
	ld.r.p.w ra sp
	push.r.sp ra sp
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	ld.r.m.w ra _seg_pos+6
	push.r.sp ra sp
	ld.r.m.w ra _seg_pos+4
	push.r.sp ra sp
	ld.r.m.w ra _seg_pos+2
	push.r.sp ra sp
	ld.r.m.w ra _seg_pos+0
	push.r.sp ra sp
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_create_header
	alu.r.i add sp 14
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _obj_write_header
	alu.r.i add sp 2
	ld.r.ra ra _out+0
	push.r.sp ra sp
	call.j.sp sp _labels_write_out
	alu.r.i add sp 2
	call.j.sp sp _reset_segs_and_module
	call.j.sp sp _reset_file
	jmp.c.j LGlge l39
l38:
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _line_into_instr
	alu.r.i add sp 2
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _check_instr
	alu.r.i add sp 2
	ld.r.ra ra _in+0
	push.r.sp ra sp
	call.j.sp sp _second_pass
	alu.r.i add sp 2
l39:
	call.j.sp sp _read_good_line
	mov.r.r r0 re
	ld.r.i rc 0
	cmp.r.f r0 rc
	jmp.c.j e l38
l40:
l33:
	alu.r.i add sp 4
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.align
	.extern	_fopen

	.bss
	.align
	.extern	_fclose

	.bss
	.align
	.extern	_printf

	.bss
	.align
	.extern	_debug_file

	.bss
	.align
	.extern	_do_debug

	.bss
	.align
	.extern	_exit

	.bss
	.align
	.extern	_optarg

	.bss
	.align
	.extern	_optind

	.bss
	.align
	.extern	_getopt

	.bss
	.align
	.extern	_reset_file

	.bss
	.align
	.extern	_out

	.bss
	.align
	.extern	_in_files

	.bss
	.align
	.extern	_check_instr

	.bss
	.align
	.extern	_line_into_instr

	.bss
	.align
	.extern	_read_good_line

	.bss
	.align
	.extern	_obj_create_header

	.bss
	.align
	.extern	_obj_init

	.bss
	.align
	.extern	_obj_write_header

	.bss
	.align
	.extern	_first_pass_align

	.bss
	.align
	.extern	_first_pass

	.bss
	.align
	.extern	_second_pass

	.bss
	.align
	.extern	_remove_defined_externs

	.bss
	.align
	.extern	_labels_write_out

	.bss
	.align
	.extern	_labels_get_num

	.bss
	.align
	.extern	_reset_segs_and_module

	.bss
	.align
	.extern	_seg_pos

	.bss
	.align
_in:
	.global	_in
	.align
	.ds	852
;	End of VBCC generated section
	.module

