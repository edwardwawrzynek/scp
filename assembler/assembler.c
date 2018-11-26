#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>

/* max line length - including newline */
#define LINE_SIZE 81
/* max label length - including null */
#define LABEL_SIZE 33
/* number of labels to alloc per each expansion */
#define REALLOC_AMOUNT 64
/* maximum number of files that can be open */
#define MAX_FILES 50
/* maximum number of args to any instruction */
#define MAX_ARGS 10

/* max length (with null) of an instruction argument */
#define ARG_LEN 33
#define CMD_NAME_SIZE 17

enum arg_type {end_arg, reg, alu, cnst, label, cond};

/* describes the encoding of an instruction */
struct instr_encoding {
  char * name;
  uint8_t opcode;
  enum arg_type types[MAX_ARGS];
  char * encoding;
  /* which field to use as immediate - 0=no immediate (opcode can't be immediate) */
  uint8_t imd_field;
};

/* IMPORTANT: 4 bit opcodes have to be specified as four bit - don't include blank bits for unused */
struct instr_encoding instructions[] = {
  { "nop.n.n", 0b000000, {end_arg},                /* nop.n.n */
    "000000----------" },
  { "mov.r.r", 0b000001, {reg, reg, end_arg},      /* mov.r.r dst src */
    "000000--22221111" },

  { "alu.r.r", 0b0001  , {alu, reg, reg, end_arg}, /* alu.r.r op dst src */
    "0000111133332222" },
  { "alu.r.i", 0b0010  , {alu, reg, cnst, end_arg},/* alu.r.i op dst imd */
    "00001111----2222", 3 },

  { "cmp.r.f", 0b000010, {reg, reg, end_arg},      /* cmp.r.f reg1 reg2 */
    "000000--22221111" },

  { "ld.r.i",  0b001100, {reg, cnst, end_arg},     /* ld.r.i reg imd */
    "000000------1111", 2},

  { "ld.r.m.w", 0b00110100, {reg, label, end_arg},  /* ld.r.m.w reg mem */
    "00000000----1111", 2},
  { "ld.r.m.b", 0b00110110, {reg, label, end_arg},  /* ld.r.m.b reg mem */
    "00000000----1111", 2},
  { "ld.r.m.bs", 0b00110111, {reg, label, end_arg},  /* ld.r.m.bs reg mem */
    "00000000----1111", 2},

  { "ld.r.p.w", 0b00111000, {reg, reg, end_arg},  /* ld.r.pw dst src */
    "0000000022221111"},
  { "ld.r.p.b", 0b00111010, {reg, reg, end_arg},  /* ld.r.p.b dst src */
    "0000000022221111"},
  { "ld.r.p.bs", 0b00111011, {reg, reg, end_arg},  /* ld.r.p.bs dst src*/
    "0000000022221111"},

  { "ld.r.p.off.w", 0b00111100, {reg, reg, cnst, end_arg},  /* ld.r.p.off.w dst src off */
    "0000000022221111", 3},
  { "ld.r.p.off.b", 0b00111110, {reg, reg, cnst, end_arg},  /* ld.r.off.p.b dst src off */
    "0000000022221111", 3},
  { "ld.r.p.off.bs", 0b00111111, {reg, reg, cnst, end_arg},  /* ld.r.p.off.bs dst src off */
    "0000000022221111", 3},

  { "ld.r.ra", 0b000011, {reg, label, end_arg},  /* ld.r.ra dst addr */
    "000000------1111", 2},

  { "st.r.m.w", 0b01000000, {reg, label, end_arg},  /* st.r.m.w reg mem */
    "00000000----1111", 2},
  { "st.r.m.b", 0b01000010, {reg, label, end_arg},  /* st.r.m.b reg mem */
    "00000000----1111", 2},
  { "st.r.m.bs", 0b01000010, {reg, label, end_arg},  /* st.r.m.bs reg mem (alias for st.r.m.b) */
    "00000000----1111", 2},

