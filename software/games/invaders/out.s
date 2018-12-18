;	Small C
;	Small C Processor Backend Coder(Mostly Works)
;	Front End (2.8,13/01/20)

;	program area SMALLC_GENERATED is RELOCATABLE
	.module	SMALLC_GENERATED
;	Code Segment
bufputchar:
	lwia	screen_buf
	psha	
	lwma	buf_pos
	inca	
	swma	buf_pos
	deca	
	popb	
	aadd	
	psha	
	mspa	#4
	lbpa	
	popb	
	sbqa	
	lwma	buf_pos
	psha	
	lwia	#2000
	popb	
	ault	
	alng	
	jpz 	$4
	lwia	#0
	swma	buf_pos
$4:
$3:
	ret 	
bufblit:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$6:
	mspa	#0
	lwpa	
	psha	
	lwia	#1920
	popb	
	ault	
	jpz 	$7
	mspa	#0
	lwpa	
	psha	
	lwia	#5
	psha	
	call	outp
	mdsp	#4
	lwia	screen_buf
	psha	
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	popb	
	aadd	
	lbpa	
	asex	
	psha	
	lwia	#6
	psha	
	call	outp
	mdsp	#4
	jmp 	$6
$7:
	lwia	#0
	swma	buf_pos
$5:
	mdsp	#2
	ret 	
reset:
	mdsp	#-2
	call	_screenclear
	lwia	#1
	swma	enemyDir
	lwia	#20
	swma	player_pos
	lwia	#0
	sbma	player_shooting
	lwia	#0
	swma	player_shotX
	lwia	#23
	swma	player_shotY
	lwia	#4
	swma	player_life
	lwia	#0
	swma	player_score
	lwia	#0
	swma	player_hit_time
	lwia	#0
	sbma	mode
	lwia	#0
	swma	enemyX
	lwia	#0
	swma	enemyY
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$9:
	mspa	#0
	lwpa	
	psha	
	lwia	#50
	popb	
	ault	
	jpnz	$11
	jmp 	$12
$10:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$9
$11:
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#0
	popb	
	sbqa	
	jmp 	$10
$12:
	lwia	#21
	swma	enemy_shotX
	lwia	#0
	swma	enemy_shotY
	lwia	#0
	sbma	leftP
	lwia	#0
	sbma	rightP
	lwia	#0
	swma	framecount
	lwia	#0
	swma	buf_pos
$8:
	mdsp	#2
	ret 	
drawScreen:
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mdsp	#-2
	mspa	#4
	psha	
	lwia	#0
	popb	
	swqa	
$14:
	mspa	#4
	lwpa	
	psha	
	lwia	#23
	popb	
	ault	
	jpnz	$16
	jmp 	$17
$15:
	mspa	#4
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$14
$16:
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
$18:
	mspa	#6
	lwpa	
	psha	
	lwia	#40
	popb	
	ault	
	jpnz	$20
	jmp 	$21
$19:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	jmp 	$18
$20:
	mspa	#6
	lwpa	
	psha	
	lwma	enemyX
	popb	
	ault	
	alng	
	jpz 	$23
	mspa	#6
	lwpa	
	psha	
	lwma	enemyX
	psha	
	lwia	#10
	psha	
	lwia	#3
	popb	
	amul	
	popb	
	aadd	
	popb	
	ault	
$23:
	aclv	
	jpz 	$24
	mspa	#4
	lwpa	
	psha	
	lwma	enemyY
	popb	
	ault	
	alng	
$24:
	aclv	
	jpz 	$25
	mspa	#4
	lwpa	
	psha	
	lwma	enemyY
	psha	
	lwia	#5
	psha	
	lwia	#2
	popb	
	amul	
	popb	
	aadd	
	popb	
	ault	
$25:
	aclv	
	jpz 	$26
	mspa	#4
	lwpa	
	psha	
	lwma	enemyY
	popb	
	asub	
	psha	
	lwia	#1
	popb	
	abnd	
	alng	
