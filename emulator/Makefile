all: scpemu

OBJS = cpu.o main.o io/io.o io/serial.o io/gfx.o io/gfx_charset.o io/disk.o

DEPS = cpu.h opcodes.h io/gfx.h io/io.h io/ports.h io/serial.h io/disk.h

%.o: %.cpp $(DEPS)
	g++ -std=c++11 -O3 -Wall -c -o $@ $<

scpemu: $(OBJS)
	g++ -O3 -std=c++11 -o scpemu -Wall $(OBJS) -lserialport -lSDL2

clean:
	rm -f $(OBJS)