  { "st.r.p.w", 0b01000100, {reg, reg, end_arg},  /* st.r.p.w src dst */
    "0000000022221111"},
  { "st.r.p.b", 0b01000110, {reg, reg, end_arg},  /* st.r.p.b src dst */
    "0000000022221111"},
  { "st.r.p.bs", 0b01000110, {reg, reg, end_arg},  /* st.r.p.bs src dst (alias for st.r.p.b) */
    "0000000022221111"},

  { "st.r.p.off.w", 0b01001000, {reg, reg, cnst, end_arg},  /* st.r.p.off.w src dst off */
    "0000000022221111", 3},
  { "st.r.p.off.b", 0b01001010, {reg, reg, cnst, end_arg},  /* st.r.p.off.b src dst off */
    "0000000022221111", 3},
  { "st.r.p.off.bs", 0b01001010, {reg, reg, cnst, end_arg},  /* st.r.p.off.bs src dst off (alias for st.r.p.off.bs) */
    "0000000022221111", 3},

  { "jmp.c.j", 0b010011, {cond, label, end_arg}, /* jmp.c.j cond addr */
    "000000-11111----", 2},
  { "jmp.c.r", 0b010100, {cond, reg, end_arg}, /* jmp.c.r cond reg */
    "000000-111112222"},

  { "push.r.sp", 0b010101, {reg, reg, end_arg}, /* push.r.sp reg sp */
    "000000--22221111"},
  { "pop.r.sp", 0b010110, {reg, reg, end_arg}, /* pop.r.sp reg sp */
    "000000--22221111"},

  { "call.j.sp", 0b010111, {reg, label, end_arg}, /* call.j.sp sp addr */
    "000000--1111----", 2},
  { "call.r.sp", 0b011000, {reg, reg, end_arg}, /* call.j.sp reg sp */
    "000000--22221111"},

  { "ret.n.sp", 0b011001, {reg, end_arg}, /* ret.n.sp sp */
    "000000--1111----"},

  { "out.r.p",  0b011010, {reg, cnst, end_arg}, /* out.r.p reg port */
    "000000------1111", 2},
  { "in.r.p",  0b011011, {reg, cnst, end_arg}, /* in.r.p reg port */
    "000000------1111", 2},
};

/* alu op names */
char * alu_ops[16] = {"bor", "bxor", "band", "lsh", "ursh", "srsh", "add", "sub", "mul", "bneg", "neg"};

#define num_instructions sizeof(instructions)/sizeof(struct instr_encoding)

/* an argument to a struct instr */
struct arg {
  /* if the arg is used */
  uint8_t in_use;
  /* the arg (not including offsets) */
  char str[ARG_LEN];
  /* the arg's value (calculated by atoi - for labels, etc, this is zero) */
  uint16_t val;
  /* if arg could be a reg, this is the reg number (0-15) */
  uint8_t is_reg;
  uint8_t reg;
  /* if the arg could be an alu, this is the alu op number */
  uint8_t is_alu;
  uint8_t alu_op;
  /* if the arg could be a condition code, this is the code */
  uint8_t is_cond;
  uint8_t cond_code;
  /* the offset (calculated from +x) */
  uint16_t offset;
};

/* a struct representing an instruction from the asm */
struct instr {
  /* name */
  char name[CMD_NAME_SIZE];
  /* the opcode of the instruction, or -1 if the instruction isn't a direct asm instr */
  int opcode;
  /* encoding entry, or NULL if not a direct asm instr */
  struct instr_encoding *encoding;
  /* if true, instruction is a label (name holds the name of the label) */
  uint8_t is_label;
  /* if true, instruction is directive (name holds name WITH . in it) */
  uint8_t is_dir;
  /* arguments */
  struct arg args[MAX_ARGS];
};

char line[LINE_SIZE];
int lptr;