$26:
	aclv	
	jpz 	$22
	mspa	#0
	psha	
	mspa	#8
	lwpa	
	psha	
	lwma	enemyX
	popb	
	asub	
	psha	
	lwia	#3
	popb	
	call	ccudiv
	popb	
	swqa	
	mspa	#0
	psha	
	lwpa	
	psha	
	mspa	#8
	lwpa	
	psha	
	lwma	enemyY
	popb	
	asub	
	psha	
	lwia	#1
	popb	
	ashr	
	psha	
	lwia	#10
	popb	
	amul	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#2
	psha	
	mspa	#8
	lwpa	
	psha	
	lwma	enemyX
	popb	
	asub	
	psha	
	lwia	#3
	popb	
	call	ccudiv
	xswp	
	popb	
	swqa	
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	alng	
	jpz 	$27
	mspa	#2
	lwpa	
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$28
	lwma	framecount
	psha	
	lwia	#8
	popb	
	abnd	
	jpz 	$29
	lwia	#47
	jmp 	$30
$29:
	lwia	#40
$30:
	psha	
	call	bufputchar
	mdsp	#2
$28:
	mspa	#2
	lwpa	
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$31
	lwia	#111
	psha	
	call	bufputchar
	mdsp	#2
$31:
	mspa	#2
	lwpa	
	psha	
	lwia	#2
	popb	
	aequ	
	jpz 	$32
	lwma	framecount
	psha	
	lwia	#8
	popb	
	abnd	
	jpz 	$33
	lwia	#92
	jmp 	$34
$33:
	lwia	#41
$34:
	psha	
	call	bufputchar
	mdsp	#2
$32:
	jmp 	$35
$27:
	lbma	player_shooting
	jpz 	$36
	mspa	#6
	lwpa	
	psha	
	lwma	player_shotX
	popb	
	aequ	
$36:
	aclv	
	jpz 	$37
	mspa	#4
	lwpa	
	psha	
	lwma	player_shotY
	popb	
	aequ	
$37:
	aclv	
	jpz 	$38
	lwia	#33
	jmp 	$39
$38:
	mspa	#6
	lwpa	
	psha	
	lwma	enemy_shotX
	popb	
	aequ	
	jpz 	$40
	mspa	#4
	lwpa	
	psha	
	lwma	enemy_shotY
	popb	
	aequ	
$40:
	aclv	
	jpz 	$41
	lwia	#58
	jmp 	$42
$41:
	lwia	#32
$42:
$39:
	psha	
	call	bufputchar
	mdsp	#2
$35:
	jmp 	$43
$22:
	lbma	player_shooting
	jpz 	$44
	mspa	#6
	lwpa	
	psha	
	lwma	player_shotX
	popb	
	aequ	
$44:
	aclv	
	jpz 	$45
	mspa	#4
	lwpa	
	psha	
	lwma	player_shotY
	popb	
	aequ	
$45:
	aclv	
	jpz 	$46
	lwia	#33
	jmp 	$47
$46:
	mspa	#6
	lwpa	
	psha	
	lwma	enemy_shotX
	popb	
	aequ	
	jpz 	$48
	mspa	#4
	lwpa	
	psha	
	lwma	enemy_shotY
	popb	
	aequ	
$48:
	aclv	
	jpz 	$49
	lwia	#58
	jmp 	$50
$49:
	lwia	#32
$50:
$47:
	psha	
	call	bufputchar
	mdsp	#2
$43:
	jmp 	$19
$21:
	lwma	buf_pos
	psha	
	lwia	#40
	popb	
	aadd	
	swma	buf_pos
	jmp 	$15
$17:
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
$51:
	mspa	#6
	lwpa	
	psha	
	lwia	#40
	popb	
	ault	
	jpnz	$53
	jmp 	$54
$52:
	mspa	#6
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$51
$53:
	mspa	#6
	lwpa	
	psha	
	lwma	player_pos
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	aequ	
	jpz 	$55
	lwma	player_hit_time
	jpz 	$56
	lwia	#35
	jmp 	$57
$56:
	lwia	#47
$57:
	psha	
	call	bufputchar
	mdsp	#2
	jmp 	$58
$55:
	mspa	#6
	lwpa	
	psha	
	lwma	player_pos
	popb	
	aequ	
	jpz 	$59
	lwma	player_hit_time
	jpz 	$60
	lwia	#35
	jmp 	$61
$60:
	lwia	#94
$61:
	psha	
	call	bufputchar
	mdsp	#2
	jmp 	$62
