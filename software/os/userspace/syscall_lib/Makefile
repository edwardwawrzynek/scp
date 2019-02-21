BIN = libsyscall.o

HEADERS = \
syscall.h


OBJS = \
syscall_asm.o	syscall_lib.o


CC = vc

CFLAGS = -c99 -I../../include -I../.. -I.
CFLAGS += -O1 -size

LD = scplnk
LDFLAGS =

all: $(BIN)

%.o: %.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(BIN): $(OBJS)
	$(LD) -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)
