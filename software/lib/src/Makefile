# C Runtime
CRT_BIN = ../bin/crt0.a

CRT_HEADERS =

CRT_OBJS =\
crt/crt0.o	crt/div.o

# C Library
LIBC_BIN = ../bin/libc.a

LIBC_HEADERS =

LIBC_OBJS = \
stdio/_file_open.o	stdio/_file_buf.o	stdio/fseek.o		\
stdio/fileno.o			\
stdio/fputs.o	stdio/_init_stdio.o	stdio/fputc.o			\
stdio/fgetc.o	stdio/fgets.o	stdio/fread.o				\
stdio/fwrite.o stdio/printf.o	stdio/remove.o				\
stdio/rename.o	stdio/scanf.o	stdio/perror.o			\
																			\
stdlib/abs.o	stdlib/itoa.o	stdlib/malloc.o	stdlib/strtol.o				\
stdlib/qsort.o																\
																			\
ctype/isalnum.o	ctype/isalpha.o ctype/isblank.o	ctype/iscntrl.o				\
ctype/isdigit.o	ctype/isgraph.o	ctype/islower.o	ctype/isprint.o				\
ctype/ispunc.o 	ctype/isspace.o	ctype/isupper.o	ctype/isxdigit.o			\
ctype/tolower.o	ctype/toupper.o												\
																			\
string/memchr.o	string/memcmp.o	string/memcpy.o	string/memmove.o			\
string/memset.o	string/strcat.o	string/strchr.o	string/strcpy.o				\
string/strcspn.o	string/strlen.o	string/strncat.o	string/strnchr.o	\
string/strncmp.o	string/strncpy.o	string/strnlen.o					\
string/strpbrk.o	string/strrchr.o	string/strspn.o	string/strstr.o		\
string/strcmp.o		string/strerror.o	string/strdup.o										\
																			\
syscall/syscall_asm.o	syscall/syscall_lib.o	syscall/getopt.o			\
\
setjmp/setjmp.o\

#inp and outp (seperate from libc)
INOUTP_BIN = ../bin/libinout.a

INOUTP_HEADERS = \
inout/inout.h

INOUTP_OBJS = \
inout/inoutp.o

#gfx library
GFX_BIN = ../bin/libgfx.a

GFX_HEADERS =

GFX_OBJS = \
gfx/gfx.o gfx/gfx_asm.o

# C compiler options
CC = vc

CFLAGS = -c99

CFLAGS += -O1 -size

LDFLAGS =

LD = scplnk

all: $(LIBC_BIN) $(CRT_BIN) $(INOUTP_BIN) $(GFX_BIN)

%.o: %.c $(LIBC_HEADERS) $(CRT_HEADERS) $(INOUTP_HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm
	$(CC) -c -o $@ $< $(CFLAGS)

$(LIBC_BIN): $(LIBC_OBJS)
	$(LD) -o $(LIBC_BIN) $(LIBC_OBJS) $(LDFLAGS)

$(CRT_BIN): $(CRT_OBJS)
	$(LD) -o $(CRT_BIN) $(CRT_OBJS) $(LDFLAGS)

$(INOUTP_BIN): $(INOUTP_OBJS)
	$(LD) -o $(INOUTP_BIN) $(INOUTP_OBJS) $(LDFLAGS)

$(GFX_BIN): $(GFX_OBJS)
	$(LD) -o $(GFX_BIN) $(GFX_OBJS) $(LDFLAGS)

clean:
	rm -f $(LIBC_OBJS) $(CRT_OBJS) $(INOUTP_OBJS) $(GFX_OBJS)

.PHONY: configure

configure:
	ln -sf `pwd`/../include/syscall.h `pwd`/../include/unistd.h
