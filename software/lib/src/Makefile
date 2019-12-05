include gmsl

# TARGET specifies that type of libraries to produce
# ARCHIVE - archive libraries
# OBJECT - object libraries
# NDEBUG - archives with NDEBUG defined

ifndef TARGET
	TARGET=ARCHIVE
endif

# Target bin folders
ARCHIVE_DIR = ../bin/
OBJECT_DIR = ../bin/obj_bin/
NDEBUG_DIR = ../bin/ndebug/

# C Runtime
CRT_NAME = crt0

CRT_OBJS =\
crt/crt0.o	crt/div.o

# C Library
LIBC_NAME = libc

LIBC_OBJS = \
stdio/_file_open.o	stdio/_file_buf.o	stdio/fseek.o		\
stdio/fileno.o			\
stdio/fputs.o	stdio/_init_stdio.o	stdio/fputc.o			\
stdio/fgetc.o	stdio/fgets.o	stdio/fread.o				\
stdio/fwrite.o stdio/printf.o	stdio/remove.o				\
stdio/rename.o	stdio/scanf.o	stdio/perror.o			\
																			\
stdlib/abs.o	stdlib/itoa.o	stdlib/malloc.o	stdlib/strtol.o				\
stdlib/qsort.o																\
																			\
ctype/isalnum.o	ctype/isalpha.o ctype/isblank.o	ctype/iscntrl.o				\
ctype/isdigit.o	ctype/isgraph.o	ctype/islower.o	ctype/isprint.o				\
ctype/ispunc.o 	ctype/isspace.o	ctype/isupper.o	ctype/isxdigit.o			\
ctype/tolower.o	ctype/toupper.o												\
																			\
string/memchr.o	string/memcmp.o	string/memcpy.o	string/memmove.o			\
string/memset.o	string/strcat.o	string/strchr.o	string/strcpy.o				\
string/strcspn.o	string/strlen.o	string/strncat.o	string/strnchr.o	\
string/strncmp.o	string/strncpy.o	string/strnlen.o					\
string/strpbrk.o	string/strrchr.o	string/strspn.o	string/strstr.o		\
string/strcmp.o		string/strerror.o	string/strdup.o										\
																			\
syscall/syscall_asm.o	syscall/syscall_lib.o	syscall/getopt.o			\
\
setjmp/setjmp.o\

#inp and outp (seperate from libc)
INOUTP_NAME = libinout

INOUTP_OBJS = \
inout/inoutp.o

#gfx library
GFX_NAME = libgfx

GFX_OBJS = \
gfx/gfx.o gfx/gfx_asm.o

# C compiler options
CC = vc

CFLAGS = -c99

CFLAGS += -O1 -size

ifeq ($(TARGET),NDEBUG)
	CFLAGS += -DNDEBUG
endif

LDFLAGS =

LD = scplnk

%.o: %.c $(LIBC_HEADERS) $(CRT_HEADERS) $(INOUTP_HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.asm
	$(CC) -c -o $@ $< $(CFLAGS)

define make-target
	$(1) = $(2)/$(3)
endef

define make-lib-link
$(1): $(2)
	$(LD) -o $(1) $(2) $(LDFLAGS)
endef

ifeq ($(TARGET),ARCHIVE)
	BIN_DIR = $(ARCHIVE_DIR)
	BIN_END=a
endif

ifeq ($(TARGET),OBJECT)
	BIN_DIR = $(OBJECT_DIR)
	BIN_END=o
endif

ifeq ($(TARGET),NDEBUG)
	BIN_DIR = $(NDEBUG_DIR)
	BIN_END=a
endif


define make-lib-from-name
	$(eval $(call make-lib-link,$(BIN_DIR)$1.$(BIN_END),$2))
endef

all: $(BIN_DIR)$(CRT_NAME).$(BIN_END) $(BIN_DIR)$(LIBC_NAME).$(BIN_END) $(BIN_DIR)$(INOUTP_NAME).$(BIN_END) $(BIN_DIR)$(GFX_NAME).$(BIN_END)

$(call make-lib-from-name,$(CRT_NAME),$(CRT_OBJS))
$(call make-lib-from-name,$(LIBC_NAME),$(LIBC_OBJS))
$(call make-lib-from-name,$(INOUTP_NAME),$(INOUTP_OBJS))
$(call make-lib-from-name,$(GFX_NAME),$(GFX_OBJS))

clean:
	rm -f $(LIBC_OBJS) $(CRT_OBJS) $(INOUTP_OBJS) $(GFX_OBJS)

.PHONY: configure

configure:
	ln -sf `pwd`/../include/syscall.h `pwd`/../include/unistd.h