$59:
	mspa	#6
	lwpa	
	psha	
	lwma	player_pos
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	aequ	
	jpz 	$63
	lwma	player_hit_time
	jpz 	$64
	lwia	#35
	jmp 	$65
$64:
	lwia	#92
$65:
	psha	
	call	bufputchar
	mdsp	#2
	jmp 	$66
$63:
	lwia	#32
	psha	
	call	bufputchar
	mdsp	#2
$66:
$62:
$58:
	jmp 	$52
$54:
	lwma	player_hit_time
	jpz 	$67
	lwma	player_hit_time
	deca	
	swma	player_hit_time
$67:
	call	bufblit
$13:
	mdsp	#8
	ret 	
drawBottomLine:
	lwia	#1920
	swma	_screenpos
	lwma	player_score
	psha	
	lwia	$0+#0
	psha	
	call	printf
	mdsp	#4
	lwia	#1953
	swma	_screenpos
	lwma	player_life
	psha	
	lwia	#0
	popb	
	aslt	
	alng	
	jpz 	$69
	lwma	player_life
	jmp 	$70
$69:
	lwia	#0
$70:
	psha	
	lwia	$0+#11
	psha	
	call	printf
	mdsp	#4
$68:
	ret 	
updateKeys:
	mdsp	#-2
	mspa	#0
	psha	
	call	_key_async_read
	popb	
	swqa	
	mspa	#0
	lwpa	
	psha	
	lwia	#30
	popb	
	aequ	
	jpz 	$72
	lwia	#1
	sbma	rightP
	jmp 	$73
$72:
	mspa	#0
	lwpa	
	psha	
	lwia	#28
	popb	
	aequ	
	jpz 	$74
	lwia	#1
	sbma	leftP
	jmp 	$75
$74:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	psha	
	lwia	#30
	popb	
	aadd	
	popb	
	aequ	
	jpz 	$76
	lwia	#0
	sbma	rightP
	jmp 	$77
$76:
	mspa	#0
	lwpa	
	psha	
	lwia	#256
	psha	
	lwia	#28
	popb	
	aadd	
	popb	
	aequ	
	jpz 	$78
	lwia	#0
	sbma	leftP
	jmp 	$79
$78:
	mspa	#0
	lwpa	
	psha	
	lwia	#32
	popb	
	aequ	
	jpz 	$81
	lbma	player_shooting
	alng	
$81:
	aclv	
	jpz 	$80
	lwia	#1
	sbma	player_shooting
	lwma	player_pos
	swma	player_shotX
	lwia	#2
	swma	sound_frames
$80:
$79:
$77:
$75:
$73:
$71:
	mdsp	#2
	ret 	
updatePlayer:
	lwma	player_hit_time
	jpz 	$83
	lwia	#0
	jmp 	$82
$83:
	lbma	leftP
	jpz 	$85
	lwma	player_pos
$85:
	aclv	
	jpz 	$84
	lwma	player_pos
	deca	
	swma	player_pos
$84:
	lbma	rightP
	jpz 	$87
	lwma	player_pos
	psha	
	lwia	#39
	popb	
	ault	
$87:
	aclv	
	jpz 	$86
	lwma	player_pos
	inca	
	swma	player_pos
$86:
$82:
	ret 	
moveEnemies:
	lwma	framecount
	psha	
	lwia	#16
	popb	
	call	ccudiv
	xswp	
	alng	
	jpz 	$89
	lwma	enemyX
	psha	
	lwma	enemyDir
	popb	
	aadd	
	swma	enemyX
	lwma	enemyX
	psha	
	lwia	#10
	psha	
	lwia	#3
	popb	
	amul	
	popb	
	aadd	
	psha	
	lwia	#40
	popb	
	aslt	
	alng	
	jpnz	$91
	lwma	enemyX
	psha	
	lwia	#0
	popb	
	asle	
$91:
	aclv	
	jpz 	$90
	lwma	enemyDir
	aneg	
	swma	enemyDir
	lwma	enemyY
	inca	
	swma	enemyY
$90:
	call	checkLoss
$89:
$88:
	ret 	
moveShot:
	lbma	player_shooting
	jpz 	$94
	lwma	framecount
	psha	
	lwia	#3
	popb	
	call	ccudiv
	xswp	
	alng	
