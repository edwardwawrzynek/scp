#include "object.h"
#include "obj.h"
#include "lnk.h"
#include "io.h"

/* functions for managing the layout of the different segments, and the data in them */

/* the size of each segment (in bytes, not counting obj meta bytes) */
uint16_t seg_size[4];
/* the start of each segment in memory (in bytes) */
uint16_t seg_start[4];

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

}