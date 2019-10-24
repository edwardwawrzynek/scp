#include "asm.h"
#include "io.h"
#include "defines.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

/* functions to support the decoding of instructions */

/**
 * check if a char is whitespace */
uint8_t is_whitespace(char c){
  return c == ' ' || c == '\t' || c == '\n';
}

/**
 * skip to next non blank file in line */
void blanks(){
  while(is_whitespace(line[lptr]) && line[lptr] != '\0') {lptr++;};
}


/**
 * read a line from a file into the line buffer
 * reset lptr
 * return 0 on success, 1 on eof*/
uint8_t read_line() {
  char c;
  int is_eof = 0;
  lptr = 0;
  do {
    c = read_byte();
    /* stop at newline */
    if(c == EOF){is_eof = 1;}
    if(c == '\n' || c == EOF) {
        c = '\0';
    }
    line[lptr++] = c;
  } while (c != '\0');
  lptr = 0;

  return is_eof;
}

/**
 * read in lines until a non-whitespace, non-comment line is read
 * returns 1 on eof*/
uint8_t read_good_line(){
  do {
    if(read_line()){
      /* check that the line has nothing on it */
      blanks();
      if(line[lptr] == '\0'){
        return 1;
      }
    }
    blanks();
    /* read next line if this line was a comment or just whitespace */
  } while (line[lptr] == ';' || line[lptr] == '\0');
  return 0;
}

/**
 * find the instruction entry that matches the given cmd name, or error if not a valid instruction */
struct instr_encoding * get_instr_entry(char * name) {
  for(unsigned int i = 0; instructions[i].name; i++){
    if(!strcmp(instructions[i].name, name)) {
      return instructions + i;
    }
  }
  error("No such command");
  return NULL;
}

/**
 * get the dir_type for a directive name
 */
enum dir_type get_dir_type(char *name){
  for(unsigned int i = 0; dir_names[i]; i++){
    if(!strcmp(dir_names[i], name)){
      return (enum dir_type)i;
    }
  }
  error("No such directive");
  return 0;
}

int hex2int(char ch)
{
  if (ch >= '0' && ch <= '9')
    return ch - '0';
  if (ch >= 'A' && ch <= 'F')
    return ch - 'A' + 10;
  if (ch >= 'a' && ch <= 'f')
    return ch - 'a' + 10;
  return -1;
}

/**
 * utiltiy function to read in a space seperated arg into buf from the current lptr position */
void read_in_arg(char * buf){
  while(!is_whitespace(line[lptr]) && line[lptr]){
    *(buf++) = line[lptr];
    lptr++;
  }
}

/**
 * read the current line into a struct instr */
void line_into_instr(struct instr * instr){
  /* clear instruction */
  memset(instr, 0, sizeof(struct instr));
  /* reset opcode */
  instr->opcode = -1;
  /* reset line */
  lptr = 0;
  /* check for label */
  if(!is_whitespace(line[lptr])){
    instr->is_label = 1;
    while(line[lptr] != ':'){
      /* make sure we have a : before end of label */
      if(is_whitespace(line[lptr]) || (!line[lptr])){
        error(": needed after label\n");
      }
      instr->name[lptr] = line[lptr];
      lptr++;
    }
    /* set null */
    instr->name[lptr] = '\0';
  } else {
    instr->is_label = 0;
    /* read in command name */
    blanks();
    read_in_arg(instr->name);
    /* set is_dir */
    if(instr->name[0] == '.'){
      instr->is_dir = 1;
      /* set directive */
      instr->dir_type = get_dir_type(instr->name);
    } else {
      /* set opcode */
      /* TODO: allow macro expansion */
      instr->encoding = get_instr_entry(instr->name);
      instr->opcode = instr->encoding->opcode;
    }
    int arg_num = 0;
    /* read in args */
    while(blanks(), line[lptr]){
      /* the arg currently being handled */
      struct arg *arg;
      arg = &(instr->args[arg_num]);
      arg->in_use = 1;
      read_in_arg(arg->str);
      /* handle offsets */
      arg->offset = 0;
      int i = 0;
      while(arg->str[i]){
        if(arg->str[i] == '+'){
          /* seperate offset by null */
          arg->str[i] = '\0';
          arg->offset = atoi(arg->str + i + 1);
          break;
        }
        i++;
      }
      /* set val - and add offset*/
      arg->val = atoi(arg->str) + arg->offset;
      /* check if it could be a val */
      if(isdigit(*(arg->str)) || *(arg->str) == '-'){
        arg->is_val = 1;
      }
      /* check if it is defined as something */
      else {
        struct def * def = find_def(arg->str);
        if(def != NULL){
          arg->is_val = 1;
          arg->val = def->val;
        }
      }


      /* if we can, set reg */
      if(arg->str[0] == 'r' && !arg->str[2]){
        arg->is_reg = 1;
        arg->reg = hex2int(arg->str[1]);
      } else if(arg->str[0] == 's' && arg->str[1] == 'p' && !arg->str[2]){
        arg->is_reg = 1;
        arg->reg = 15;
      }
      /* if we can, set alu */
      for(uint8_t alu_op = 0; alu_ops[alu_op]; alu_op++){
        if(!strcmp(alu_ops[alu_op], arg->str)){
          arg->is_alu = 1;
          arg->alu_op = alu_op;
          break;
        }
      }
      /* set condition code if the arg contains nothing but condition chars and _ */
      arg->is_cond = 1;
      for(char *c = arg->str; *c && arg->is_cond; c++){
        switch(*c){
          case 'e':
            arg->cond_code |= 0b00001;
            break;
          case 'l':
            arg->cond_code |= 0b00010;
            break;
          case 'g':
            arg->cond_code |= 0b00100;
            break;
          case 'L':
            arg->cond_code |= 0b01000;
            break;
          case 'G':
            arg->cond_code |= 0b10000;
            break;
          case '_':
            break;
          default:
            arg->is_cond = 0;
            arg->cond_code = 0;
            break;
        }
      }
      arg_num++;
    }
  }
}

/**
 * check that an instr has been passed the proper number and type of arguments
 * does no checking if opcode == -1
 * doesn't check labels
 * errors if instr hasn't been passed proper args */
void check_instr(struct instr *instr){
  /* shortcut for encodign */
  struct instr_encoding *en = instr->encoding;
  if(instr->opcode >= 0 && en){
    uint8_t arg_i = 0;
    while(en->types[arg_i] != end_arg){
      /* make sure we passed enough args */
      if(!instr->args[arg_i].in_use){
        error("incorrect number of args passed");
      }
      /* make sure types are correct */
      switch(en->types[arg_i]){
        case reg:
          if(!instr->args[arg_i].is_reg){
            error("incorrect arg type: reg required");
          }
          break;
        case alu:
          if(!instr->args[arg_i].is_alu){
            error("incorrect arg type: alu required");
          }
          break;
        case cnst:
          break;
        case label:
          break;
        case cond:
          if(!instr->args[arg_i].is_cond){
            error("incorrect arg type: cond required");
          }
          break;
        default:
          break;
      }
      arg_i++;
    }
    /* check if to many args were passed */
    if(instr->args[arg_i].in_use){
      error("incorrect number of args passed");
    }
  }
}
