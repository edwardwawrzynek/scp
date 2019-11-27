SUBDIRS = binutils emulator software

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS) vbcc

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: vbcc
vbcc: binutils
	$(MAKE) -C vbcc bin/vc && $(MAKE) -C vbcc TARGET=scp bin/vbccscp

software: vbcc binutils

all: subdirs
