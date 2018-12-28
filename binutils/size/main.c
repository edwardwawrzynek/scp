#include "object.h"
#include "obj.h"

void usage(){
  printf("Usage: scpsize files\n");
}

struct obj_file obj;
FILE *file;

int main(int argc, char *argv[]){
  printf("seg 0\tseg 1\tseg 2\tseg 3\ttotal\tfile\n");
  /* go through each file */
  for(int i = 1; i < argc; i++){
    file = fopen(argv[i], "r");
    if(!file){
      printf("scpsize: error: no such file %s\n", argv[i]);
      exit(1);
    }

    /* init object */
    obj_init(&obj);
    obj.file = file;

    obj_read_header(&obj);

    /* print out information */
    printf("%u\t%u\t%u\t%u\t%u\t%s\n", obj.segs.segs[0].size/2, obj.segs.segs[1].size/2, obj.segs.segs[2].size/2, obj.segs.segs[3].size/2, (obj.segs.segs[0].size + obj.segs.segs[1].size + obj.segs.segs[2].size + obj.segs.segs[3].size)/2, argv[i]);
  }

}