DEPS = asm.h defs.h 

OBJS = encodings.o labels.o io.o decode.o main.o obj.o

%.o: %.c $(DEPS)
	makeheaders $<
	$(CC) -Wall -c -o $@ $< $(CFLAGS)

all: scpasm

scpasm: $(OBJS)
	$(CC) -Wall -o ../bin/scpasm $(OBJS)

clean:
	rm -f $(OBJS)