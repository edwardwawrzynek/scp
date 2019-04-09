BIN = \
init test2	test1	ls								\

all: $(BIN)

CC = vc
CFLAGS = -c99 -O1
LDFLAGS = -lc


%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BIN)
