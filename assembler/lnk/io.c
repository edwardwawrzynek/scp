#include <stdio.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"

/* direct input and output functions, and functions for handling structured output to segments in bin */

/* Input object files */
struct obj_file in_objs[MAX_FILES];

/* current input file being read */
int cur_in_obj;

/* Output binary */
FILE *out_file;

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
uint16_t seg_size[4];
/* the start of each segment in memory (in bytes) */
uint16_t seg_start[4];

/* current seg being written to */
uint8_t cur_seg;
/* current write location in each seg (offset in seg) */
uint16_t seg_pos[4];

/* read from the headers, and set the size of each segment */
void read_seg_size(){
    for(int i = 0; in_objs[i].file; i++){
        for(int s = 0; s < 4; s++){
            /* divide by two b/c sizes in header includes meta-bytes */
            seg_size[s] += in_objs[i].segs.segs[s].size / 2;
        }
    }
}

/* create the segment layout, and write the header if requested
   the header contains the start page (5 bits) and number of pages (5 bits) for each segment
   the headers uses nop.n.n instructions to do this, as only the six but opcode is check - we can put what ever we want in the rest. Four nop.n.n (eight bytes) are used, each having an entry of 10 bits behind it. The low five bits are the start page of the segment, the high five the number of pages
   if the header is created, it should be loaded into memory with the rest of the program - scplnk accounts for the offset
   do_pages is whether to arrange segments on page boundries or not. If not, they are arranged on word boundries */
void create_segs(uint8_t do_head, uint8_t do_pages){
    uint16_t offset = 0;

    /* make space for header */
    if(do_head){
        offset = 8;
    }

    for(int s = 0; s < 4; s++){
        seg_start[s] = offset;
        offset += seg_size[s];
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

/* set the current segment being written to - seeks to the proper location */
void set_seg(uint8_t seg){
    cur_seg = seg;
    fseek(out_file, seg_start[cur_seg] + seg_pos[cur_seg], SEEK_SET);
}

/* write out a byte or word in the current header, advancing positioning, etc */
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
    raw_output_word(val);
    seg_pos[cur_seg] += 2;
}