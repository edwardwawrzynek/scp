#ifndef _DEFSH
#define _DEFSH

/* max line length - including newline */
#define LINE_SIZE 81
/* max label length - including null */
#define LABEL_SIZE 64
/* number of labels to alloc per each expansion */
#define REALLOC_AMOUNT 64
/* maximum number of files that can be open */
#define MAX_FILES 50
/* maximum number of args to any instruction */
#define MAX_ARGS 10
/* max length (with null) of an instruction argument */
#define ARG_LEN 64
/* max length of an arg */
#define CMD_NAME_SIZE 64

/* max number of asm commands - only changed during dev */
#define MAX_CMDS 64
/* max number of directives - only changed during dev*/
#define MAX_DIRS 64
#endif