$94:
	aclv	
	jpz 	$93
	lwma	player_shotY
	deca	
	swma	player_shotY
	lwma	player_shotY
	psha	
	lwia	#0
	popb	
	aslt	
	jpz 	$95
	lwia	#0
	sbma	player_shooting
	lwia	#23
	swma	player_shotY
	lwia	#14
	swma	sound_frames
$95:
$93:
$92:
	ret 	
updateShotCollide:
	mdsp	#-2
	lwma	framecount
	psha	
	lwia	#3
	popb	
	call	ccudiv
	xswp	
	alng	
	jpz 	$97
	lwma	player_shotX
	psha	
	lwma	enemyX
	popb	
	aslt	
	alng	
	jpz 	$99
	lwma	player_shotX
	psha	
	lwma	enemyX
	psha	
	lwia	#10
	psha	
	lwia	#3
	popb	
	amul	
	popb	
	aadd	
	popb	
	aslt	
$99:
	aclv	
	jpz 	$100
	lwma	player_shotY
	psha	
	lwma	enemyY
	popb	
	aslt	
	alng	
$100:
	aclv	
	jpz 	$101
	lwma	player_shotY
	psha	
	lwma	enemyY
	psha	
	lwia	#5
	psha	
	lwia	#2
	popb	
	amul	
	popb	
	aadd	
	popb	
	aslt	
$101:
	aclv	
	jpz 	$102
	lwma	player_shotY
	psha	
	lwma	enemyY
	popb	
	asub	
	psha	
	lwia	#1
	popb	
	abnd	
	alng	
$102:
	aclv	
	jpz 	$98
	mspa	#0
	psha	
	lwma	player_shotX
	psha	
	lwma	enemyX
	popb	
	asub	
	psha	
	lwia	#3
	popb	
	call	ccdiv
	popb	
	swqa	
	mspa	#0
	psha	
	lwpa	
	psha	
	lwma	player_shotY
	psha	
	lwma	enemyY
	popb	
	asub	
	psha	
	lwia	#1
	popb	
	assr	
	psha	
	lwia	#10
	popb	
	amul	
	popb	
	aadd	
	popb	
	swqa	
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	alng	
	jpz 	$103
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	psha	
	lwia	#1
	popb	
	sbqa	
	lwia	#0
	sbma	player_shooting
	lwia	#23
	swma	player_shotY
	lwma	player_score
	psha	
	lwia	#10
	popb	
	aadd	
	swma	player_score
	lwia	#7
	swma	sound_frames
	call	checkWin
	call	drawBottomLine
$103:
$98:
$97:
$96:
	mdsp	#2
	ret 	
updateEnemyShot:
	mdsp	#-2
	lwma	framecount
	psha	
	lwia	#4
	popb	
	call	ccudiv
	xswp	
	alng	
	jpz 	$105
	lwma	enemy_shotY
	inca	
	swma	enemy_shotY
	lwma	enemy_shotY
	psha	
	lwia	#23
	popb	
	aequ	
	jpz 	$106
	lwma	enemy_shotX
	psha	
	lwma	player_pos
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	ault	
	alng	
	jpz 	$108
	lwma	enemy_shotX
	psha	
	lwma	player_pos
	psha	
	lwia	#1
	popb	
	aadd	
	popb	
	aule	
$108:
	aclv	
	jpz 	$107
	lwma	player_life
	deca	
	swma	player_life
	lwia	#30
	swma	player_hit_time
	call	drawBottomLine
$107:
	mspa	#0
	psha	
	call	rand
	psha	
	lwia	#10
	popb	
	call	ccdiv
	xswp	
	popb	
	swqa	
	lwma	enemyX
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#3
	popb	
	amul	
	popb	
	aadd	
	swma	enemy_shotX
$109:
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	alng	
	jpz 	$111
	mspa	#0
	lwpa	
	psha	
	lwia	#50
	psha	
	lwia	#10
	popb	
	asub	
	popb	
	ault	
$111:
	aclv	
	jpz 	$110
	mspa	#0
	psha	
	lwpa	
	psha	
	lwia	#10
	popb	
	aadd	
	popb	
	swqa	
	jmp 	$109
$110:
	mspa	#0
	lwpa	
	psha	
	lwia	#10
	popb	
	ault	
	jpz 	$112
	lwia	#1
	aneg	
	swma	enemy_shotX
	jmp 	$113
