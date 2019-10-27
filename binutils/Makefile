SUBDIRS = asm lnk mif_conv size disasm

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: configure install uninstall
configure:
	mkdir bin; \
	ln -sf `pwd`/obj/object.h asm/object.h; \
	ln -sf `pwd`/obj/obj.c asm/obj.c; \
	ln -sf `pwd`/obj/object.h lnk/object.h; \
  ln -sf `pwd`/obj/obj.c lnk/obj.c; \
	ln -sf `pwd`/obj/object.h size/object.h; \
  ln -sf `pwd`/obj/obj.c size/obj.c;	\
	ln -sf `pwd`/../software/userspace/system/serial/serial.h ftp/serial.h; 	

install:
	ln -sf `pwd`/bin/scpasm ~/.local/bin/; \
	ln -sf `pwd`/bin/scplnk ~/.local/bin/; \
	ln -sf `pwd`/bin/scpmif ~/.local/bin/; \
	ln -sf `pwd`/bin/scpsize ~/.local/bin/; \
	ln -sf `pwd`/bin/scpftp ~/.local/bin;	\
	ln -sf `pwd`/bin/scpdisasm ~/.local/bin; 

uninstall:
	rm ~/.local/bin/scpasm; \
	rm ~/.local/bin/scplnk; \
	rm ~/.local/bin/scpmif; \
	rm ~/.local/bin/scpsize; \
	rm ~/.local/bin/scpftp;	\
	rm ~/.local/bin/scpdisasm

all: subdirs
