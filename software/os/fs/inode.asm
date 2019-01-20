	.text
	.align
_inode_alloc:
	.global	_inode_alloc
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 2
	ld.r.i r2 0
	jmp.c.j LGlge l4
l3:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 14
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l8
l7:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l1
l8:
l6:
	alu.r.i add r2 1
l4:
	ld.r.i rc 24
	cmp.r.f r2 rc
	jmp.c.j l l3
l5:
	ld.r.i r2 0
	jmp.c.j LGlge l10
l9:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 12
	mov.r.r ra r1
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l14
l13:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 14
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l16
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	call.j.sp sp _inode_force_put
	alu.r.i add sp 2
l16:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l1
l14:
l12:
	alu.r.i add r2 1
l10:
	ld.r.i rc 24
	cmp.r.f r2 rc
	jmp.c.j l l9
l11:
	ld.r.i ra 3
	push.r.sp ra sp
	call.j.sp sp _panic
	alu.r.i add sp 2
l1:
	alu.r.i add sp 2
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_load:
	.global	_inode_load
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r3 sp 18
	ld.r.p.off.w r2 sp 16
	ld.r.m.w rc _superblk+0
	cmp.r.f r3 rc
	jmp.c.j l l20
l19:
	ld.r.i ra 5
	push.r.sp ra sp
	call.j.sp sp _panic
	alu.r.i add sp 2
l20:
	mov.r.r r0 r3
	alu.r.i ursh r0 6
	mov.r.r ra r0
	alu.r.i add ra 384
	st.r.p.w ra sp
	mov.r.r r0 r3
	alu.r.i band r0 63
	mov.r.r ra r0
	alu.r.i mul ra 8
	st.r.p.off.w ra sp 2
	ld.r.ra ra _fs_global_buf+0
	push.r.sp ra sp
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	call.j.sp sp _disk_read
	alu.r.i add sp 4
	ld.r.p.off.w rc sp 2
	ld.r.ra ra _fs_global_buf+0
	alu.r.r add ra rc
	st.r.p.off.w ra sp 4
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_byte
	alu.r.i add sp 2
	st.r.p.b re r2
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_byte
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 1
	st.r.p.b r0 r1
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_byte
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 2
	st.r.p.b r0 r1
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_word
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 4
	st.r.p.w r0 r1
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_word
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 6
	st.r.p.w r0 r1
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp __read_byte
	alu.r.i add sp 2
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 8
	st.r.p.b r0 r1
l17:
	alu.r.i add sp 6
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_write:
	.global	_inode_write
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r2 sp 18
	ld.r.p.off.w r1 sp 16
	ld.r.m.w rc _superblk+0
	cmp.r.f r2 rc
	jmp.c.j l l24
l23:
	ld.r.i ra 5
	push.r.sp ra sp
	call.j.sp sp _panic
	alu.r.i add sp 2
l24:
	mov.r.r r0 r2
	alu.r.i ursh r0 6
	mov.r.r r3 r0
	alu.r.i add r3 384
	mov.r.r r0 r2
	alu.r.i band r0 63
	mov.r.r ra r0
	alu.r.i mul ra 8
	st.r.p.off.w ra sp 2
	ld.r.ra ra _fs_global_buf+0
	push.r.sp ra sp
	push.r.sp r3 sp
	call.j.sp sp _disk_read
	alu.r.i add sp 4
	ld.r.p.off.w rc sp 2
	ld.r.ra ra _fs_global_buf+0
	alu.r.r add ra rc
	st.r.p.off.w ra sp 4
	mov.r.r r0 r1
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_byte
	alu.r.i add sp 4
	mov.r.r r0 r1
	alu.r.i add r0 1
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_byte
	alu.r.i add sp 4
	mov.r.r r0 r1
	alu.r.i add r0 2
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_byte
	alu.r.i add sp 4
	mov.r.r r0 r1
	alu.r.i add r0 4
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_word
	alu.r.i add sp 4
	mov.r.r r0 r1
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_word
	alu.r.i add sp 4
	mov.r.r r0 r1
	alu.r.i add r0 8
	ld.r.p.b r0 r0
	push.r.sp r0 sp
	mov.r.r r0 sp
	alu.r.i add r0 6
	push.r.sp r0 sp
	call.j.sp sp __write_byte
	alu.r.i add sp 4
	ld.r.ra ra _fs_global_buf+0
	push.r.sp ra sp
	push.r.sp r3 sp
	call.j.sp sp _disk_write
	alu.r.i add sp 4
l21:
	alu.r.i add sp 6
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_get:
	.global	_inode_get
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.p.off.w r3 sp 14
	ld.r.i r2 0
	jmp.c.j LGlge l28
l27:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 10
	mov.r.r ra r1
	ld.r.p.w ra ra
	cmp.r.f ra r3
	jmp.c.j GLgl l32
l33:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 14
	mov.r.r ra r1
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l32
l31:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	alu.r.i add r1 12
	mov.r.r ra r1
	ld.r.p.b ra ra
	alu.r.i add ra 1
	st.r.p.b ra r1
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	mov.r.r re r1
	jmp.c.j LGlge l25
