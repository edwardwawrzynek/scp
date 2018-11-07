#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/* max line length - including newline */
#define LINE_SIZE 81
/* max label length - including null */
#define LABEL_SIZE 33
/* number of labels to alloc per each expansion */
#define REALLOC_AMOUNT 64

/* max space, including null, for a cmd opcode */
#define CMD_NAME_SIZE 17

enum arg_type {reg, alu, cnst, label, end_arg};

struct instr {
    char * name;
    uint8_t opcode;
    enum arg_type types[10];
    char * encoding;
};

struct instr instructions[] = {
  { "nop.n.n", 0b000000, {},              /* nop.n.n */
      "000000----------" },
  { "mov.r.r", 0b000001, {reg, reg, end_arg},      /* mov.r.r dst src */
      "000000--22221111" },
  { "alu.r.r", 0b000100, {alu, reg, reg, end_arg}, /* alu.r.r op dst src */
      "0000111133332222" },
  { "alu.r.i", 0b001000, {alu, reg, cnst, end_arg},/* alu.r.i op dst imd */
      "00001111----2222 3333333333333333" },
  { "cmp.r.f", 0b000010, {reg, reg, end_arg},      /* cmp.r.f reg1 reg2 */
      "000000--22221111" }
};

#define num_instructions sizeof(instructions)/sizeof(struct instr)

char line[LINE_SIZE];
int lptr;

/* input file */
FILE * in_file;

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
 * returns NULL if none is found */
struct label * find_label(char * name, int16_t module) {

    for(unsigned int i = 0; i < labels_cur; i++){
        /* match name and module, or ignore module if global */
        if(!strcmp(name, labels[i].name)){
            if(labels[i].module == module || labels[i].module == -1){
                return labels + i;
            }
        }
    }

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
    while(is_whitespace(line[lptr])) {lptr++;};
}

/**
 * read a line from a file into the line buffer
 * reset lptr */
void read_line() {
    char c;
    lptr = 0;
    do {
        c = fgetc(in_file);
        /* stop at newline */
        if(c == '\n' || c == EOF) {
            c = '\0';
        }
        line[lptr++] = c;
    } while (c != '\0');
    lptr = 0;
}

/**
 * read in lines until a non-whitespace, non-comment line is read */
void read_good_line(){
    do {
        read_line();
        blanks();
        /* read next line if this line was a comment or just whitespace */
    } while (line[lptr] == ';' || line[lptr] == '\0');
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
 * given an argument at line + lptr and its expected type, convert it to a binary representation
 * addr is the current address that the value will be written to - used for pc relative addresses
 * this may error if the arg format doesn't match the */
uint16_t arg_to_bin(enum arg_type type, uint16_t addr) {
    switch(type) {
        case reg:
            /* strip off leading r */
            if(line[lptr++] != 'r'){
                error("argument expected to be of reg type");
            }
            return hex2int(line[lptr++]);
        case alu:
            /* lookup operation */

        case cnst:

        case label:

        default:
            return 0;
    }
}

/**
 * given an asm command currently in the buffer, encode it */
void encode_instr() {
    int i;

    char cmd[CMD_NAME_SIZE];
    struct instr * instr;

    /* resulting instruction encoding */
    uint16_t instr_res = 0;
    /* resulting immediate encoding */
    uint16_t imd_res = 0;

    /* the opcode to use */
    uint8_t opcode;

    blanks();
    /* copy in name */
    i = 0;
    while(line[lptr] != ' '){
        cmd[i++] = line[lptr++];
    }
    cmd[i] = '\0';

    /* find instr encoding entry */
    instr = get_instr_entry(cmd);
    if(instr == NULL) {
        error("no such instruction");
    }

    /* get opcode */
    opcode = instr->opcode;

    /* go through each arg */
    i = 0;
    while(instr->types[i] != end_arg){
        blanks();
        printf("%u\n", arg_to_bin(instr->types[i], 0));
        i++;
    }


}

int main(int argc, char **argv){
    if(argc != 2){
        printf("Usage: scpasm [in.s]\n");
        exit(1);
    }

    in_file = fopen(argv[1], "r");

    if(in_file == NULL){
        printf("Open Failure\n");
        exit(1);
    }
    read_good_line();
    encode_instr();


}