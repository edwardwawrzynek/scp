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

/* max space, including null, for a cmd opcode */
#define CMD_NAME_SIZE 17

/* maximum number of files that can be open */
#define MAX_FILES 50

enum arg_type {end_arg, reg, alu, cnst, label, cond};

struct instr {
  char * name;
  uint8_t opcode;
  enum arg_type types[10];
  char * encoding;
  /* which field to use as immeidate - 0=no immediate (opcode can't be immediate) */
  uint8_t imd_field;
};

/* IMPORTANT: 4 bit opcodes have to be specified as four bit - don't include blank bits for unused */
struct instr instructions[] = {
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

#define num_instructions sizeof(instructions)/sizeof(struct instr)

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
  /* module number, or -1 for no a global label */
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
  printf("scp asm: Error:\n%s\nAt:\n%s\n", msg, line);
  /* print carrot at lptr position */
  for(int i = 0; i < lptr; i++){
    if(line[i] == '\t'){
      printf("\t");
    } else {
      printf(" ");
    }
  }
  printf("^\n");

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
struct instr * get_instr_entry(char * name) {
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
 * skip the current arg */
void skip_arg(){
  while(!is_whitespace(line[lptr])){lptr++;}
  blanks();
}

/**
 * set the witespace after the current arg to a null, set lptr to after the null, and return the current arg */
char * get_arg(){
  blanks();
  char * arg = line + lptr;
  while(!is_whitespace(line[lptr]) && line[lptr] != '\0'){lptr++;}
  line[lptr++] = '\0';
  blanks();
  return arg;
}

/**
 * given an argument at line + lptr and its expected type, convert it to a binary representation
 * addr is the current address that the instruction including the value will be written to - used for pc relative addresses (note: for immediates, this is the addr of the instruction, not immediate)
 * this may error if the arg format doesn't match the */
uint16_t arg_to_bin(enum arg_type type, uint16_t addr) {
  switch(type) {
    case reg:
      /* strip off leading r */
      if(line[lptr++] != 'r'){
        /* allow sp as reg names */
        if(line[lptr-1] == 's' && line[lptr] == 'p'){
          lptr++;
          return 0xf;
        } else {
          error("argument expected to be of reg type");
        }
      }
      return hex2int(line[lptr++]);

    case alu:
      /* lookup operation */
      for(int op = 0; op < 16; op++){
        /* don't check undefined ops */
        if(alu_ops[op] == NULL){
          break;
        }
        int i = 0;
        int match = 1;

        while(!is_whitespace(line[i+lptr])){
          if(line[i+lptr] != alu_ops[op][i]){
            match = 0;
            break;
          }
          i++;
        }
        if(match) {
          /* move lptr to end of argument */
          lptr += i;
          return op;
        }
      }
      error("no such alu operation");

    case cnst:
      /* check if it is a constant or an adress */
      if(isdigit(line[lptr])){
        int past_lptr_cnst = lptr;
        uint16_t res = 0;

        get_arg();

        res = atoi(line + past_lptr_cnst);

        /* reset null */
        line[lptr-1] = ' ';
        return res;
      } else{
        /* get address of label, and warn that this will generate a non relocatable (until we get a better output format) */
       int past_lptr_label = lptr;

        get_arg();

        struct label * label = find_label(line + past_lptr_label, global_module);
        uint16_t real_addr = label->addr;

        printf("scpasm: Warning: binary is non relocatable because of the use of an address in a static initilization\n");

        /* reset null */
        line[lptr-1] = ' ';
        /* not independent (b/c it will be loaded as pointer) */
        return real_addr;
      }

    case label: ;
      /* check */
      int past_lptr_label = lptr;

      get_arg();

      struct label * label = find_label(line + past_lptr_label, global_module);
      uint16_t real_addr = label->addr;

      /* reset null */
      line[lptr-1] = ' ';
      /* check if there is an offset to add */
      int offset = 0;
      int mode = 0; /* 0=add, 1=sub */
      switch(line[lptr]){
        case '-':
          mode = 1;
        case '+':
          offset = atoi(get_arg());

          /* reset null */
          line[lptr-1] = ' ';

          if(mode == 1){
            offset = -offset;
          }
          break;
        default:
          break;
      }
      /* position independent */
      return real_addr-addr-2+offset;

    case cond:;
      /* condition codes are composed as a combination of chars:
      e - equal to bit(0)
      l - unsigned less than bit(1)
      g - unsigned greater than bit(2)
      L - signed less than bit(3)
      G - signed greather than bit(4)
      */
      char * code = get_arg();

      /* resulting code */
      uint8_t cond_code = 0;

      /* check for each char */
      if(strchr(code, 'e')){
        cond_code |= 0b1;
      }
      if(strchr(code, 'l')){
        cond_code |= 0b10;
      }
      if(strchr(code, 'g')){
        cond_code |= 0b100;
      }
      if(strchr(code, 'L')){
        cond_code |= 0b1000;
      }
      if(strchr(code, 'G')){
        cond_code |= 0b10000;
      }

      return cond_code;

    default:
        return 0;
  }
}

/** return a pointer to an instruction entry for the op currently in line */
struct instr * get_instr_line(){
  int i;
  char cmd[CMD_NAME_SIZE];
  struct instr * instr;

