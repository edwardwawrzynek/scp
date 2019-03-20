#include <stdio.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"

/* direct input and output functions, and functions for handling structured output to segments in bin */

/* Input object files */
struct obj_file in_objs[MAX_FILES];
/* if the input object file should be linked */
uint8_t in_objs_do_lnk[MAX_FILES];

/* current input file being read */
int cur_in_obj;

/* Output binary */
FILE *out_file;

/* output object */
struct obj_file out_obj;

/* if true, output object file instead of binary */
int do_out_obj = 0;

/**
 * Raise an error */
void error(char * msg){
  printf("\nscplnk: error:\n%s\n", msg);

  exit(1);
}

/* read in all the headers */
void read_in_headers(){
    for(int i = 0; in_objs[i].file; i++){
        obj_read_header(&in_objs[i]);
    }
}

/* Write out to the binary */
void raw_output_byte(uint8_t val){
  fputc(val, out_file);
}

void raw_output_word(uint16_t word){
  fputc(word & 0x00ff, out_file);
  fputc(word >> 8, out_file);
}

/* functions for managing the layout of the different segments, and the data in them */

/* the size of each segment (in bytes, not counting obj meta bytes) */
uint32_t seg_size[4];
/* the start of each segment in memory (in bytes) */
uint32_t seg_start[4];

/* the offset of each file's segments */
uint32_t in_segs_start[MAX_FILES][4];

/* current seg being written to */
uint8_t cur_seg;
/* current write location in each seg (offset in seg) */
uint32_t seg_pos[4];

/* start of each file in symbol tables (only for obj output) */
uint32_t defined_start[MAX_FILES];
uint32_t extern_start[MAX_FILES];

/* create the segment layout, and write the header if requested
   the header contains the start page (5 bits) and number of pages (5 bits) for each segment
   the headers uses nop.n.n instructions to do this, as only the six but opcode is check - we can put what ever we want in the rest. Four nop.n.n (eight bytes) are used, each having an entry of 10 bits behind it. The low five bits are the start page of the segment, the high five the number of pages
   if the header is created, it should be loaded into memory with the rest of the program - scplnk accounts for the offset
   do_pages is whether to arrange segments on page boundries or not. If not, they are arranged on word boundries */
void bin_create_segs(uint8_t do_head, uint8_t do_pages){
    uint32_t offset = 0;

    /* make space for header */
    if(do_head){
        offset = 8;
    }

    for(int s = 0; s < 4; s++){
        seg_start[s] = offset;
        /* offset += seg_size[s]; */
        for(int i = 0; in_objs[i].file; i++){
            if(!in_objs_do_lnk[i]){
                continue;
            }
            /* divide by two b/c sizes in header includes meta-bytes */
            uint32_t size = in_objs[i].segs.segs[s].size / 2;
            /* sum total seg_size */
            seg_size[s] += size;
            /* set in file specific segment starts (needed for extern lookups) */
            in_segs_start[i][s] = offset;
            /* add to offset */
            offset += size;
        }
        /* always align */
        if(offset & 1){offset++;}
        /* align on page boundries */
        if(do_pages){
            while(offset & (PAGE_SIZE-1)){offset++;}
        }
    }


    /* write a header if needed */
    if(do_head){
        fseek(out_file, 0, SEEK_SET);
        for(int s = 0; s < 4; s++){
            /* opcode is high six bits, should be zero */
            uint16_t res = 0;
            /* get start page */
            if((seg_start[s] & (PAGE_SIZE-1)) && s!=0){
                error("page alignment has to be used for header (only use -r and -p togeather)");
            }
            uint8_t start_page = seg_start[s] >> 11;
            res |= start_page;
            /* get number of pages */
            uint8_t num_pages = seg_size[s] & (PAGE_SIZE -1) ? (seg_size[s] >> 11) + 1 : (seg_size[s] >> 1);
            res |= (num_pages << 5);
            /* write result */
            raw_output_word(res);
        }
    }

}

/* create the segment layout for obj output. Read in each seg size, sum them, and set in_seg_start properly. Also sum the size of the defined and extern symbol table
    don't care about do_header or page alignment - that only matters when it is linked again into executable */
void obj_out_create_segs(){
    uint32_t offset;

    for(int s = 0; s < 4; s++){
        seg_start[s] = 0;
        offset = 0;

        for(int i = 0; in_objs[i].file; i++){
            /* divide by two b/c sizes in header includes meta-bytes */
            uint32_t size = in_objs[i].segs.segs[s].size;
            /* sum total seg_size */
            seg_size[s] += size;
            /* set in file specific segment starts (needed for extern lookups) */
            in_segs_start[i][s] = offset / 2;
            /* add to offset */
            offset += size;
        }
    }

    /* sum defined and external table sizes
    NOTE: we write out all extern refrences, even if they aren't refrenced anymore (to keep things simple) */
    uint32_t defined_size = 0, extern_size = 0;
    for(int i = 0; in_objs[i].file; i++){
        defined_start[i] = defined_size / _OBJ_SYMBOL_ENTRY_SIZE;
        defined_size += in_objs[i].segs.defined_table.size;

        extern_start[i] = extern_size / _OBJ_SYMBOL_ENTRY_SIZE;
        extern_size += in_objs[i].segs.extern_table.size;
    }

    /* create and write header */
    obj_create_header(&out_obj, seg_size[0] /2 , seg_size[1] / 2, seg_size[2] / 2, seg_size[3] / 2, defined_size / _OBJ_SYMBOL_ENTRY_SIZE, extern_size / _OBJ_SYMBOL_ENTRY_SIZE);
    obj_write_header(&out_obj);
}

/* set the current segment being written to - seeks to the proper location */
void bin_set_seg(uint8_t seg){
    cur_seg = seg;
    fseek(out_file, seg_start[cur_seg] + seg_pos[cur_seg], SEEK_SET);
}

/* write out a byte or word in the current seg, advancing positioning, etc */
void write_byte(uint8_t val){
    if(seg_pos[cur_seg] >= seg_size[cur_seg]){
        error("wrote over segment size");
    }
    raw_output_byte(val);
    seg_pos[cur_seg]++;
}

void write_word(uint16_t val){
    if(seg_pos[cur_seg] >= seg_size[cur_seg]){
        error("wrote over segment size");
    }
    /* make sure we are aligned */
    if(seg_pos[cur_seg] & 1){
        printf("scplnk: warning: outputting an unaligned word\n");
    }
    raw_output_word(val);
    seg_pos[cur_seg] += 2;
}