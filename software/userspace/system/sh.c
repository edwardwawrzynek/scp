#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <stdarg.h>

/*
SCP shell
a lisp like shell with shorthands to make it somewhat bash-like
*/

/* type system */
struct type {
    /* TODO: method table, etc */
};

union var_union {
    /* ints */
    int int_val;
    /* strings (malloc'd) */
    char * int_str;
    /* arrays (malloc'd) */
    struct var * int_arr;
};

struct var {
    union var_union val;
    struct var_type * type;
};

/* parsed command representation */
enum branch_type {
    NONE,
    CMD,    /* normal command: (func arg1 arg2 (func2 arg3 arg4) arg5) */
    CMD_RET,    /* sys command return value: (^ mkdir test) */
    SUBSH,  /* subshell command wrapper: <(func1 arg1) (func2 arg2)> */
    CODE,   /* code block: {(func1 arg1) (func2 arg2)} */
    LEAF,   /* leaf of a command: arg1 */
};

struct branch{
    /* type of the branch */
    enum branch_type type;
    /* cmd string (malloc'd), or, in LEAF's, LEAF content (malloc'd) */
    char * cmd;
    /* number of children */
    unsigned int num_branches;
    /* child branches */
    struct branch ** children;
};

/* parsing notes:
 * two modes: full paren mode and single line
 * full paren is simple
 * single line:
 *  newline, &, and | are interpreted as end of command
 * in full paren mode, & and | are still supported, but, if they are unexpected, they error instead of end of command */

/* init a branch */
struct branch * branch_new(){
    struct branch * res = malloc(sizeof(struct branch));
    if(res == NULL){
        return NULL;
    }
    memset(res, 0, sizeof(struct branch));
    return res;
}

/* set cmd in a branch (realloc and copy) */
void branch_set_cmd(struct branch *b, char *cmd){
    /* free and alloc needed memory */
    unsigned int length = strlen(cmd)+1;
    if(b->cmd == NULL){
        b->cmd = malloc(length);
    } else {
        b->cmd = realloc(b->cmd, length);
    }
    strcpy(b->cmd, cmd);
}

/* add child to branch */
void branch_add_child(struct branch *parent, struct branch *child){
    /* expand child array */
    parent->num_branches++;
    parent->children = realloc(parent->children, parent->num_branches * sizeof(struct branch *));

    /* add branch */
    parent->children[parent->num_branches-1] = child;
}

/* set type of branch */
void branch_set_type(struct branch *b, enum branch_type type){
    b->type = type;
}

/* free branch's resources, then free the branch itself */
void branch_free(struct branch * b){
    /* don't handle branch type - free any resources that may be associated */
    if(b->cmd != NULL){
        free(b->cmd);
    }
    for(unsigned int i = 0; i < b->num_branches; i++){
        branch_free((b->children[i]));
    }
    free(b->children);
    free(b);
}

/* print an ast representation of a branch */
void print_branch(struct branch * b, int indent){
    for(int i = 0; i < indent; i++){
        printf("  ");
    }
    if(b->type == LEAF){
        printf("%s: leaf\n", b->cmd);
    } else {
        printf("%s: branch type: %u, children: %u\n", b->cmd, b->type, b->num_branches);
        for(int i = 0; i < b->num_branches; i++){
            print_branch(b->children[i], indent+1);
        }
    }
}

/* io routines */

FILE * fin;
/* read a char from input */
char io_raw_char(){
    return fgetc(fin);
}

/* go back one char in feed TODO: buffer to do this */
void io_back(){
    fseek(fin, -1, SEEK_CUR);
}

/* read chars, handling comments */
char io_char(){
    /* # marks a single line comment, #> followed by #< multiline */
    static uint8_t is_com = 0;
    static uint8_t is_multi_com = 0;
    char c;
    do {
        c = io_raw_char();
        if(c == EOF){
            return EOF;
        }
        /* handle single line comments */
        if(is_com && c == '\n'){
            is_com = 0;
            continue;
        }
        if(!is_com && c == '#'){
            is_com = 1;
        }
        /* multi line */
        if(is_com && c == '>'){
            is_multi_com = 1;
            is_com = 0;
        }
        if(is_multi_com && is_com == 1 && c == '<'){
            is_com = 0;
            is_multi_com = 0;
        }

    } while(is_com || is_multi_com);

    return c;
}

/* io routine to skip whitespace chars */
void io_skip_whitespace(bool skip_lf){
    char c;
    do {
        c = io_char();
    } while (isspace(c) && (skip_lf || c != '\n'));
    io_back();
}

/* read an alphanumeric name (including _) into a malloc'd buffer, and stop on whitespace or non alphanumerical character
 * buffer will be overwritten on successive calls
 * return NULL if no symbol was read
 * if op_allowed is true, +, -, *, /, %, =, >, < are allowed*/
