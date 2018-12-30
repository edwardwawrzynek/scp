SUBDIRS = crt inout test dev libc

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

inout: crt
test: inout crt

all: subdirs