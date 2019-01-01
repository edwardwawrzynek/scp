BIN = bin/scpos

DEPS = \
dev/dev.h 	dev/devices.h 	dev/serial.h 	dev/tty.h	\
lib/kstdio_layer/kstdio_layer.h							\
lib/string/string.h										\
lib/kmalloc/kmalloc.h									\
lib/inout/inout.h										\


OBJS = \
dev/devices.o	dev/serial.o	dev/tty.o				\
lib/kstdio_layer/kstdio_layer.o							\
lib/string/string.o										\
lib/inout/inp.o											\
lib/kmalloc/kmalloc.o									\
main_test.o												\


CC = vc

CFLAGS = -c99 -I./include -I.
CFLAGS += -O3 -size


#no need for the os to have a header or split segs on pages
LDFLAGS = -rawbin

all: $(BIN)

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(BIN): $(OBJS)
	$(CC) -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)