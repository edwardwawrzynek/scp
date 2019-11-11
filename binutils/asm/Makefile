BIN = ../bin/scpasm
DEPS = asm.h defs.h

OBJS = encodings.o labels.o io.o decode.o main.o obj.o cmds.o defines.o

CFLAGS = -Wall -g
LDFLAGS = -g


%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) -Wall -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)
