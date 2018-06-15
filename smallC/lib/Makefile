.SUFFIXES:      .c .asm

ASSEMS =\
	abs.asm        atoi.asm       binary.asm\
	charclass.asm\
	gets.asm       index.asm\
	itoa.asm       printn.asm\
	puts.asm       reverse.asm    shell.asm\
	strcat.asm     strcmp.asm     strcpy.asm\
	strlen.asm     rand.asm \
	strncat.asm strncmp.asm strncpy.asm

.c.asm:
	../sccscp $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)
