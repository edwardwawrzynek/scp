BIN = ../bin/scplnk
DEPS = lnk.h defs.h

OBJS = main.o obj.o io.o symbols.o decode.o ar.o

CFLAGS = -Wall
LDFLAGS = 


%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) -Wall -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)
