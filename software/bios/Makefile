BIN=bios

OBJS=bios.o

AS=scpasm
LD=scplnk
LDFLAGS=-r -p

all: $(BIN)

%.o: %.asm
	$(AS) -o $@ $<

$(BIN): $(OBJS)
	$(LD) -o $(BIN) $(OBJS) $(LDFLAGS)