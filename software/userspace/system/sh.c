#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <stdarg.h>
#include <assert.h>


/*
SCP shell
very basic shell
no variables or control structures
just redirection and piping
*/

#define MAXCMDSIZE 256
#define MAXARGS 32
#define MAXPIPES 8

/* input file - may be stdin */
FILE * file_in;

/* line be read, along with current position in processing */
char line[MAXCMDSIZE+1];
char * line_pos;

int interactive_flag = 0;

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
    uint8_t in_background;
};

struct cmd * alloc_cmd() {
    struct cmd * res = malloc(sizeof(struct cmd));
    assert(res != NULL);
    res->cmd = NULL;
    memset(res->args, 0, MAXARGS);
    res->args_index = 0;
    res->redir_in = NULL;
    res->redir_out = NULL;
    res->in_background = 0;

    return res;
}

void free_cmd(struct cmd * cmd) {
    free(cmd->cmd);
    free(cmd->redir_in);
    free(cmd->redir_out);
    for(int i = 0; i < MAXARGS; i++) {
        free(cmd->args[i]);
    }

    free(cmd);
}

char * copy_to_malloc(char * str) {
    char * res = malloc(strlen(str) + 1);
    assert(res != NULL);
    strcpy(res, str);
    return res;
}

int exec_cmd_no_fork(struct cmd * cmd, pid_t input_pipe, pid_t output_pipe) {
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
        close(fd);
    }
    if(cmd->redir_out != NULL) {
        int fd = open(cmd->redir_out, O_CREAT | O_TRUNC | O_WRONLY);
        if(fd == -1) {
            fprintf(stderr, "sh: can't open %s: ", cmd->redir_out);
            perror(NULL);
            return 1;
        }
        dup2(fd, STDOUT_FILENO);
        close(fd);
    }

    /* handle pipes if we need to */
    if(input_pipe != -1) {
        dup2(input_pipe, STDIN_FILENO);
        close(input_pipe);
    }
    if(output_pipe != -1) {
        dup2(output_pipe, STDOUT_FILENO);
        close(output_pipe);
    }

    /* set null in args */
    cmd->args[cmd->args_index] = NULL;

    /* actually execute */
    if(execv(cmd->cmd, cmd->args) == -1) {
        perror("sh: no such command");
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

/* proc pids to wait for (or -1 to not wait) */
pid_t proc_pid_wait[MAXPIPES];
pid_t proc_pid_wait_index = 0;

pid_t proc_pid_wait_get_index(pid_t pid) {
    for(int i = 0; i < proc_pid_wait_index; i++) {
        if(proc_pid_wait[i] == pid){
            return i;
        }
    }
    return -1;
}

int16_t get_num_procs_waiting() {
    int16_t res = 0;
    for(int i = 0; i < proc_pid_wait_index; i++) {
        if(proc_pid_wait[i] != -1){
            res++;
        }
    }
    return res;
}

struct cmd * cmds[MAXPIPES];
uint16_t cmds_index = 0;

int exec_cmds() {
    proc_pid_wait_index = 0;
    pid_t pipe_pids[2];

    for(int i = 0; i < cmds_index; i++) {
        struct cmd * cmd = cmds[i];
        if(!strcmp(cmd->cmd, "cd")) {
            return exec_cd(cmd);
        } else if(!strcmp(cmd->cmd, "exit")) {
            exit(0);
        } else {
            pid_t input_pipe = -1, output_pipe = -1;
            if(i > 0) {
                input_pipe = pipe_pids[0];
            }
            if(i < cmds_index -1) {
                /* pipe */
                pipe(pipe_pids);
                output_pipe = pipe_pids[1];
            }
            pid_t pid = fork();
            if(pid == 0) {
                exec_cmd_no_fork(cmd, input_pipe, output_pipe);
                /* if we failed to exec, fail with error */
                exit(255);
            } else {
                if(input_pipe != -1) close(input_pipe);
                if(output_pipe != -1) close(output_pipe);
                if(cmd->in_background == 0) {
                    proc_pid_wait[proc_pid_wait_index++] = pid;
                }
            }
        }
    }

    int ret_val;
    while(get_num_procs_waiting() > 0) {
        int ret_pid = wait(&ret_val);
        int pid_index = proc_pid_wait_get_index(ret_pid);
        /* make sure we were actually waiting on this command */
        if(pid_index != -1) {
            proc_pid_wait[pid_index] = -1;
        }
    }
    return ret_val;
}

/* run main loop (0 to re-run, 1 to exit */
int mainloop() {
    cmds_index = 0;
    if(interactive_flag) printf("$ ");
    if(feof(file_in)) return 1;
    readline();
    /* step in parsing */
    enum parsing_mode mode = CMD;
    /* current symbol we are on */
    char * sym;

    struct cmd * res = alloc_cmd();
    cmds[cmds_index++] = res;
    
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
        if(!strcmp(sym, "&")) {
            res->in_background = 1;
            continue;
        }
        if(!strcmp(sym, "|")) {
            mode = CMD;
            res = alloc_cmd();
            cmds[cmds_index++] = res;
            continue;
        }
        switch(mode) {
            case CMD:
                res->cmd = copy_to_malloc(sym);
                res->args[res->args_index++] = copy_to_malloc(sym);
                mode = ARGS;
                break;
            case ARGS:
                res->args[res->args_index++] = copy_to_malloc(sym);
                break;
            case REDIR_IN:
                res->redir_in = copy_to_malloc(sym);
                break;
            case REDIR_OUT:
                res->redir_out = copy_to_malloc(sym);
                break;
            default:
                break;
        }

    } while (true);

    exec_cmds();
    //free cmd objects
    for(int i = 0; i < cmds_index; i++) {
        free_cmd(cmds[i]);
    }

    return 0;
}

void print_usage() {
    fprintf(stderr, "usage: sh [options] [file]\noptions:\n-i\tinteractive mode\n-h\tprint help\n");
    exit(1);
}

/* main */
int main(int argc, char ** argv){
    int i;
    while((i = getopt(argc, argv, "ih")) != -1) {
        switch(i) {
            case 'i':
                interactive_flag = 1;
                break;
            case 'h':
            default:
                print_usage();
                break;
        }
    }
    if(interactive_flag) printf("SCP SH v0.1\n");

    if(optind >= argc){
        file_in = stdin;
    } else {
        file_in = fopen(argv[optind], "r");
        if(file_in == NULL){
            fprintf(stderr, "couldn't open file: %s\n", argv[optind]);
            exit(1);
        }
    }
    
    while(!mainloop());

    return 0;
}
