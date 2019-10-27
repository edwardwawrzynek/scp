DEPS = asm.h defs.h

OBJS = encodings.o labels.o io.o decode.o main.o obj.o cmds.o defines.o


%.o: %.c $(DEPS)
	makeheaders $<
	vc -c99 -c -o $@ $< $(CFLAGS)

all: scpasm

scpasm: $(OBJS)
	scplnk -L/home/edward/Documents/scp/software/lib/bin/ /home/edward/Documents/scp/software/lib/bin/crt0.a -o scpasm $(OBJS) -lc -D scpasm.debug

clean:
	rm -f $(OBJS)
