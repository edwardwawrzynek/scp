#include "assembler_machine_back.c"


//Asm directives
/*
 * .module  (name)
 * .db  #n1,#n2,...
 * .dw  #n1,#n2,...
 * later, .sys and .call
 */

//Number of commands
#define NUM_CMDS 71
//Length of array for cmds - NUM_CMDS * 5
#define CMD_ARRAY_LEN 355

//Enables debuging messages
/*
#define DEBUG
*/

//Command names
char cmds[CMD_ARRAY_LEN] = "nop \0lbia\0lbib\0lwia\0lwib\0lbpa\0lbpb\0lwpa\0lwpb\0lbqa\0lbqb\0lwqa\0lwqb\0lbma\0lbmb\0lwma\0lwmb\0sbpb\0swpb\0sbqa\0swqa\0sbma\0sbmb\0swma\0swmb\0aadd\0asub\0amul\0abor\0abxr\0abnd\0assr\0ashr\0ashl\0aneg\0alng\0abng\0aclv\0aequ\0aneq\0aslt\0ault\0asle\0aule\0asex\0aaeb\0jmp \0jpnz\0jpz \0inca\0incb\0deca\0decb\0xswp\0mdsp\0masp\0mspa\0psha\0pshb\0popa\0popb\0call\0ret \0outa\0ina \0jmpa\0aptb\0prvu\0prvs\0mmus\0bspa\0";
//length not including opcode byte
char cmd_lens[NUM_CMDS] = {0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1};

//Offset for programs that don't start at addr 0
unsigned int offset = 0;

//Debug 
print_cmd_names(){
	int i;
	unsigned int pos;
	pos = 0;
	for(int i = 0; i < NUM_CMDS;++i){
		printn(i);
		print(" : ");
		print(cmds+pos);
		print(" : ");
		printn(cmd_lens[i]);
		print("\n");
		pos += 5;
	}
}

//Buffer for operands being operated on - nothing should be more than 80 chars
char buf[80];
//Command Name
char name[80];
//Arguments seperated by nulls (? may change)
char args[80];

//Current module being compiled - starts at 0 if no module is specified, 1 if specified
unsigned int MODULE_NUM = 0;

//Address functions based on backend functions
//Append a label and position to labels and labels_addr, realloc'ing if needed
label_append(char *name, unsigned int addr){
  return base_label_append(name, addr, labels, labels_addr, &labels_append_pos, &labels_allocd);
}

//get addr for label
label_addr(char * name){
  return base_get_addr_for_label(name, labels_allocd, labels, labels_addr)+offset;
}
//Append a label and position to a module's namespace
mod_label_append(char *name, unsigned int addr, unsigned int module){
	if(module >= NUM_MODULES-1){
		print("Module number limit passed\n");
		err_exit();
	}
  return base_label_append(name, addr, mod_labels[module], mod_addr[module], &mod_labels_append_pos[module], &mod_labels_allocd[module])+offset;
}
//get addr for label in module's namespace
mod_label_addr(char *name, unsigned int module){
	if(module >= NUM_MODULES-1){
		print("Module number limit passed\n");
		err_exit();
	}
  return base_get_addr_for_label(name, mod_labels_allocd[module], mod_labels[module], mod_addr[module])+offset;
}

//Write out a number in bytes bytes in little-endian format
write_num(unsigned int num, unsigned int bytes){
  unsigned int i;
  for(i = 0; i < bytes; i++){
    write(num&0xff);
    num = num >> 8;
  }
  return 0;
}

