;	SCPASM test
	.module	SCP_TEST
start:
	nop 	
	lwia	#-345
	lbmb	$2
	swmb	$1
	lwma	$1
DATA_SEG:
$1:
	.dw	#-1243,#23
$2:
	.db	#5
END:
;	.end
	.module	TEST2
	lwma	$1
$1:
	.db	#255
