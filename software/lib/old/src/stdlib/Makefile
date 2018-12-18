.SUFFIXES:      .c .asm

ASSEMS =\
	abs.asm\
	atoi.asm\
	itoa.asm\
	rand.asm\
	reverse.asm\
	isdigit.asm\
	strlen.asm\

.c.asm:
	scpc -O2 -X $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)
