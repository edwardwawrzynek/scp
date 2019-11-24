BIN=bios
MIN_BIN=bios_min

OBJS=bios_spacer.o bios.o

AS=scpasm
LD=scplnk
LDFLAGS=-r -p -S

all: $(BIN) $(MIN_BIN)

%.o: %.asm
	$(AS) -o $@ $<

$(BIN): $(OBJS)
	$(LD) -o $(BIN) $(OBJS) $(LDFLAGS)

$(MIN_BIN): $(OBJS)
	$(LD) -o $(MIN_BIN) bios.o $(LDFLAGS)
