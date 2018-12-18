SUBDIRS = asm lnk mif_conv

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

all: $(SUBDIRS)