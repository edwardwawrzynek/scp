#include <stdio.h>
#include <unistd.h>

/**
 * SCP rm
 * flags:
 * -r do a recursive removal
 * -h print help
 */

void usage() {
  fprintf(stderr, "usage: rm [options] files\noptions:\n-r\t:recursive remove\n-h\tprint usage\n");
  exit(1);
}

uint8_t r_flag = 0;

int main(int argc, char **argv) {
  int i;
  while((i = getopt(argc, argv, "rh")) != -1){
    switch(i){
      case 'r':
        r_flag = 1;
        break;
      case 'h':
      default:
        usage();
    }
  }

  struct stat file_stat;

  for(;optind<argc;optind++) {
    if(stat(argv[optind], &file_stat) == -1) {
      fprintf(stderr, "rm: can't stat %s: ", argv[optind]);
      perror(NULL);
      exit(1);
    }
    if(S_ISDIR(file_stat.st_mode)) {
      /* handle dir and recursive flag */
      if(!r_flag) {
        fprintf(stderr, "rm: can't remove %s: is a directory\n", argv[optind]);
        exit(1);
      }
    } else {
      if(unlink(argv[optind]) == -1) {
        fprintf(stderr, "rm: can't unlink %s: ", argv[optind]);
        perror(NULL);
        exit(1);
      }
    }
  }
}