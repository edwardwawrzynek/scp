DEPS = \
dev/dev.h 	dev/devices.h 	dev/serial.h 	dev/tty.h	\
lib/kstdio_layer/kstdio_layer.h

OBJS = \
dev/devices.o	dev/serial.o	dev/tty.o				\
lib/kstdio_layer/kstdio_layer.o							\
main_test.c

CC = vc

CFLAGS = -c99 -I.
CFLAGS += -O3 -size

CFLAGS += -linout

all: a.out

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

a.out: $(OBJS)
	$(CC) -o a.out $(OBJS) $(CFLAGS)

clean:
	rm -f $(OBJS)