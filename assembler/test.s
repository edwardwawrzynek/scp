;	SCPASM test
	.module	SCP_TEST
start:
	nop 	
	lwia	#-345
	lwmb	$1+2
	swmb	$1
	lwma	$1
DATA_SEG:
$1:
	.dw	#-1243,#23
	.db	#5
;	.end
