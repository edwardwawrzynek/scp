BIN = bin/scpos

HEADERS = \
include/defs.h	include/fs.h	include/io.h			\
include/kernel.h 	include/panic.h	include/proc.h		\
include/stdarg.h	include/stddef.h					\
include/stdint.h	include/lib/inout.h					\
include/lib/__inoutp.h	include/lib/kmalloc.h			\
include/lib/kstdio_layer.h	include/lib/string.h		\
include/lib/util.h										\
dev/dev.h 	dev/devices.h 	dev/serial.h 	dev/tty.h	\
dev/dev_gen.h	dev/pipe.h	dev/special.h				\
lib/kstdio_layer/kstdio_layer.h							\
lib/string/string.h										\
lib/kmalloc/kmalloc.h									\
lib/inout/inout.h lib/inout/__inoutp.h					\
lib/util/util.h											\
fs/disk.h	fs/superblock.h	fs/buffer.h	fs/balloc.h		\
fs/inode.h	fs/file.h	fs/dir.h	fs/fs.h				\
kernel/panic.h	kernel/palloc.h	kernel/mmu.h			\
kernel/mmu_asm.h	kernel/proc.h	kernel/shed.h		\
kernel/context_switch.h	kernel/int_handler.h			\
kernel/context_vars.h	kernel/kernel.h 				\
syscall/handler.h	syscall/test.h	syscall/getpid.h	\
syscall/fork.h	syscall/files.h	syscall/exec.h			\
syscall/chdir.h	syscall/exit.h	syscall/dir.h			\
syscall/brk.h											\


OBJS = \
lib/crt/crt0.o	lib/crt/div.o							\
dev/devices.o	dev/serial.o	dev/tty.o				\
dev/dev_gen.o	dev/pipe.o		dev/special.o			\
lib/kstdio_layer/kstdio_layer.o							\
lib/string/string.o										\
lib/inout/inoutp.o										\
lib/kmalloc/kmalloc.o									\
lib/util/util.o											\
fs/disk.o	fs/superblock.o	fs/buffer.o	fs/balloc.o		\
fs/inode.o	fs/file.o	fs/dir.o	fs/fs.o				\
kernel/panic.o	kernel/palloc.o	kernel/mmu.o			\
kernel/mmu_asm.o	kernel/proc.o	kernel/shed.o		\
kernel/context_switch.o kernel/int_handler.o			\
kernel/context_vars.o	kernel/kernel.o					\
syscall/handler.o	syscall/test.o	syscall/getpid.o	\
syscall/fork.o	syscall/files.o	syscall/exec.o			\
syscall/chdir.o	syscall/exit.o	syscall/dir.o			\
syscall/brk.o											\
														\
main_test.o	lib/brk_loc/end.o							\


CC = vc

CFLAGS = -c99 -I./include -I.
#optimization levels above -O1 are buggy (vbcc, not backend, fault (bug with inode_new: setting ind.disk_blk is optimized to just set blks[0], despite addr of ind later being taken.))
CFLAGS += -O1 -size

LD = scplnk
#no need for the os to have a header or split segs on pages
LDFLAGS = -r -p

all: $(BIN)

%.o: %.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(BIN): $(OBJS)
	$(LD) -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)
