;	SCPASM test
	.module	SCP_TEST
start:
	nop 	
	lwia	DATA_SEG+#5
DATA_SEG:
$1:
	.dw	#-1243,#23,#12
$2:
	.db	#5,#6,#7
END:
;	.end
	.module	TEST2
	lwma	$1
$1:
	.db	#255