l32:
l30:
	alu.r.i add r2 1
l28:
	ld.r.i rc 24
	cmp.r.f r2 rc
	jmp.c.j l l27
l29:
	call.j.sp sp _inode_alloc
	st.r.p.off.w re sp 2
	push.r.sp r3 sp
	ld.r.p.off.w ra sp 4
	push.r.sp ra sp
	call.j.sp sp _inode_load
	alu.r.i add sp 4
	ld.r.p.off.w r0 sp 2
	alu.r.i add r0 8
	mov.r.r ra r0
	ld.r.p.b ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l35
l34:
	ld.r.i re 0
	jmp.c.j LGlge l25
l35:
	ld.r.p.off.w r0 sp 2
	alu.r.i add r0 12
	ld.r.i ra 1
	st.r.p.b ra r0
	ld.r.p.off.w r0 sp 2
	alu.r.i add r0 10
	st.r.p.w r3 r0
	ld.r.p.off.w r0 sp 2
	alu.r.i add r0 16
	push.r.sp r0 sp
	ld.r.p.off.w r0 sp 4
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _balloc_get
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 2
	alu.r.i add r1 14
	st.r.p.w r0 r1
	ld.r.p.off.w r0 sp 2
	alu.r.i add r0 14
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l37
l36:
	ld.r.p.off.w ra sp 2
	push.r.sp ra sp
	call.j.sp sp _inode_put
	alu.r.i add sp 2
	ld.r.i re 0
	jmp.c.j LGlge l25
l37:
	ld.r.p.off.w re sp 2
l25:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_put:
	.global	_inode_put
	push.r.sp r0 sp
	ld.r.p.off.w r4 sp 4
	mov.r.r r0 r4
	alu.r.i add r0 12
	mov.r.r ra r0
	ld.r.p.b ra ra
	alu.r.i sub ra 1
	st.r.p.b ra r0
l38:
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_force_put:
	.global	_inode_force_put
	push.r.sp r0 sp
	push.r.sp r1 sp
	ld.r.p.off.w r1 sp 6
	mov.r.r r0 r1
	alu.r.i add r0 10
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j e l43
	mov.r.r r0 r1
	alu.r.i add r0 14
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _kfree
	alu.r.i add sp 2
	mov.r.r r0 r1
	alu.r.i add r0 14
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r1
	alu.r.i add r0 10
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	push.r.sp r1 sp
	call.j.sp sp _inode_write
	alu.r.i add sp 4
l43:
l40:
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_put_all:
	.global	_inode_put_all
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 2
	ld.r.i r2 0
	jmp.c.j LGlge l47
l46:
	mov.r.r r0 r2
	alu.r.i mul r0 18
	ld.r.ra r1 _inode_table+0
	alu.r.r add r1 r0
	push.r.sp r1 sp
	call.j.sp sp _inode_force_put
	alu.r.i add sp 2
l49:
	alu.r.i add r2 1
l47:
	ld.r.i rc 24
	cmp.r.f r2 rc
	jmp.c.j l l46
l48:
l44:
	alu.r.i add sp 2
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_add_blk:
	.global	_inode_add_blk
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 4
	ld.r.i ra 0
	st.r.p.w ra sp
	ld.r.p.off.w r0 sp 14
	alu.r.i add r0 14
	mov.r.r r3 r0
	ld.r.p.w r3 r3
l52:
	ld.r.p.w ra sp
	alu.r.i add ra 1
	st.r.p.w ra sp
l54:
	mov.r.r r0 r3
	alu.r.i add r3 2
	mov.r.r ra r0
	ld.r.p.w ra ra
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l52
l53:
	ld.r.p.w r0 sp
	alu.r.i add r0 1
	alu.r.i lsh r0 1
	push.r.sp r0 sp
	ld.r.p.off.w r0 sp 16
	alu.r.i add r0 14
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _krealloc
	alu.r.i add sp 4
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 14
	alu.r.i add r1 14
	st.r.p.w r0 r1
	call.j.sp sp _balloc_alloc
	mov.r.r r0 re
	ld.r.p.off.w r1 sp 14
	alu.r.i add r1 14
	ld.r.p.w r2 sp
	alu.r.i sub r2 1
	alu.r.i mul r2 2
	ld.r.p.w r1 r1
	alu.r.r add r1 r2
	st.r.p.w r0 r1
	ld.r.p.off.w r0 sp 14
	alu.r.i add r0 14
	ld.r.p.w r1 sp
	alu.r.i mul r1 2
	ld.r.p.w r0 r0
	alu.r.r add r0 r1
	ld.r.i ra 0
	st.r.p.w ra r0
	ld.r.p.off.w r0 sp 14
	alu.r.i add r0 16
	mov.r.r ra r0
	ld.r.p.b ra ra
	alu.r.i add ra 1
	st.r.p.b ra r0
	ld.r.p.off.w r0 sp 14
	alu.r.i add r0 14
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _balloc_put
	alu.r.i add sp 2
