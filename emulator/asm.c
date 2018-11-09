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
      "000000--22221111" }
};

/* alu op names */

char * alu_ops[16] = {"bor", "bxor", "band", "lsh", "ursh", "srsh", "add", "sub", "mul", "bneg", "neg"};

#define num_instructions sizeof(instructions)/sizeof(struct instr)

char line[LINE_SIZE];
int lptr;

/* input file */
FILE * in_file;
/* output file */
FILE * out_file;

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
 * reset lptr
 * return 0 on success, 1 on eof*/
uint8_t read_line() {
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

    return feof(in_file);
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
            for(int op = 0; op < 16; op++){
                /* don't check undefined ops */
                if(alu_ops[op] == NULL){
                    break;
                }
                int i = 0;
                int match = 1;

                while(line[i+lptr] != ' '){
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
            /* make sure the constant starts with a # */
            if(line[lptr++] != '#'){
                error("argument expected to be of constant type (starting with #)");
            }
            int past_lptr = lptr;
            uint16_t res = 0;

            /* set space to null to use atoi */
            while(!is_whitespace(line[lptr]) && line[lptr] != '\0'){lptr++;};
            line[lptr] = '\0';

            res = atoi(line + past_lptr);

            /* reset null */
            line[lptr] = ' ';
            return res;

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

    /* resulting values for each arg - 0 is opcode, 1 is first arg, etc */
    uint16_t values[11];

    /* resulting instruction encoding */
    uint16_t instr_res = 0;

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
    /* set opcode in values */
    values[0] = opcode;

    /* go through each arg */
    i = 0;
    while(instr->types[i] != end_arg){
        blanks();
        if(line[lptr] == '\0'){
            error("not enough arguments provided");
        }
        values[i+1] = arg_to_bin(instr->types[i], 0);
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
    }


}

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
    while(1){
        if(read_good_line()){
            break;
        }
        encode_instr();
    }

    fclose(out_file);
    fclose(in_file);


}