# C Runtime
CRT_BIN = ../bin/crt0.o

CRT_HEADERS =

CRT_OBJS =\
crt/crt0.o	crt/div.o

# C Library
LIBC_BIN = ../bin/libc.o

LIBC_HEADERS =

LIBC_OBJS = \
ctype/ctype.o	stdio/stdio.o	stdlib/stdlib.o	string/string.o	\
syscall/syscall_asm.o	syscall/syscall_lib.o	\

#inp and outp (seperate from libc)
INOUTP_BIN = ../bin/libinout.o

INOUTP_HEADERS = \
inout/inout.h

INOUTP_OBJS = \
inout/inoutp.o

# C compiler options
CC = vc

CFLAGS = -c99

CFLAGS += -O1 -size

LDFLAGS =

all: $(LIBC_BIN) $(CRT_BIN) $(INOUTP_BIN)

%.o: %.c $(LIBC_HEADERS) $(CRT_HEADERS) $(INOUTP_HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm
	$(CC) -c -o $@ $< $(CFLAGS)

$(LIBC_BIN): $(LIBC_OBJS)
	$(CC) -o $(LIBC_BIN) $(LIBC_OBJS) $(LDFLAGS)

$(CRT_BIN): $(CRT_OBJS)
	$(CC) -o $(CRT_BIN) $(CRT_OBJS) $(LDFLAGS)

$(INOUTP_BIN): $(INOUTP_OBJS)
	$(CC) -o $(INOUTP_BIN) $(INOUTP_OBJS) $(LDFLAGS)

clean:
	rm -f $(LIBC_OBJS) $(CRT_OBJS) $(INOUTP_OBJS)