//Check if character is valid first letter of label - includes alpha numerical, and _
isalpha(char c){
        if ((c >= 'a' & c <= 'z') | (c >= 'A' & c <= 'Z') | (c == '_')){
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
  return cur;
}

//read line into buffer, and put the passed char in first position - this stops at tabs
read_line_buf_label(char first){
  int index;
  char cur;
  buf[0] = first;
  index = 1;
  cur = read();
  while(cur != '\n' && cur != EOF && cur != '\t'){
    buf[index] = cur;
    index++;
    cur = read();
  }
  buf[index] = '\0';
  return cur;
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

read_to_nl_or_tab(){
	char c;
	c = read();
	while(c != '\n' && c != EOF && c != '\t'){
		c = read();
	}
	return c;
}

usage(){
  print("Usage: scpasm [options] [output file] [one or more asm files]\nOptions:\n-o offset :pad the output by offset null bytes\n-e        :pad the output to the end of the addr space\n");
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
    if(op > NUM_CMDS){
      print("Error: No such command: ");
      print(cmd);
      print("\n");
      err_exit();
    }
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
	//pointer to start of arguments
	int arg_start;
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
			arg_start = pos+1;
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
			if(!strcmp(name,".ds")){
				return atoi(buf+arg_start+1);
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
  return 0;
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
      //Keep the $ prefix on the module level label declarations
      c = read_line_buf_label(c);
      buf_label_clear();
      mod_label_append(buf, addr, MODULE_NUM);
    }
    //Global label
  	if(isalpha(c)){
      c = read_line_buf_label(c);
      buf_label_clear();
      label_append(buf, addr);
    }
		 //Asm command or directive
    if(c == '\t'){
      c = read();
      read_line_buf(c);
      //first_pass_cmd will handle the module level
      addr += first_pass_cmd();
    }
  }
	return addr;
}

//Handle the directive command in name with arguments in buf
second_handle_dir(){
  int pos;
  char c;
	int arg1;
	int i;
  unsigned int addr;
  pos = 0;
  if(!strcmp(name, ".module")){
    MODULE_NUM++;
  }
  else if(!strcmp(name, ".db")){
    while(1){
      //Literal
      if(args[pos] == '#'){
        write_num(atoi(args+pos+1), 1);
        pos += strlen(args+pos)+1;
      }
      //Module Label
      else if(args[pos] == '$'){
        addr = mod_label_addr(args+pos, MODULE_NUM);
        write_num(addr, 1);
        pos += strlen(args+pos)+1;
      }
      //Global Label
      else if(isalpha(args[pos])){
        addr = label_addr(args+pos);
        write_num(addr, 1);
        pos += strlen(args+pos)+1;
      }
      if(args[pos] == '\0'){
        break;
      }
    }
  }
  else if(!strcmp(name, ".dw")){
    while(1){
      //Literal
      if(args[pos] == '#'){
        write_num(atoi(args+pos+1), 2);
        pos += strlen(args+pos)+1;
      }
      //Module Label
      else if(args[pos] == '$'){
        addr = mod_label_addr(args+pos, MODULE_NUM);
        write_num(addr, 2);
        pos += strlen(args+pos)+1;
      }
      //Global Label
      else if(isalpha(args[pos])){
        addr = label_addr(args+pos);
        write_num(addr, 2);
        pos += strlen(args+pos)+1;
      }
      if(args[pos] == '\0'){
        break;
      }
    }
  }
	else if(!strcmp(name, ".ds")){
		arg1 = atoi(args+pos+1);
		for(i = 0; i < arg1; i++){
			write_num(0,1);
		}
	}
	else{
		print("Error: no such directive: ");
		print(name);
		print("\n");
		err_exit();
	}
}

gen_name(){
  char c;
  int pos;
  pos = 0;
  c = buf[pos];
  while(c != '\t'){
    name[pos] = c;
    pos++;
    c = buf[pos];
  }
  name[pos] = '\0';
}

//Get args from buf into args, null seperated
gen_args(){
  char c;
  unsigned int pos;
  unsigned int args_pos;
  //Clear args
  for(pos = 0; pos < 80; pos++){
    args[pos] = '\0';
  }
  pos = 0;
  args_pos = 0;
  //Read till tab seperating cmd from args
  do{
    c=buf[pos];
    pos++;
  }while(c!='\t');
  //Get args
  while(1){
    c=buf[pos];
    if(c=='\0' || c=='\n'){
      break;
    }
    if(c!=','){
      args[args_pos] = c;
      args_pos++;
    }
    else{
      args[args_pos] = '\0';
      args_pos++;
    }
    pos++;
  }
}

//Write out the arg starting at args[pos] in bytes bytes
second_write_arg(unsigned int pos, unsigned int bytes){
  unsigned int addr;
  unsigned int add;
  unsigned int i;
  char c;
  i = 0;
  add = 0;
	addr = 0;
  //Seperate literal to add if present
  do{
    c = args[pos+i];
    i++;
    //Add if present, and remove from string
    if(c == '+'){
      add = atoi(args+pos+i+1);
      args[pos+i-1] = '\0';
    }
  }while(c != '\0');
  //handle the type of arg
  //Literal
  if(args[pos] == '#'){
    write_num(atoi(args+pos+1)+add, bytes);
  }
  //Module Label
  else if(args[pos] == '$'){
    addr = mod_label_addr(args+pos, MODULE_NUM);
    write_num(addr+add, bytes);
  }
  //Global Label
  else if(isalpha(args[pos])){
    addr = label_addr(args+pos);
    write_num(addr+add, bytes);
  }
}
//Pass over file, writing opcodes with resolved addr's, and handle directives
second_pass(){
  char c;
  int pos;
  unsigned int opcode;
  //Loop through each line
  while(1){
    c = read();
    //Skip comments
    if(c == ';'){
      read_to_nl();
      continue;
    }
		//Commands can be on the same line as labels
		/*if(c == '$' || isalpha(c)){
			c = read_to_nl_or_tab();
		}*/
		if(c == '$'){
			c = read_line_buf_label(c);
			buf_label_clear ();
#ifdef DEBUG
			printf("\n%s:\t|Location:\t|%x", buf, bytes_written());
#endif
			if(mod_label_addr(buf, MODULE_NUM) != bytes_written ()){
				print("Warning: Label ");
				print(buf);
				print(" is being written at addr ");
				printn(bytes_written ());
				print(", but was resolved to be at addr ");
				printn(mod_label_addr(buf, MODULE_NUM));
				print(".\n");
			}
		}
		if(isalpha(c)){
			c = read_line_buf_label(c);
			buf_label_clear ();
#ifdef DEBUG
			printf("\n%s:\t|Location:\t|%x", buf, bytes_written());
#endif
			if(label_addr(buf) != bytes_written ()){
				print("Warning: Label ");
				print(buf);
				print(" is being written at addr ");
				printn(bytes_written ());
				print(", but was resolved to be at addr ");
				printn(label_addr(buf));
				print(".\n");
			}
		}
		if(c == EOF){break;}
    if(c == '\n'){continue;}
    //The file is at the first position of a good line - handle the line
    if(c == '\t'){
      c = read();
      read_line_buf(c);
#ifdef DEBUG
			printf("\n%s\t|", buf);
#endif
      //put name from buf into name
      gen_name();
      gen_args();
#ifdef DEBUG
			printf("%s:%s:", name, args);
#endif
      //the buffer contains the line
      if(buf[0] == '.'){
        //Handle the directive
#ifdef DEBUG
				printf("directive\t|");
#endif
        second_handle_dir();
      }
      else{
        //Handle Asm command
        //Get and write opcode
        opcode = get_opcode(name);
#ifdef DEBUG
				printf("cmd %x\t|", opcode);
#endif
        write_num(opcode, 1);
        //Write out arg with appropriate byte len - (note-this will have to change if commands use mutliple args)
        second_write_arg(0, cmd_lens[opcode]);
      }
    }
  }
}

write_offset(){
	unsigned int i;
	for(i = 0; i < offset; i++){
		write(0);
	}
}

main(int argc, char **argv){
	unsigned int argv_off;
	unsigned char end = 0;
	unsigned char print_size = 0;
	unsigned int addr = 0;
	argv_off = 0;
  //For scp, set argc and argv
  if(argc < 3){
    usage();
  }
	//Handle flags
	if(argv[1][0] == '-'){
		if(argv[1][1] == 'o'){
			argv_off = 2;
			offset = atoi(argv[2]);
		}
		else if(argv[1][1] == 'e'){
			argv_off = 1;
			end = 1;
		}
		else if(argv[1][1] == 's'){
			argv_off = 1;
			print_size = 1;
		}
	}
  back_init();
  open_asm(argv[2 + argv_off]);
  open_out(argv[1 + argv_off]);
  //First Pass
  file_restart();
  //first_pass();
	addr = first_pass();
	if(print_size){
		print("Size: ");
		printn(addr);
		print(" bytes.\n");
	}
	if(end){
		offset = 65536 - addr;
	}
	//Write offset number of blank bytes before start
	write_offset();
  //Second Pass
  MODULE_NUM = 0;
  file_restart();
  second_pass();
  //clean up
  close();
  back_end();
}
