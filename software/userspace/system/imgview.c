#include <unistd.h>
#include <gfx.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * basic image viewer program
 * displays raw images, set background colors, etc */

void usage(){
  fprintf(stderr, "usage: imgview [options] [files]\noptions:\n-b\t\t:set background (return right away)\n-c color\t:set background to solid color\n-h\t\t:display help\n");
  exit(1);
}
 
uint8_t do_wait = 1;

char buf[320];

void do_img(int16_t fd, gfx_t * window) {
  uint16_t y = 0;
  uint16_t num_read;
  do {
    num_read = read(fd, buf, 320);
    for(uint16_t x = 0; x < num_read; x++) {
      gfx_pixel(window, x, y, buf[x]);
    }
    y++;
    if(y >= 200) break;
  } while(num_read == 320);
}

int main(int argc, char ** argv) {
  int i;
  uint8_t do_color = 0;
  int color = 0;
  while((i = getopt(argc, argv, "bc:h")) != -1){
      switch(i){
          case 'b':
            do_wait = 0;
            break;
          case 'c':
            do_color = 1;
            color = strtol(optarg, NULL, 10);
            break;
          case 'h':
          default:
            usage();
      }
  }

  if(optind >= argc && !do_color){
    usage();
  }

  gfx_t * window = gfx_new_window();

  if(do_color) {
    gfx_background(window, color);
    if(do_wait)
      getchar();
  } else {
    for(;optind<argc;optind++){
      int fd = open(argv[optind], O_RDONLY);
      if(fd == -1) {
        gfx_exit(window);
        fprintf(stderr, "imgview: can't open file %s: ", argv[optind]);
        perror(NULL);
        exit(1);
      }
      do_img(fd, window);
      close(fd);
      if(do_wait)
        getchar();
    }
  }

  gfx_exit(window);
  return 0;
}