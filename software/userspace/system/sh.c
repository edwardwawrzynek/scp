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
very basic shell
no variables or control structures
just redirection and piping
*/

#define MAXCMDSIZE 256
#define MAXARGS 32

/* input file - may be stdin */
FILE * file_in;

/* line be read, along with current position in processing */
char line[MAXCMDSIZE+1];
char * line_pos;


/* read a line into the buffer */
void readline() {
    fgets(line, MAXCMDSIZE, file_in);
    line_pos = line;
}

/* return a pointer to the next symbol (chars seperated by whitespace in the buffer) */
char * get_next_sym() {
    /* skip whitespace */
    while(isspace(*line_pos) && *line_pos != '\0'){
        line_pos++;
    }
    /* we previously marked end */
    if(*line_pos == '\0') return '\0';
    char * initial = line_pos;
    /* initial now points to start of string */
    /* move line_pos past end of current string, set null */
    while(!isspace(*line_pos) && *line_pos != '\0') {
        line_pos++;
    }
    /* if we hit a null (end of string), mark char after it */
    if(*line_pos == '\0') {
        *(line_pos++) = '\0';
        *line_pos = '\0';
    } else {
        *(line_pos++) = '\0';
    }
    return initial;
}

enum parsing_mode {
    CMD, ARGS, REDIR_OUT, REDIR_IN
};

struct cmd {
    char * cmd;
    char * args[MAXARGS];
    uint16_t args_index;
    char * redir_in;
    char * redir_out;
};

struct cmd current_cmd;

int exec_cmd_no_fork(struct cmd * cmd) {
    int fd_redir_out = STDOUT_FILENO;
    int fd_redir_in = STDIN_FILENO;

    /* do redirection */
    if(cmd->redir_in != NULL) {
        int fd = open(cmd->redir_in, O_RDONLY);
        if(fd == -1) {
            fprintf(stderr, "sh: can't open %s: ", cmd->redir_in);
            perror(NULL);
            return 1;
        }
        dup2(fd, STDIN_FILENO);
    }
    if(cmd->redir_out != NULL) {
        int fd = open(cmd->redir_out, O_CREAT | O_TRUNC | O_WRONLY);
        if(fd == -1) {
            fprintf(stderr, "sh: can't open %s: ", cmd->redir_out);
            perror(NULL);
            return 1;
        }
        dup2(fd, STDOUT_FILENO);
    }

    /* set null in args */
    cmd->args[cmd->args_index] = NULL;

    /* actually execute */
    if(execv(cmd->cmd, cmd->args) == -1) {
        perror("sh: execution failed: ");
    }
    
}

int exec_cd(struct cmd * cmd) {
    if(cmd->args_index != 2) {
        fprintf(stderr, "sh: cd: too many arguments\n");
        return 1;
    }
    if(chdir(cmd->args[1])) {
        fprintf(stderr, "sh: cd: %s: ", cmd->args[1]);
        perror(NULL);
        return 1;
    }
    return 0;
}

int exec_cmd(struct cmd * cmd) {
    if(!strcmp(cmd->cmd, "cd")) {
        return exec_cd(cmd);
    } else if(!strcmp(cmd->cmd, "exit")) {
        exit(0);
    } else {
        if(fork() == 0) {
            exec_cmd_no_fork(cmd);
            /* if we failed to exec, fail with error */
            exit(255);
        }
        uint8_t ret_val;
        wait(&ret_val);
        return ret_val;
    }
}

/* run main loop (0 to re-run, 1 to exit */
int mainloop() {
    printf("$ ");
    if(feof(file_in)) return 1;
    readline();
    /* step in parsing */
    enum parsing_mode mode = CMD;
    /* current symbol we are on */
    char * sym;

    struct cmd * res = &current_cmd;
    memset(res, 0, sizeof(struct cmd));
    
    do{
        sym = get_next_sym();
        if(sym == NULL) break;
        if(!strcmp(sym, ">")) {
            mode = REDIR_OUT;
            continue;
        }
        if(!strcmp(sym, "<")) {
            mode = REDIR_IN;
            continue;
        }
        switch(mode) {
            case CMD:
                res->cmd = sym;
                res->args[res->args_index++] = sym;
                mode = ARGS;
                break;
            case ARGS:
                res->args[res->args_index++] = sym;
                break;
            case REDIR_IN:
                res->redir_in = sym;
                break;
            case REDIR_OUT:
                res->redir_out = sym;
                break;
            default:
                break;
        }

    } while (true);

    exec_cmd(res);

    return 0;
}

/* main TODO: handle args on command line or interactive mode */
int main(int argc, char ** argv){
    printf("SCP SH v0.1\n");
    if(argc != 2){
        if(argc == 1) {
            file_in = stdin;
        } else {
            fprintf(stdout, "usage: sh file\n");
            exit(1);
        }
    } else {
        file_in = fopen(argv[1], "r");
        if(file_in == NULL){
            fprintf(stdout, "couldn't open file: %s\n", argv[1]);
        }
    }
    
    while(!mainloop());

    return 0;
}
