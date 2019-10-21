BIN = \
init start_user	test1	ls	mkdir	cat	clear sh						\

all: $(BIN)

CC = vc
CFLAGS = -c99 -O2
LDFLAGS = -lc


%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
#	vbccscp -c99 -O=991 -I/home/edward/scp/software/lib/include $<
#	scpasm $@.asm -o $@.o
#	scplnk -S -L/home/edward/scp/software/lib/bin/ /home/edward/scp/software/lib/bin/crt0.a $@.o -o $@ -lc -D $@.debug


clean:
	rm -f $(BIN)
