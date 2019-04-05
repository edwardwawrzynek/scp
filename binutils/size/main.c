#include "object.h"
#include "obj.h"
#include <unistd.h>

void usage(){
  printf("Usage: scpsize files\n");
}

uint32_t seg_sum[4];
uint32_t sum;
uint32_t files;

/* print size info for object file */
void do_obj(struct obj_file *obj, char * name){
  printf("%u\t%u\t%u\t%u\t%u\t%s\n", obj->segs.segs[0].size/2, obj->segs.segs[1].size/2, obj->segs.segs[2].size/2, obj->segs.segs[3].size/2, (obj->segs.segs[0].size + obj->segs.segs[1].size + obj->segs.segs[2].size + obj->segs.segs[3].size)/2, name);
  for(int i = 0; i < 4; i++){
    seg_sum[i] += obj->segs.segs[i].size/2;
    sum += obj->segs.segs[i].size/2;
  }
  files++;
}

static uint16_t ar_read_word(FILE *f){
    return fgetc(f) + (fgetc(f)<<8);
}

/* check if a file passed to in_objs is an ar, and, if so, handle it
 * *cur_i is index of ar file in in_objs*/
void handle_ar_obj(struct obj_file *obj_file, char *name){
  struct obj_file in_obj;
    FILE * file = obj_file->file;
    uint32_t old_pos = ftell(file);

    fseek(file, 0, SEEK_SET);
    uint8_t a0 = fgetc(file);
    uint8_t a1 = fgetc(file);
    uint8_t a2 = fgetc(file);
    uint8_t a3 = fgetc(file);

    if(a0 == 'S' && a1 == 'C' && a2 == 'P' && a3 == 'A'){

        int num_objs = ar_read_word(file);
        for(int i = 0; i < num_objs; i++){
            char buf[256];
            int offset = ar_read_word(file);
            obj_init(&in_obj);
            in_obj.file = fdopen (dup (fileno (file)), "r");;

            in_obj.offset = offset;

            obj_read_header(&in_obj);
            sprintf(buf, "%s: %03u", name, i);
            do_obj(&in_obj, buf);

        }
    } else {
      obj_read_header(obj_file);
      do_obj(obj_file, name);
    }

    fseek(file, old_pos, SEEK_SET);
}


struct obj_file obj;
FILE *file;

int main(int argc, char *argv[]){
  printf("seg 0\tseg 1\tseg 2\tseg 3\ttotal\tfile\n------\t------\t------\t------\t------\t------\n");
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

    //handle sub objs if ar, and print size
    handle_ar_obj(&obj, argv[i]);

  }
  /* print total sums */
    //if(files > 1){
      printf("----------------------------------------------\n");
      printf("%u\t%u\t%u\t%u\t%u\t%s\n", seg_sum[0], seg_sum[1], seg_sum[2], seg_sum[3], sum, "SUM");
    //}

}