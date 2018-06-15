.SUFFIXES:      .c .asm

ASSEMS =\
	putchar.asm	inout.asm    getchar.asm

.c.asm:
	../sccscp $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)