BIN = bin/scpos

DEPS = \
dev/dev.h 	dev/devices.h 	dev/serial.h 	dev/tty.h	\
lib/kstdio_layer/kstdio_layer.h							\
lib/string/string.h										\
lib/kmalloc/kmalloc.h									\
lib/inout/inout.h lib/inout/__inoutp.h					\
lib/util/util.h											\
fs/disk.h	fs/superblock.h	fs/buffer.h	fs/balloc.h		\
fs/inode.h	fs/file.h	fs/dir.h	fs/fs.h				\
kernel/panic.h											\


OBJS = \
dev/devices.o	dev/serial.o	dev/tty.o				\
lib/kstdio_layer/kstdio_layer.o							\
lib/string/string.o										\
lib/inout/inoutp.o										\
lib/kmalloc/kmalloc.o									\
lib/util/util.o											\
fs/disk.o	fs/superblock.o	fs/buffer.o	fs/balloc.o		\
fs/inode.o	fs/file.o	fs/dir.o	fs/fs.o				\
kernel/panic.o											\
														\
main_test.o	lib/brk_loc/end.o							\


CC = vc

CFLAGS = -c99 -I./include -I.
CFLAGS += -O0 -size


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