$112:
	lwia	#2
	swma	sound_frames
$113:
	lwma	enemyY
	psha	
	mspa	#2
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccudiv
	psha	
	lwia	#2
	popb	
	amul	
	popb	
	aadd	
	swma	enemy_shotY
$106:
$105:
$104:
	mdsp	#2
	ret 	
checkWin:
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
$115:
	mspa	#0
	lwpa	
	psha	
	lwia	#50
	popb	
	ault	
	jpnz	$117
	jmp 	$118
$116:
	mspa	#0
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$115
$117:
	lwia	enemy
	psha	
	mspa	#2
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	alng	
	jpz 	$119
	lwia	#0
	jmp 	$114
$119:
	jmp 	$116
$118:
	lwia	#2
	sbma	mode
	lwia	#1
	jmp 	$114
$114:
	mdsp	#2
	ret 	
checkLoss:
	mdsp	#-2
	mdsp	#-2
	mspa	#0
	psha	
	lwia	#0
	popb	
	swqa	
	lwma	player_life
	psha	
	lwia	#0
	popb	
	asle	
	jpz 	$121
	lwia	#3
	sbma	mode
	lwia	#1
	jmp 	$120
$121:
	mspa	#2
	psha	
	lwia	#0
	popb	
	swqa	
$122:
	mspa	#2
	lwpa	
	psha	
	lwia	#50
	popb	
	ault	
	jpnz	$124
	jmp 	$125
$123:
	mspa	#2
	psha	
	lwpa	
	inca	
	popb	
	swqa	
	deca	
	jmp 	$122
$124:
	lwia	enemy
	psha	
	mspa	#4
	lwpa	
	popb	
	aadd	
	lbpa	
	asex	
	alng	
	jpz 	$127
	mspa	#0
	lwpa	
	psha	
	lwma	enemyY
	popb	
	aadd	
	psha	
	lwia	#23
	popb	
	ault	
	alng	
$127:
	aclv	
	jpz 	$126
	lwia	#3
	sbma	mode
	lwia	#1
	jmp 	$120
$126:
	mspa	#2
	lwpa	
	psha	
	lwia	#10
	popb	
	call	ccudiv
	xswp	
	psha	
	lwia	#10
	psha	
	lwia	#1
	popb	
	asub	
	popb	
	aequ	
	jpz 	$128
	mspa	#0
	psha	
	lwpa	
	psha	
	lwia	#2
	popb	
	aadd	
	popb	
	swqa	
$128:
	jmp 	$123
$125:
	lwia	#0
	jmp 	$120
$120:
	mdsp	#4
	ret 	
main:
	call	reset
$130:
	lwia	#1
	jpz 	$131
	lbma	mode
	psha	
	lwia	#0
	popb	
	aequ	
	jpz 	$132
	lwia	#0
	psha	
	lwia	#11
	psha	
	call	outp
	mdsp	#4
	call	drawScreen
	call	drawBottomLine
	lwia	#973
	psha	
	lwia	$0+#20
	psha	
	call	_print_at
	mdsp	#4
	lwia	#1130
	psha	
	lwia	$0+#33
	psha	
	call	_print_at
	mdsp	#4
	call	_key_press_read
	call	reset
	lwia	#1
	sbma	mode
$132:
	lbma	mode
	psha	
	lwia	#1
	popb	
	aequ	
	jpz 	$133
	call	drawScreen
	call	updateKeys
	call	updatePlayer
	call	moveEnemies
	call	moveShot
	call	updateShotCollide
	call	updateEnemyShot
	lwma	sound_frames
	jpz 	$134
	lwma	sound_frames
	deca	
	swma	sound_frames
	jmp 	$135
$134:
	lwia	#0
	psha	
	lwia	#11
	psha	
	call	outp
	mdsp	#4
$135:
	lwma	framecount
	inca	
	swma	framecount
	lwma	framecount
	psha	
	lwia	#15
	popb	
	call	ccudiv
	xswp	
	alng	
	jpz 	$136
	lwma	player_score
	deca	
	swma	player_score
	call	drawBottomLine
