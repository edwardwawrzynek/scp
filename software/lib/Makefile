SUBDIRS = crt inout test

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

inout: crt
test: inout crt

all: subdirs