/* input files */
FILE * in_files[MAX_FILES];
/* current input file */
int cur_in_file = 0;
/* output file */
FILE * out_file;

/* current module */
uint16_t global_module = 0;

struct label {
  char name[LABEL_SIZE];
  /* module number, or -1 for not a global label */
  int16_t module;
  /* the address of the label */
  uint16_t addr;
};

/* the array of labels - malloc'd*/
struct label * labels;
/* number of labels alloc'd */
unsigned int labels_allocd = 0;
/* current label number */
unsigned int labels_cur = 0;

/**
 * Raise an error */
void error(char * msg){
  printf("\nscpasm: error:\n%s\nAt:\n%s\n", msg, line);

  exit(1);
}

/**
 * read a byte from input, or return EOF if none are left */
int read_byte(){
  int c;

  while(1){
      /* make sure we haven't run out of files */
      if(!in_files[cur_in_file]){
        return EOF;
      }
    /* read */
    c = fgetc(in_files[cur_in_file]);
    if(feof(in_files[cur_in_file])){
      cur_in_file++;
    } else{
      break;
    }
  };

  return c;
}

/**
 * reset the position in the input files */
void reset_file(){
  int i = 0;
  while(in_files[i]){
    fseek(in_files[i], 0, SEEK_SET);
    i++;
  }
  cur_in_file = 0;
}

/**
 * output a value - either one bit, or a little endian two byte value */
void output_byte(uint8_t val){
  fputc(val, out_file);
}

void output_word(uint16_t word){
  fputc(word & 0x00ff, out_file);
  fputc(word >> 8, out_file);
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
 * find the instruction entry that matches the given cmd name, or return NULL if not a valid instruction */
struct instr_encoding * get_instr_entry(char * name) {
  for(unsigned int i = 0; i < num_instructions; i++){
    if(!strcmp(instructions[i].name, name)) {
      return instructions + i;
    }
  }
  return NULL;
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
      /* set val */
      arg->val = atoi(arg->str);
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
      if(!instr->args[arg_i].in_use){
        error("incorrect number of args passed");
      }
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
      /* make sure types are correct */
      arg_i++;
    }
    /* check if to many args were passed */
    if(instr->args[arg_i].in_use){
      error("incorrect number of args passed");
    }
  }
}

void usage(){
  printf("Usage: scpasm [options] files\nOptions:\n-o\tout\t:set output binary\n");
}

  struct instr in;

int main(int argc, char *argv[]){
  char * outfile = "a.out";
  int opt;
  /* read options */
  while((opt = getopt(argc, argv, "o:")) != -1) {
    switch(opt){
      case 'o':
        outfile = optarg;
        break;
      case '?':
        usage();
        exit(1);
      default:
        exit(1);
    }
  }
  /* open all source files */
  int i = 0;
  for(; optind < argc; optind++){
    in_files[i++] = fopen(argv[optind], "r");
    if(!in_files[i-1]){
      printf("scpasm: error: no such file %s\n", argv[optind]);
      exit(1);
    }
  }
  /* open output file */
  out_file = fopen(outfile, "w");
  /* make sure we have at least one file */
  if(i == 0){
    usage();
    exit(1);
  }

  /* run asm */
  while(!read_good_line()){
    line_into_instr(&in);
    check_instr(&in);
    printf("Name: %s, Opcode: %i, is_label: %u, is_dir: %u\n", in.name, in.opcode, in.is_label, in.is_dir);
    int a = 0;
    while(in.args[a].in_use){
      printf("\tArg: %s, Val: %u, Offset: %u, is_reg: %u reg: %u, is_alu: %u alu: %u, is_cond: %u cond: %u\n", in.args[a].str, in.args[a].val, in.args[a].offset, in.args[a].is_reg, in.args[a].reg,  in.args[a].is_alu, in.args[a].alu_op, in.args[a].is_cond, in.args[a].cond_code);
      a++;
    }
  }

  fclose(out_file);
}
