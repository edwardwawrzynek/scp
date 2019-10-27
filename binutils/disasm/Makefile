DEPS = asm.h defs.h

OBJS = encodings.o	main.o

%.o: %.c
	makeheaders $<
	$(CC) -g -Wall -c -o $@ $< $(CFLAGS)

.PHONY: scpdisasm

all: scpdisasm

scpdisasm: $(OBJS)
	$(CC) -g -Wall -o ../bin/scpdisasm $(OBJS)

clean:
	rm -f $(OBJS)
