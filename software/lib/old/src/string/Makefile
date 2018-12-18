.SUFFIXES:      .c .asm

ASSEMS =\
	binary.asm	shell.asm\
	strlen.asm\
	strcat.asm	strcmp.asm	strcpy.asm	strchr.asm	strstr.asm\
	strncat.asm	strncmp.asm	strncpy.asm\
			memcmp.asm	memcpy.asm	memchr.asm	memset.asm\

.c.asm:
	scpc -O2 -X $*.c
	mv $*.s $*.asm

all:    $(ASSEMS)
	scplnk lib.s $(ASSEMS)
