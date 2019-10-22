all: gfx_test1 gfx_test2 mandelbrot

CC = vc
CFLAGS = -c99 -O0
LDFLAGS = -linout -lc

gfx_test1: gfx_test1.c
	$(CC) $(CFLAGS) -o gfx_test1 gfx_test1.c $(LDFLAGS)

gfx_test2: gfx_test2.c
	$(CC) $(CFLAGS) -o gfx_test2 gfx_test2.c $(LDFLAGS)

mandelbrot: mandelbrot.c
	$(CC) $(CFLAGS) -o mandelbrot mandelbrot.c $(LDFLAGS)
