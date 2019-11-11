#include "asm.h"
#include "io.h"
#include <string.h>
#include <stdlib.h>

#include "object.h"
#include "obj.h"

/* the array of labels - malloc'd*/
struct label * labels;
/* number of labels alloc'd */
unsigned int labels_allocd = 0;
/* current label number */
unsigned int labels_cur = 0;

/* current segment being written to */
uint8_t cur_seg = 0;
/* addresses in each seg */
uint32_t seg_pos[4];

/* current module */
uint16_t cur_module = 0;

/**
 * reset position in all segments */
void reset_segs_and_module(){
  seg_pos[0] = 0;
  seg_pos[1] = 0;
  seg_pos[2] = 0;
  seg_pos[3] = 0;
  cur_seg = 0;
  cur_module = 0;
}

/**
 * expand the labels array by REALLOC_AMOUNT */
void expand_labels(){
  /* malloc if we haven't already */
  if(!labels) {
    labels = malloc(sizeof(struct label) * REALLOC_AMOUNT);
    labels_allocd = REALLOC_AMOUNT;
    } else {
      labels_allocd += REALLOC_AMOUNT;
      labels = realloc(labels, sizeof(struct label) * labels_allocd);
    }
}

/**
 * add a new label to the labels array - return it */
struct label * add_label(char * name, int16_t module, uint16_t addr, int8_t seg){
  struct label * entry;
  /* realloc if needed */
  if(labels_cur >= labels_allocd) {
    expand_labels();
  }
  entry = labels + (labels_cur++);

  strcpy(entry->name, name);
  entry->module = module;
  entry->addr = addr;
  entry->seg = seg;
  entry->in_use = 1;

  return entry;
}

/**
 * look for a label with the given name and module number, and return it
 * a -1 module number will only search in the global namespace
 * errors if none found */
struct label * find_label(char * name, int16_t module, uint8_t no_extern) {

  for(unsigned int i = 0; i < labels_cur; i++){
    if(!labels[i].in_use){
      continue;
    }
    /* match name and module, or ignore module if global */
    if(!strcmp(name, labels[i].name)){
      if(labels[i].module == module || labels[i].module == -1){
        if(!(no_extern && labels[i].seg == -1)){
          return labels + i;
        }
      }
    }
  }

  error("no such label");

  return NULL;
}

/**
 * count the number of global defined labels, and the number of extern labels
 * also set the extern_index of external labels */
void labels_get_num(uint16_t *defined, uint16_t *external){
  uint16_t extern_i = 0;
  for(unsigned int i = 0; i < labels_cur; i++){
    if(!labels[i].in_use){
      continue;
    }
    if(labels[i].seg == -1){
      (*external)++;
      labels[i].extern_index = extern_i++;
    } else if(labels[i].module == -1){
      (*defined)++;
    }
  }
}

/* write out the labels to the object file */
void labels_write_out(struct obj_file *o){
  for(unsigned int i = 0; i < labels_cur; i++){
    if(!labels[i].in_use){
      continue;
    }
    /* extern symbol */
    if(labels[i].seg == -1){
      obj_write_extern(o, labels[i].name, 0);
    }
    /* defined symbol */
    else if(labels[i].module == -1){
      obj_write_defined(o, labels[i].name, labels[i].seg, labels[i].addr);
    }
  }
}

/* remove extern labels that were defined */
void remove_defined_externs(){
  /* TODO: - we need to do some readjustment of label offsets */
}