BIN = ../bin/scpsize
DEPS = object.h

OBJS = main.o obj.o

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
