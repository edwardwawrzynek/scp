all: scpemu

OBJS = cpu.o main.o debug.o io/io.o io/serial.o io/gfx.o io/gfx_charset.o io/disk.o io/sysinfo.o

DEPS = cpu.h debug.h opcodes.h io/gfx.h io/io.h io/ports.h io/serial.h io/disk.h

%.o: %.cpp $(DEPS)
	g++ -std=c++11 -O3 -Wall -c -o $@ $<

scpemu: $(OBJS)
	g++ -O3 -std=c++11 -g -o scpemu -Wall $(OBJS) -lserialport -lSDL2

.PHONY: install uninstall

install:
	ln -s `pwd`/scpemu ~/.local/bin/

uninstall:
	rm ~/.local/bin/scpemu

clean:
	rm -f $(OBJS)
