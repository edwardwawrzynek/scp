//This is the machine backend file for a modern c compiler with a standard library
//These functions are seperated out so that the assembler can, in the future, be run on scp itself without full standard library support
#include <stdlib.h>
#include <stdio.h>


FILE *asm_file;


//Open assembly file
int open_asm(char *name){
  asm_file = fopen(name, "r");
  if(asm_file == NULL){
    print("No such file: ");
    print(name);
    print("\n");
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

