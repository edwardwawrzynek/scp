ASSEMS =\
	lib/getchar.s	lib/gets.s	lib/inout.s	lib/kmalloc.s	lib/printf.s	lib/printn.s	lib/putchar.s	lib/serial.s	lib/string.s\
	fs/disk.s	fs/buffer.s	fs/balloc.s	fs/superblock.s	fs/inode.s	fs/file.s	fs/dir.s	fs/fs.s\
	kernel/panic.s	kernel/mmu.s	kernel/palloc.s	kernel/proc.s	kernel/kernel.s	kernel/int_handler.s	kernel/shed.s

HEADERS =\
	lib/getchar.h	lib/gets.h	lib/inout.h	lib/kmalloc.h	lib/printf.h	lib/printn.h	lib/putchar.h	lib/serial.h	lib/string.h\
	fs/disk.h	fs/buffer.h	fs/balloc.h	fs/superblock.h	fs/inode.h	fs/file.h	fs/dir.h	fs/fs.h\
	kernel/panic.h	kernel/mmu.h	kernel/palloc.h	kernel/proc.h	kernel/kernel.h kernel/int_handler.h	kernel/shed.h

INCL_HEADERS =\
	lib/incl.h	fs/incl.h	kernel/incl.h

TOOLS = tools/*.s

MAIN = main_test.s

all: a.out

a.out: $(HEADERS) $(INCL_HEADERS) $(ASSEMS) $(MAIN)
	scpc -v -l kernel/kernel_start.s -l ~/scp_software/lib/include/crun.s -a out.s -f kernel/brk_init.s -c $(ASSEMS) $(MAIN)

$(ASSEMS) $(MAIN) $(TOOLS): %.s: %.c
	scpc -X $<

$(HEADERS): %.h: %.c
	rm -f $@;\
	makeheaders $<

$(INCL_HEADERS): $(HEADERS)
	rm -f $@;\
	cat $$(echo $@ | cut -d "/" -f 1)/*.h > $@
