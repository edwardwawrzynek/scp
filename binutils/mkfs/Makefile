BIN = ../bin/scpmkfs
DEPS = defs.h

OBJS = main.o

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
