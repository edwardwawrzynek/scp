
BIN	:= zforth
SRC	:= main.c zforth.c

OBJS    := $(subst .c,.o, $(SRC))
DEPS    := $(subst .c,.d, $(SRC))

CC	:= vc

VPATH   := ../zforth
CFLAGS	+= -I. -I../zforth
CFLAGS  += -O2 -c99
LDFLAGS	+= -g 

LIBS	+= -lc

$(BIN): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(BIN) $(OBJS) $(DEPS)

-include $(DEPS)

