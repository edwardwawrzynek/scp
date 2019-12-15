#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
/**
 * SCP hexdump utility
 * non-standard conforming, basically just does hexdump -C */

void print_usage() {
  fprintf(stderr, "usage: hd [options] [files]\nOptions:\n-h\tprint help\n");
  exit(1);
}

void print_file(FILE *f) {
  /* sixteen bytes per line */
  uint8_t buf[16];
  uint16_t address = 0;
  uint16_t bytes_read;

  do {
    bytes_read = fread(buf, 1, 16, f);
    printf("%04x  ", address);
    for(int i = 0; i < 16; i++) {
      if(i == 8)          printf(" ");
      if(i < bytes_read)  printf("%02x ", buf[i]);
      else                printf("   ");
    }
    printf(" |");
    for(int i = 0; i < bytes_read; i++) {
      if(isprint(buf[i])) putchar(buf[i]);
      else                putchar('.');
    }
    printf("|\n");
    address += 16;
  } while(bytes_read == 16);

}

int main(int argc, char **argv) {
  printf("command: %s %s\n", argv[0], argv[1]);
  int i;
  while((i = getopt(argc, argv, "h")) != -1){
      switch(i){
          case 'h':
          default:
              print_usage();
              break;
      }
  }

  if(optind >= argc){
    print_file(stdin);
  }

  for(;optind<argc;optind++){
    FILE * f = fopen(argv[optind], "r");
    if(f == NULL) {
      fprintf(stderr, "hd: error opening file %s: ", argv[optind]);
      perror(NULL);
      exit(1);
    }
    print_file(f);
    fclose(f);
  }

  return 0;
}