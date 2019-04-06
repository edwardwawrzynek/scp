DEPS = object.h

OBJS = main.o obj.o

%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) -Wall -c -o $@ $< $(CFLAGS)

all: scpsize

scpsize: $(OBJS)
	$(CC) -Wall -o ../bin/scpsize $(OBJS)

clean:
	rm -f $(OBJS)
