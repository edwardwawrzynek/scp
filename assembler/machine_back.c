//This is the machine backend file for a modern c compiler with a standard library
//These functions are seperated out so that the assembler can, in the future, be run on scp itself without full standard library support
#include <stdlib.h>
#include <stdio.h>


FILE *asm_file;

//Lines limited to 80 chars
char buf[80];

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

//Get a line from the file, and return a pointer to buf
char *get_line(){

  return buf;
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

