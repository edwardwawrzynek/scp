#include "lnk.h"
#include "object.h"
#include "obj.h"
#include "io.h"
#include "symbols.h"
#include <unistd.h>

/**
 *  ----- scp .a file format -----
 * first is magic number SCPA (in ascii) (4 bytes)
 * next is number of object files contained (2 bytes)
 * next is list of 2 byte words, each specifying obj file offset in ar file (2 bytes x num_obj)
 * next is actual obj file bodies
 */

static void ar_write_word(uint16_t word){
    fputc(word & 0xff, out_file);
    fputc(word >> 8, out_file);
}

static uint16_t ar_read_word(FILE *f){
    return fgetc(f) + (fgetc(f)<<8);
}

/* output ar binary on out_file */
void run_lnk_ar(){
    /* magic number */
    fputc('S', out_file);
    fputc('C', out_file);
    fputc('P', out_file);
    fputc('A', out_file);

    uint16_t num_objs = 0;
    for(int i = 0; in_objs[i].file; i++){
        if(in_objs[i].offset){
            /* we don't handle obj file embedded in archives for now */
            error("can't create archive from archive\n");
        }
        num_objs++;
    }

    ar_write_word(num_objs);
    /* offset for first file is 6 (magic + num objs) + 2*(num_obj) */
    uint32_t offset = 6 + 2*num_objs;
    for(int i = 0; i < num_objs; i++){
        /* write offset */
        ar_write_word(offset);
        /* add size of file */
        fseek(in_objs[i].file, 0, SEEK_END);
        offset += ftell(in_objs[i].file);
        fseek(in_objs[i].file, 0, SEEK_SET);
    }

    /* write obj files */
    for(int i = 0; i < num_objs; i++){
        int c;
        while((c = fgetc(in_objs[i].file)) != EOF){
            fputc(c, out_file);
        }
    }

}

/* check if a file passed to in_objs is an ar, and, if so, handle it
 * *cur_i is index of ar file in in_objs*/
void handle_ar_obj(struct obj_file *obj_file, int * cur_index){
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
            int offset = ar_read_word(file);
            obj_init(&in_objs[*cur_index]);
            in_objs[*cur_index].file = fdopen (dup (fileno (file)), "r");
            in_objs_do_lnk[*cur_index] = 1;

            in_objs[*cur_index].offset = offset;

            (*cur_index)++;

        }
        (*cur_index)--;
    }

    fseek(file, old_pos, SEEK_SET);
}