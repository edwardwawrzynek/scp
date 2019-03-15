all: test1 test2 mandelbrot

CC = vc
CFLAGS = -c99 -O0
LDFLAGS = -linout -lc

test1: test1.c
	$(CC) $(CFLAGS) -o test1 test1.c $(LDFLAGS)

test2: test2.c
	$(CC) $(CFLAGS) -o test2 test2.c $(LDFLAGS)

mandelbrot: mandelbrot.c
	$(CC) $(CFLAGS) -o mandelbrot mandelbrot.c $(LDFLAGS)
