.SUFFIXES:      .c .asm

ASSEMS =\
	putchar.asm	inout.asm	getchar.asm\
	puts.asm	gets.asm	printn.asm\
	printf.asm\

.c.asm:
	scpc -O2 -X $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)
