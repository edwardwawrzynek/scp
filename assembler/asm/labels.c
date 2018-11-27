#include "asm.h"
#include "io.h"
#include <string.h>
#include <stdlib.h>

/* the array of labels - malloc'd*/
struct label * labels;
/* number of labels alloc'd */
unsigned int labels_allocd = 0;
/* current label number */
unsigned int labels_cur = 0;

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
struct label * add_label(char * name, int16_t module, uint16_t addr){
  struct label * entry;
  /* realloc if needed */
  if(labels_cur >= labels_allocd) {
    expand_labels();
  }
  entry = labels + (labels_cur++);

  strcpy(entry->name, name);
  entry->module = module;
  entry->addr = addr;

  return entry;
}

/**
 * look for a label with the given name and module number, and return it
 * a -1 module number will only search in the global namespace
 * errors if none found */
struct label * find_label(char * name, int16_t module) {

  for(unsigned int i = 0; i < labels_cur; i++){
    /* match name and module, or ignore module if global */
    if(!strcmp(name, labels[i].name)){
      if(labels[i].module == module || labels[i].module == -1){
        return labels + i;
      }
    }
  }

  error("no such label");

  return NULL;
}