#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

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

struct stat file_stat;

void do_rm(char * path) {
  if(stat(path, &file_stat) == -1) {
      fprintf(stderr, "rm: can't stat %s: ", path);
      perror(NULL);
      exit(1);
    }
    if(S_ISDIR(file_stat.st_mode)) {
      /* handle dir and recursive flag */
      if(!r_flag) {
        fprintf(stderr, "rm: can't remove %s: is a directory\n", path);
        exit(1);
      }
      uint16_t dir = opendir(path);
      if(dir == -1) {
        fprintf(stderr, "rm: can't open directory %s: ", path);
        perror(NULL);
        exit(1);
      }

      struct dirent entry;
      while(readdir(dir, &entry) > 0) {
        if(!strcmp(entry.name, "..")) continue;
        if(!strcmp(entry.name, ".")) continue;

        char * new_path = malloc(strlen(path) + strlen(entry.name) + 2);
        sprintf(new_path, "%s/%s", path, entry.name);
        printf("%s\n", new_path);
        do_rm(new_path);
        free(new_path);
      }
      closedir(dir);

      if(rmdir(path) == -1) {
        fprintf(stderr, "rm: can't remove directory %s: ", path);
        perror(NULL);
        exit(1);
      }
      
    } else {
      if(unlink(path) == -1) {
        fprintf(stderr, "rm: can't unlink %s: ", path);
        perror(NULL);
        exit(1);
      }
    }
}

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

  for(;optind<argc;optind++) {
    do_rm(argv[optind]);
  }
}