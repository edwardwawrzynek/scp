DEPS = asm.h defs.h

OBJS = encodings.o labels.o io.o decode.o main.o obj.o cmds.o defines.o


%.o: %.c $(DEPS)
	makeheaders $<
	vc -c99 -c -o $@ $< $(CFLAGS)

all: scpasm

scpasm: $(OBJS)
	vc -o scpasm $(OBJS) -lc

clean:
	rm -f $(OBJS)