l50:
	alu.r.i add sp 4
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_truncate:
	.global	_inode_truncate
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	alu.r.i sub sp 6
	ld.r.p.off.w r2 sp 14
	mov.r.r r0 r2
	alu.r.i add r0 4
	ld.r.i ra 0
	st.r.p.w ra r0
	mov.r.r r0 r2
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _balloc_free
	alu.r.i add sp 2
	call.j.sp sp _balloc_alloc
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 6
	st.r.p.w r0 r1
	mov.r.r r0 r2
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	st.r.p.w ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 2
	mov.r.r r0 sp
	push.r.sp r0 sp
	call.j.sp sp _balloc_put
	alu.r.i add sp 2
	mov.r.r r0 r2
	alu.r.i add r0 14
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _kfree
	alu.r.i add sp 2
	mov.r.r r0 r2
	alu.r.i add r0 16
	push.r.sp r0 sp
	mov.r.r r0 r2
	alu.r.i add r0 6
	mov.r.r ra r0
	ld.r.p.w ra ra
	push.r.sp ra sp
	call.j.sp sp _balloc_get
	alu.r.i add sp 4
	mov.r.r r0 re
	mov.r.r r1 r2
	alu.r.i add r1 14
	st.r.p.w r0 r1
l55:
	alu.r.i add sp 6
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_new:
	.global	_inode_new
	push.r.sp r0 sp
	push.r.sp r1 sp
	push.r.sp r2 sp
	push.r.sp r3 sp
	alu.r.i sub sp 24
	ld.r.p.off.b r3 sp 36
	ld.r.p.off.w r2 sp 34
	ld.r.i r1 0
	jmp.c.j LGlge l60
l59:
	push.r.sp r1 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp _inode_load
	alu.r.i add sp 4
	ld.r.p.off.b ra sp 10
	ld.r.i rc 0
	cmp.r.f ra rc
	jmp.c.j GLgl l64
l63:
	ld.r.i ra 1
	st.r.p.off.b ra sp 10
	ld.r.i ra 1
	st.r.p.off.b ra sp 2
	ld.r.i ra 0
	st.r.p.off.w ra sp 6
	st.r.p.off.b r2 sp 4
	st.r.p.off.b r3 sp 3
	call.j.sp sp _balloc_alloc
	st.r.p.off.w re sp 8
	ld.r.p.off.w ra sp 8
	st.r.p.off.w ra sp 20
	ld.r.i ra 0
	st.r.p.off.w ra sp 22
	mov.r.r r0 sp
	alu.r.i add r0 20
	push.r.sp r0 sp
	call.j.sp sp _balloc_put
	alu.r.i add sp 2
	push.r.sp r1 sp
	mov.r.r r0 sp
	alu.r.i add r0 4
	push.r.sp r0 sp
	call.j.sp sp _inode_write
	alu.r.i add sp 4
	mov.r.r re r1
	jmp.c.j LGlge l57
l64:
l62:
	alu.r.i add r1 1
l60:
	ld.r.m.w rc _superblk+0
	cmp.r.f r1 rc
	jmp.c.j l l59
l61:
	ld.r.i ra 8
	push.r.sp ra sp
	call.j.sp sp _panic
	alu.r.i add sp 2
l57:
	alu.r.i add sp 24
	pop.r.sp r3 sp
	pop.r.sp r2 sp
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp
	.text
	.align
_inode_delete:
	.global	_inode_delete
	push.r.sp r0 sp
	push.r.sp r1 sp
	alu.r.i sub sp 18
	ld.r.p.off.w r1 sp 24
	push.r.sp r1 sp
	mov.r.r r0 sp
	alu.r.i add r0 2
	push.r.sp r0 sp
	call.j.sp sp _inode_load
	alu.r.i add sp 4
	ld.r.i ra 0
	st.r.p.b ra sp
	ld.r.i ra 0
	st.r.p.off.w ra sp 4
	ld.r.i ra 0
	st.r.p.off.b ra sp 8
	ld.r.p.off.w ra sp 6
	push.r.sp ra sp
	call.j.sp sp _balloc_free
	alu.r.i add sp 2
	push.r.sp r1 sp
	mov.r.r r0 sp
	alu.r.i add r0 2
	push.r.sp r0 sp
	call.j.sp sp _inode_write
	alu.r.i add sp 4
l65:
	alu.r.i add sp 18
	pop.r.sp r1 sp
	pop.r.sp r0 sp
	ret.n.sp sp

	.bss
	.extern	_superblk

	.bss
	.extern	_balloc_free

	.bss
	.extern	_balloc_get

	.bss
	.extern	_balloc_put

	.bss
	.extern	_balloc_alloc

	.bss
	.extern	_disk_write

	.bss
	.extern	_disk_read

	.bss
	.extern	_fs_global_buf

	.bss
_inode_table:
	.global	_inode_table
	.align
	.ds	432

	.bss
	.extern	_krealloc

	.bss
	.extern	_kfree

	.bss
	.extern	_panic

	.bss
	.extern	__write_word

	.bss
	.extern	__write_byte

	.bss
	.extern	__read_word

	.bss
	.extern	__read_byte
;	End of VBCC generated section
	.module

