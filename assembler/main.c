#include "machine_back.c"

//Asm directives
/*
 * .module  (name)
 * .db  #n1,#n2,...
 * .dw  #n1,#n2,...
 * later, .sys and .call
 */

//Number of commands
#define NUM_CMDS 25
//Length of array for cmds - NUM_CMDS * 5
#define CMD_ARRAY_LEN 125

//Command names
char cmds[CMD_ARRAY_LEN] = "nop \0lbia\0lbib\0lwia\0lwib\0lbpa\0lbpb\0lwpa\0lwpb\0lbqa\0lbqb\0lwqa\0lwqb\0lbma\0lbmb\0lwma\0lwmb\0sbpb\0swpb\0sbqa\0swqa\0sbma\0swma\0sbmb\0swmb";
//length not including opcode byte
char cmd_lens[NUM_CMDS] = {0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2};

//Buffer for operands being operated on - nothing should be more than 80 chars
char buf[80];
//Command Name
char name[80];

//Current module being compiled
unsigned int MODULE_NUM = 0;

//Check if character is valid first letter of label
isalpha(char c){
        if ((c >= 'a' & c <= 'z') | (c >= 'A' & c <= 'Z')){
          return 1;
        }
        else{
          return 0;
        }
}
//read line into buffer, and put the passed char in first position
read_line_buf(char first){
  int index;
  char cur;
  buf[0] = first;
  index = 1;
  cur = read();
  while(cur != '\n' && cur != EOF){
    buf[index] = cur;
    index++;
    cur = read();
  }
  buf[index] = '\0';
  return 0;
}

//read till newline - used to skip comments
read_to_nl(){
  char c;
  c = read();
  while(c != '\n' && c != EOF){
    c = read();
  }
  return 0;
}

usage(){
  print("Usage: scpasm [one or more asm files]\n");
  err_exit();
  return 0;
}

//Get the opcode for an asm cmd
get_opcode(char *cmd){
  int pos;
  int op;
  int match;
  pos = 0;
  op = 0;
  do {
    match = strcmp(cmd, cmds+pos);
    pos += 5;
    op++;
  } while (match != 0);
  return op-1;
}


//Get the length of an asm cmd or directive
first_pass_cmd(){
  char e;
  int pos;
  int nargs;
  //Is it a directive
  char dir;
  dir = 0;
  pos = 0;
  e = 0;
  //Get the command name into name

      e = buf[pos];
      while(e != '\0' && e != '\t'){
        if(e == '.'){
          dir = 1;
        }
        name[pos] = e;
        pos++;
        e = buf[pos];
      }
      name[pos] = '\0';
      //if not a directive, no need to count args, just return length
      if(dir == 0){
        return cmd_lens[get_opcode(name)]+1;
      }
      //Handle directives
      //Count args
      nargs = 0;
      while(e != '\0'){
        //Tab or comma indicate an arg
        if(e == ',' || e == '\t'){
          nargs++;
        }
        pos++;
        e = buf[pos];
      }
      if(!strcmp(name,".module")){
        MODULE_NUM++;
        return 0;
      }
      if(!strcmp(name,".db")){
        return nargs;
      }
      if(!strcmp(name,".dw")){
        return nargs << 1;
      }
      return 0;
}

//Clear the colon from the end of the label in buf, and error if not present
buf_label_clear(){
  int pos;
  char c;
  pos = 0;
  c = buf[pos];
  while(c != ':'){
    if(c == '\0'){
      print("Error: label must end in :\nAt: ");
      print(buf);
      print("\n");
      err_exit();
    }
    pos++;
    c = buf[pos];
  }
  buf[pos] = '\0';
}

//Pass over file, getting label addr's
first_pass(){
  char c;
  int pos;
  //Address
  unsigned int addr;
  addr = 0;
  //Loop through each line
  while(1){
    c = read();
    //Handle comments
    if(c == EOF){break;}
    if(c == ';'){
      read_to_nl();
      continue;
    }
    if(c == '\n'){continue;}
    //The file is at the first position of a good line - handle the line
    //Module-level label
    if(c == '$'){
      c = read();
      read_line_buf(c);
      buf_label_clear();
    }
    //Asm command or directive
    else if(c == '\t'){
      c = read();
      read_line_buf(c);
      //first_pass_cmd will handle the module level
      addr += first_pass_cmd();
    }
    //Global label
    else if(isalpha(c)){
      read_line_buf(c);
      buf_label_clear();
      label_append(buf, addr);
    }
  }
}

main(int argc, char **argv){
  //For scp, set argc and argv
  if(argc < 2){
    usage();
  }
  back_init();
  open_asm(argv[1]);
  file_restart();
  //First pass
  first_pass();
  back_end();
}