char * io_read_symbol(bool op_allowed){
    static char * buf = NULL;
    static size_t buf_size = 0;

    char c;
    size_t pos = 0;
    /* shrink buffer if it has grown beyond what it will reasonable often grow to */
    if(buf_size > 256){
        buf = realloc(buf, 32);
        buf_size = 32;
    }
    do {
        c = io_char();
        if(!isalnum(c) && c != '_' && c != '"' && c != '\''){
            if(!op_allowed)
                c = '\0';
            else
                if(c != '+' && c != '-' && c != '*' && c != '/' && c != '%' && c != '>' && c != '<' && c != '=' && c != '!')
                    c = '\0';
        }
        /* expand buffer if needed */
        if(pos+1>buf_size){
            buf = realloc(buf, buf_size+32);
            buf_size+=32;
        }
        buf[pos++] = c;

    } while(c != '\0');

    if(pos <= 1){
        return NULL;
    }
    io_back();
    return buf;
}

/* test the next char, consume and return true if it is the char, go back otherwise */
bool io_test_char(char c){
    if(io_char() == c){
        return true;
    }
    io_back();
    return false;
}

/**
 * recursive parser code
 *
 * basiclly just parse statments, which consist of lists of leafs or more staments enclosed in (), <>, or {}
 * single line mode is activated when an opening paren/bracket is missing, and treats a newline, |, or & as an ending paren/bracket
 * */

/* throw an error */
void parse_error(char *error, ...)
{
    va_list args;

    va_start(args, error);
    fputs("parse error: ", stderr);
    vfprintf(stderr, error, args);
    fputs("\n", stderr);
    va_end(args);

    exit(1);
}

/* check if char is bracket allowed to start section or not */
bool isbracket(char c){
    return
        c == '(' || c == ')' || c == '{' || c == '}' || c == '<' || c == '>';
}

bool isopenbracket(char c){
    return
        c == '(' || c == '{' || c == '<';
}

bool isclosebracket(char c){
    return isbracket(c) && !isopenbracket(c);
}

enum branch_type parse_bracket_to_type(char c){
    if(c == '(' || c == ')')
        return CMD;
    if(c == '{' || c == '}')
        return CODE;
    if(c == '<' || c == '>')
        return SUBSH;

    return NONE;
}

char branch_get_closing_bracket(struct branch * b){
    enum branch_type type = b->type;

    if(type == CMD || type == CMD_RET)
        return ')';
    if(type == CODE)
        return '}';
    if(type == SUBSH)
        return '>';
}

/* main parser (clas to it should pass a blank branch for it to manipulate) */
void parse(struct branch * branch){
    bool line_mode = 0;

    io_skip_whitespace(!line_mode);
    /* look for paren, or enable line mode otherwise */
    char c = io_char();
    if(isopenbracket(c)){
        line_mode = 0;
        branch->type = parse_bracket_to_type(c);
        io_skip_whitespace(!line_mode);
    } else {
        line_mode = 1;
        branch->type = CMD;
        io_back();
    }

    /* handle (^ sys-cmd args) syntax */
    if(io_test_char('^') && branch->type == CMD){
        branch->type = CMD_RET;
        io_skip_whitespace(!line_mode);
    }

    /* read command (only present in cmds) */
    if(branch->type == CMD || branch->type == CMD_RET){
        char * cmd = io_read_symbol(true);
        if(cmd == NULL){
            parse_error("expected function name");
        }
        branch_set_cmd(branch, cmd);
    }

    /* read args (only present in cmds) */
    while(branch->type == CMD || branch->type == CMD_RET){
        io_skip_whitespace(!line_mode);
        /* we have to have parens for nested args, even in line mode */
        char c = io_char();
        if(isopenbracket(c)){
            io_back();
            struct branch * child = branch_new();
            parse(child);
            branch_add_child(branch, child);
        } else {
            /* handle closing of func */
            if(isclosebracket(c) || (c == '\n' && line_mode)){
                if(!line_mode && branch_get_closing_bracket(branch) != c){
                    parse_error("expected '%c' to close", branch_get_closing_bracket(branch));
                }
                return;
            } else {
                io_back();
                /* handle simple arg */
                char * arg = io_read_symbol(false);
                if(arg == NULL){
                    parse_error("expected arg");
                }
                struct branch * child = branch_new();
                child->type = LEAF;
                branch_set_cmd(child, arg);
                branch_add_child(branch, child);
            }
        }
    }
    /* else, all args have to be commands, potentially in line mode */
    while(branch->type == CODE || branch->type == SUBSH){
        io_skip_whitespace(!line_mode);

        char c = io_char();
        /* handle closing of func */
        if(isclosebracket(c) || (c == '\n' && line_mode)){
            if(!line_mode && branch_get_closing_bracket(branch) != c){
                parse_error("expected '%c' to close", branch_get_closing_bracket(branch));
            }
            return;
        }
        io_back();

        struct branch * child = branch_new();
        parse(child);
        branch_add_child(branch, child);
    }
    return;

}

/* main TODO: handle args on command line or interactive mode */
void main(int argc, char ** argv){
    if(argc != 2){
        fprintf(stderr, "usage: sh file\n");
        exit(1);
    }
    fin = fopen(argv[1], "r");
    if(fin == NULL){
        fprintf(stderr, "couldn't open file: %s\n", argv[1]);
    }
    struct branch * prgm = branch_new();
    parse(prgm);
    print_branch(prgm, 0);
}