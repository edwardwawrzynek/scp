;	Unsigned divide A=A/B, B=A%B
ccudiv:
	mdsp	#-10
;
	pshb	
	xswp	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
;	
	mspa	#8
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#6
	psha	
	lwia	#0
	popb	
	swqa	
	mspa	#4
	psha	
	lwia	#15
	popb	
	swqa	
ccudiv_2:
	mspa	#4
	lwpa	
	psha	
	lwia	#1
	popb	
	aadd	
	jpnz	ccudiv_4
	jmp 	ccudiv_5
ccudiv_3:
	mspa	#4
	psha	
	lwpa	
	deca	
	popb	
	swqa	
	jmp 	ccudiv_2
ccudiv_4:
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#1
	popb	
	ashl	
	popb	
	swqa	
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	lwia	#4094
	popb	
	abnd	
	psha	
	mspa	#6
	lwpa	
	psha	
	lwia	#1
	psha	
	mspa	#12
	lwpa	
	popb	
	ashl	
	popb	
	abnd	
	psha	
	mspa	#10
	lwpa	
	popb	
	ashr	
	popb	
	aadd	
	popb	
	swqa	
	mspa	#6
	lwpa	
	psha	
	mspa	#2
	lwpa	
	popb	
	ault	
	alng	
	jpz 	ccudiv_6
	mspa	#6
	psha	
	mspa	#8
	lwpa	
	psha	
	mspa	#4
	lwpa	
	popb	
	asub	
	popb	
	swqa	
	mspa	#8
	psha	
	mspa	#10
	lwpa	
	psha	
	lwia	#1
	psha	
	mspa	#10
	lwpa	
	popb	
	ashl	
	popb	
	abor	
	popb	
	swqa	
ccudiv_6:
	jmp 	ccudiv_3
ccudiv_5:
	mspa	#6
	lwpa	
	xswp	
	mspa	#8
	lwpa	
ccudiv_1:
	mdsp	#10
	ret 	
;	Signed divide
ccdiv:
	mdsp	#-6
;
	pshb	
	xswp	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
;	
	nop 	
	mspa	#5
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#4
	psha	
	lwia	#0
	popb	
	sbqa	
	mspa	#2
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	jpz 	ccdiv_2
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
	mspa	#5
	psha	
	lbpa	
	psha	
	lwia	#1
	popb	
	abxr	
	popb	
	sbqa	
	mspa	#4
	psha	
	lwia	#1
	popb	
	sbqa	
ccdiv_2:
	mspa	#0
	lwpa	
	psha	
	lwia	#32768
	popb	
	abnd	
	jpz 	ccdiv_3
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	aneg	
	popb	
	swqa	
	mspa	#5
	psha	
	lbpa	
	psha	
	lwia	#1
	popb	
	abxr	
	popb	
	sbqa	
ccdiv_3:
	mspa	#2
	lwpa	
	xswp	
	mspa	#0
	lwpa	
	call	ccudiv
;	Store b
	psha	
	mspa	#2
	swpb	
	popb	
	mspa	#2
	swpb	
	mspa	#5
	lbpa	
	jpz 	ccdiv_4
	mspa	#2
	psha	
	mspa	#4
	lwpa	
	aneg	
	popb	
	swqa	
ccdiv_4:
	mspa	#4
	lbpa	
	jpz 	ccdiv_5
	mspa	#0
	psha	
	mspa	#2
	lwpa	
	aneg	
	popb	
	swqa	
ccdiv_5:
	mspa	#0
	lwpa	
	xswp	
	mspa	#2
	lwpa	
ccdiv_1:
	mdsp	#6
	ret 	
