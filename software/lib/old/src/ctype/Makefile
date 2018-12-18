.SUFFIXES:      .c .asm

ASSEMS =\
	charclass.asm

.c.asm:
	scpc -X -O2 $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)
