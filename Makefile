SUBDIRS = binutils emulator software

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

vbcc: binutils
	$(MAKE) -C vbcc bin/vc && $(MAKE) -C vbcc TARGET=scp bin/vbccscp

all: vbcc $(SUBDIRS)