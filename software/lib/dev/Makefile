DEPS = dev.h devices.h serial.h tty.h kstdio_layer.h

OBJS = tty.o serial.o devices.o kstdio_layer.o

CC = vc

CFLAGS = -O3 -size -c99 -nostdlib


%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: ../bin/libdev.o

../bin/libdev.o: $(OBJS)
	$(CC) -o ../bin/libdev.o $(OBJS)

clean:
	rm -f $(OBJS)