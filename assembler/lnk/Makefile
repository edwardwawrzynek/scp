DEPS = lnk.h defs.h

OBJS = main.o obj.o io.o symbols.o

%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) -g -Wall -c -o $@ $< $(CFLAGS)

all: scplnk

scplnk: $(OBJS)
	$(CC) -g -Wall -o ../bin/scplnk $(OBJS)

clean:
	rm -f $(OBJS)