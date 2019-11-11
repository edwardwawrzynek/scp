BIN = \
pong	\

all: $(BIN)

CC = vc
CFLAGS = -c99 -O2
LDFLAGS = -lc -lgfx

%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BIN)
