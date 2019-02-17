all: ../bin/libc.o

SUBDIRS = ctype string stdlib stdio

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

OBJS = bin/ctype.o bin/string.o bin/stdlib.o bin/stdio.o

../bin/libc.o: $(OBJS) subdirs
	vc -o ../bin/libc.o $(OBJS)
