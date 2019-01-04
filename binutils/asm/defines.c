#include "asm.h"
#include "io.h"
#include <string.h>
#include <stdlib.h>

#include "object.h"
#include "obj.h"

/* the array of definitions - malloc'd*/
struct def * defs;
/* number of defines alloc'd */
unsigned int defs_allocd = 0;
/* current def number (last written + 1) */
unsigned int defs_cur = 0;


/**
 * expand the defs array by REALLOC_AMOUNT */
void expand_defs(){
  /* malloc if we haven't already */
  if(!defs) {
    defs = malloc(sizeof(struct def) * REALLOC_AMOUNT);
    defs_allocd = REALLOC_AMOUNT;
    } else {
      defs_allocd += REALLOC_AMOUNT;
      defs = realloc(defs, sizeof(struct def) * defs_allocd);
    }
}

/**
 * add a new define to the array */
struct def * add_def(char * name, uint16_t val){
  struct def * entry;
  /* realloc if needed */
  if(defs_cur >= defs_allocd) {
    expand_defs();
  }
  entry = defs + (defs_cur++);

  strcpy(entry->name, name);
  entry->val = val;

  return entry;
}

/**
 * find the definition entry for a given name, or NULL if there is none */
struct def * find_def(char * name) {

  for(unsigned int i = 0; i < defs_cur; i++){

    if(!strcmp(name, defs[i].name)){
      return &defs[i];
    }
  }

  return NULL;
}