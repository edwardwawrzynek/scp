BIN = \
init	test1	test2									\

all: $(BIN)

CC = vc
CFLAGS = -c99 -O0
LDFLAGS = -linout -lc -lsyscall -L../syscall_lib/ -I../syscall_lib

%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BIN)