  blanks();
  /* copy in name */
  i = 0;
  while(!is_whitespace(line[lptr])){
    cmd[i++] = line[lptr++];
  }
  cmd[i] = '\0';

  /* find instr encoding entry */
  instr = get_instr_entry(cmd);
  if(instr == NULL) {
    error("no such instruction");
  }

  return instr;
}

/**
 * given an asm command currently in the buffer, encode it
 * return number of bytes written */
uint16_t encode_instr(uint16_t addr) {
  int i;

  struct instr * instr;

  /* resulting values for each arg - 0 is opcode, 1 is first arg, etc */
  uint16_t values[11];

  /* resulting instruction encoding */
  uint16_t instr_res = 0;

  /* the opcode to use */
  uint8_t opcode;

  instr = get_instr_line();

  /* get opcode */
  opcode = instr->opcode;
  /* set opcode in values */
  values[0] = opcode;

  /* go through each arg */
  i = 0;
  while(instr->types[i] != end_arg){
    blanks();
    if(line[lptr] == '\0'){
      error("not enough arguments provided");
    }
    values[i+1] = arg_to_bin(instr->types[i], addr);
    i++;
  }
  /* encode args */

  /* go backwards through arg encoding */
  i = strlen(instr->encoding)-1;
  while(i >= 0){
    /* get the value index to use */
    uint8_t value_index = hex2int(instr->encoding[i]);

    /* OR in the bit, and shift the instr right */
    instr_res >>= 1;
    /* OR in a zero if the bit is set as - */
    if(instr->encoding[i] != '-'){
      instr_res |= (values[value_index] & 1) << 15;
    }
    /* shift the value to the next bit */
    values[value_index] >>= 1;

    i--;
  }

  /* write out */
  output_word(instr_res);

  /* write out immediate */
  if(instr->imd_field){
    output_word(values[instr->imd_field]);
    return 4;
  }

  return 2;
}

/**
 * given an asembler directive in line, output it (and return the number of bytes written) */
uint16_t encode_dir(uint16_t addr){
  int i;
  char cmd[CMD_NAME_SIZE];

  blanks();
  /* copy in name */
  i = 0;
  while(!is_whitespace(line[lptr])){
    cmd[i++] = line[lptr++];
  }
  cmd[i] = '\0';

  if(!strcmp(cmd, ".module")){
    global_module++;
    return 0;
  } else if(!strcmp(cmd, ".global")){
    return 0;
  } else if(!strcmp(cmd, ".set_label")){
    return 0;
  } else if(!strcmp(cmd, ".dc.b") || !strcmp(cmd, ".dc.bs")){
    char * val_name = get_arg();
    uint16_t val = atoi(val_name);
    output_byte(val);
    return 1;
  } else if(!strcmp(cmd, ".dc.w")){
    char * val_name = get_arg();
    uint16_t val = atoi(val_name);
    output_word(val);
    return 2;
  } else if(!strcmp(cmd, ".dc.l")){
    char * val_name = get_arg();
    uint32_t val = atoi(val_name);
    output_word(val&0xffff);
    output_word(val>>16);
    return 4;
  } else if(!strcmp(cmd, ".align")){
    if(addr & 1){
      output_byte(0);
      return 1;
    }
    return 0;
  } else if(!strcmp(cmd, ".ds")){
    char * val_name = get_arg();
    uint16_t val = atoi(val_name);
    for(int i = 0; i < val; i++){
      output_byte(0);
    }
    return val;
  }

  error("no such directive b");
  return 0;
}

/**
 * get the size of the directive in line */
uint16_t dir_size(uint16_t addr){
  int i;
  char cmd[CMD_NAME_SIZE];

  blanks();
  /* copy in name */
  i = 0;
  while(!is_whitespace(line[lptr])){
      cmd[i++] = line[lptr++];
  }
  cmd[i] = '\0';

  if(!strcmp(cmd, ".module")){
    global_module++;
    return 0;
  } else if(!strcmp(cmd, ".global")){
    /* add global label */
    skip_arg();
    /* get label entry */
    struct label * label = find_label(get_arg(), global_module);
    label->module = -1;
    return 0;
  } else if(!strcmp(cmd, ".set_label")){
    skip_arg();
    char * name = get_arg();
    char * addr_name = get_arg();
    uint16_t addr = atoi(addr_name);
    add_label(name, -1, addr);
    return 0;
  } else if(!strcmp(cmd, ".dc.b") || !strcmp(cmd, ".dc.bs")){
    return 1;
  } else if(!strcmp(cmd, ".dc.w")){
    return 2;
  } else if(!strcmp(cmd, ".dc.l")){
    return 4;
  } else if(!strcmp(cmd, ".align")){
    return addr & 1;
  } else if(!strcmp(cmd, ".ds")){
    char * val_name = get_arg();
    uint16_t val = atoi(val_name);
    return val;
  }

  error("no such directive");
  return 0;
}

/**
 * return the label (really a pointer to line) if the line is a label, NULL otherwise */
char * is_label(){
  if(!is_whitespace(line[0])){
    char * end = strchr(line, ':');
    if(!end){
      error("label must end in :");
    }
    *end = '\0';
    return line;
  }
  return NULL;
}


/**
 * get the size of the command in line */
uint16_t cmd_size(uint16_t addr){
  struct instr * instr;

  instr = get_instr_line();

  /* if the cmd takes an immediate, 4 bytes, 2 otherwise */
  return instr->imd_field ? 4 : 2;
}

/**
 * run the first pass, return the number of bytes */
uint16_t first_pass(){
  uint16_t addr = 0;
  /* module number */
  global_module = 0;

  reset_file();

  while(!read_good_line()) {
    /* handle labels */
    char * label = is_label();
    if(label){
      add_label(label, global_module, addr);
    } else {
      blanks();
      /* check if it is a directive */
      if(line[lptr] == '.'){
        addr += dir_size(addr);
      } else{
        addr += cmd_size(addr);
      }
    }
  }

  return addr;
}

/**
 * run the second pass, writing out bytes
 * returns number of bytes written (to make sure it is consistent with first_pass) */
uint16_t second_pass(){
  uint16_t addr = 0;
  /* module number */
  global_module = 0;

  reset_file();

  while(!read_good_line()) {
    /* handle labels */
    char * label = is_label();
    if(!label){
      if(line[lptr] == '.'){
        addr += encode_dir(addr);
      } else{
        addr += encode_instr(addr);
      }
    }
  }

  return addr;
}

void usage(){
  printf("Usage: scpasm [options] files\nOptions:\n-o\tout\t:set output binary\n");
}

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
  uint16_t first_res = first_pass();
  uint16_t second_res = second_pass();

  if(first_res != second_res){
    error("Number of bytes written and calculated don't match");
  }

  fclose(out_file);
}

/*
int main(int argc, char **argv){
  if(argc != 3){
    printf("Usage: scpasm [out.bin] [in.s]\n");
    exit(1);
  }

  out_file = fopen(argv[1], "w");
  in_file = fopen(argv[2], "r");

  if(in_file == NULL){
    printf("Open Failure\n");
    exit(1);
  }

  uint16_t first_res = first_pass();
  uint16_t second_res = second_pass();

  if(first_res != second_res){
    error("Number of bytes written and calculated don't match");
  }

  fclose(out_file);
  fclose(in_file);
}
*/