$136:
$133:
	lbma	mode
	psha	
	lwia	#2
	popb	
	aequ	
	jpz 	$137
	lwia	#0
	psha	
	lwia	#11
	psha	
	call	outp
	mdsp	#4
	lwia	#960
	swma	_screenpos
	lwma	player_score
	psha	
	lwia	$0+#54
	psha	
	call	printf
	mdsp	#4
	call	_key_press_read
	call	reset
	lwia	#0
	sbma	mode
$137:
	lbma	mode
	psha	
	lwia	#3
	popb	
	aequ	
	jpz 	$138
	lwia	#0
	psha	
	lwia	#11
	psha	
	call	outp
	mdsp	#4
	lwia	#960
	swma	_screenpos
	lwma	player_score
	psha	
	lwia	$0+#103
	psha	
	call	printf
	mdsp	#4
	call	_key_press_read
	call	reset
	lwia	#0
	sbma	mode
$138:
	jmp 	$130
$131:
$129:
	ret 	
;	Data Segment
$0:	.db	#83,#99,#111,#114,#101,#58,#32,#37
	.db	#105,#32,#0,#76,#105,#102,#101,#58
	.db	#32,#37,#105,#0,#83,#67,#80,#32
	.db	#73,#110,#118,#97,#100,#101,#114,#115
	.db	#0,#80,#114,#101,#115,#115,#32,#97
	.db	#32,#107,#101,#121,#32,#116,#111,#32
	.db	#98,#101,#103,#105,#110,#0,#10,#10
	.db	#89,#111,#117,#32,#87,#111,#110,#33
	.db	#32,#83,#99,#111,#114,#101,#58,#32
	.db	#37,#105,#10,#80,#114,#101,#115,#115
	.db	#32,#97,#32,#107,#101,#121,#32,#116
	.db	#111,#32,#112,#108,#97,#121,#32,#97
	.db	#103,#97,#105,#110,#46,#10,#0,#10
	.db	#10,#89,#111,#117,#32,#76,#111,#115
	.db	#116,#33,#32,#83,#99,#111,#114,#101
	.db	#58,#32,#37,#105,#10,#80,#114,#101
	.db	#115,#115,#32,#97,#32,#107,#101,#121
	.db	#32,#116,#111,#32,#112,#108,#97,#121
	.db	#32,#97,#103,#97,#105,#110,#46,#10
	.db	#0
;	extrn	_getcharecho
;	extrn	_getcharshifted
;	extrn	_screenpos
;	globl	enemyDir
enemyDir:
	.dw	#0
;	globl	player_pos
player_pos:
	.dw	#20
;	globl	player_shooting
player_shooting:
	.db	#0
;	globl	player_shotX
player_shotX:
	.dw	#0
;	globl	player_shotY
player_shotY:
	.dw	#23
;	globl	player_life
player_life:
	.dw	#4
;	globl	player_score
player_score:
	.dw	#0
;	globl	player_hit_time
player_hit_time:
	.dw	#0
;	globl	mode
mode:
	.db	#0
;	globl	enemyX
enemyX:
	.dw	#0
;	globl	enemyY
enemyY:
	.dw	#0
;	globl	enemy
enemy:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
;	globl	enemy_shotX
enemy_shotX:
	.dw	#21
;	globl	enemy_shotY
enemy_shotY:
	.dw	#0
;	globl	leftP
leftP:
	.db	#0
;	globl	rightP
rightP:
	.db	#0
;	globl	framecount
framecount:
	.dw	#0
;	globl	sound_frames
sound_frames:
	.dw	#0
;	globl	screen_buf
screen_buf:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
;	globl	buf_pos
buf_pos:
	.dw	#0
;	globl	bufputchar
;	globl	bufblit
;	extrn	outp
;	globl	reset
;	extrn	_screenclear
;	globl	drawScreen
;	globl	drawBottomLine
;	extrn	printf
;	globl	updateKeys
;	extrn	_key_async_read
;	globl	updatePlayer
;	globl	moveEnemies
;	globl	checkLoss
;	globl	moveShot
;	globl	updateShotCollide
;	globl	checkWin
;	globl	updateEnemyShot
;	extrn	rand
;	globl	main
;	extrn	_print_at
;	extrn	_key_press_read

;	0 error(s) in compilation
;	literal pool:153
;	global pool:44
;	Macro pool:51
;	.end
