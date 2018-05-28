//This is the machine backend file for a modern c compiler with a standard library
//These functions are seperated out so that the assembler can, in the future, be run on scp itself without full standard library support
#include <stdlib.h>
#include <stdio.h>


FILE *asm_file;
//64 global labels to start, realloced if more needed - labels points to an array of pointers to char arrays
char **labels;
//label values
unsigned int *labels_addr;
//label position for appending
unsigned int labels_append_pos = 0;
//number of allocated label spots
unsigned int labels_allocd = 0;

//Hard limit of 32 modules
#define NUM_MODULES 32
char **mod_labels[NUM_MODULES];
unsigned int *mod_addr[NUM_MODULES];
unsigned int mod_labels_append_pos[NUM_MODULES];
unsigned int mod_labels_allocd[NUM_MODULES];

//init backend
int back_init(){
  unsigned int i;
  //Init global labels
  labels = (char **) calloc(64, sizeof(char *));
  labels_addr = (unsigned int *) calloc(64, sizeof(unsigned int));
  if(labels == NULL){
    print("malloc error\n");
    err_exit();
  }
  labels_allocd = 64;
  //Init modules labels
  for(i = 0; i < NUM_MODULES; i++){
    mod_labels[i] = (char **) calloc(64, sizeof(char *));
    mod_addr[i] = (unsigned int *) calloc(64, sizeof(unsigned int));
    if(mod_labels[i] == NULL){
      print("malloc error\n");
      err_exit();
    }
    mod_labels_allocd[i] = 64;
  }
  return 0;
}

//end back_end - free malloc'd memory
int back_end(){
  char *l;
  unsigned int pos;
  pos = 0;
  free(labels_addr);
  l = labels[0];
  while(l != NULL){
    free(l);
    pos++;
    l = labels[pos];
  }
  free(labels);
  return 0;
}

//get string length - used if scp doesn't have stdlib
int strlen(char *s){
        int i;
        i = 0;
        while (*s++){
          i++;
        }
        return (i);
}
//same with strcpy
char *strcpy(char *s1, char *s2)
{
        char *os1;

        os1 = s1;
        while (*s1++ = *s2++);
        return(os1);

}
//Compare strings - included for scp
strcmp(char * s1, char * s2){
        while (*s1 == *s2++){
                if (*s1++=='\0'){
                        return 0;
                }
        }
        return(*s1 - *--s2);
}

int base_label_append(char *name, unsigned int addr, char **labels, unsigned int *label_addr, unsigned int *labels_append_pos, unsigned int *labels_allocd){
  if(*labels_append_pos >= *labels_allocd){
    print("Need to realloc label buffer, not yet implemented\n");
    err_exit();
  }
  label_addr[*labels_append_pos] = addr;
  labels[*labels_append_pos] = calloc(strlen(name), sizeof(char));
  strcpy(labels[*labels_append_pos], name);
  (*labels_append_pos)++;
  return 0;
}

int base_get_addr_for_label(char *name, unsigned int labels_allocd, char **labels, unsigned int *label_addr){
  unsigned int pos;
  for(pos = 0; pos < labels_allocd; pos++){
    if(labels[pos] != NULL){
      if(!strcmp(name, labels[pos])){
        return label_addr[pos];
      }
    }
  }
  print("Error: Address ");
  print(name);
  print(" is not defined.\n");
  err_exit();
}


//Open assembly file
int open_asm(char *name){
  asm_file = fopen(name, "r");
  if(asm_file == NULL){
    print("No such file: ");
    print(name);
    print("\n");
    err_exit();
  }
  return 0;
}

//Seek to begining of file
int file_restart(){
  fseek(asm_file, 0, SEEK_SET);
  return 0;
}

//Read a char from the file
unsigned char read(){
  return fgetc(asm_file);
}


//Print out
int print(char * msg){
  printf(msg);
  return 0;
}

//Print a number
int printn(int n){
  printf("%i", n);
  return 0;
}

//Exit with error
int err_exit(){
  exit(1);
}

