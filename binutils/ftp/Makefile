BIN = ../bin/scpftp
DEPS = serial.h

OBJS = host.c

CFLAGS = -Wall
LDFLAGS = -lserialport


%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) -Wall -o $(BIN) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)

