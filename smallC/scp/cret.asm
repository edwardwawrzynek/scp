;	Runtime start off for smallc on SCP
;	For now, the stack pointer doesn't need to be changed
;	This expects an adequete number of pages have been mapped in to memory on start

;	Call main
	call	main
;	Halt
	.db	#255
