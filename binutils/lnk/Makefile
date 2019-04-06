DEPS = lnk.h defs.h

OBJS = main.o obj.o io.o symbols.o decode.o ar.o

%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) -Wall -c -o $@ $< $(CFLAGS)

all: scplnk

scplnk: $(OBJS)
	$(CC) -Wall -o ../bin/scplnk $(OBJS)

clean:
	rm -f $(OBJS)
