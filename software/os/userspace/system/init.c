#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>
#include <string.h>

/**
 *  System init process run after kernel starts up. Stored in binary /init
 * init starts without any stdin, out, or err, and has to read from
 * /initrc file to know what to start
 * Exit Codes:
 * 1 - no initrc
 * 2 - initrc formatting error
 * 3 - can't open specified dev
 * 4 - failure to duplicated dev to stdin out and err
 * 5 - execution of cmd failed (probably no such bin)
 * 6 - failure waiting for w child
 * 7 - no children left
 * 8 - failure respawning
 */

/**
 * initrc is a file containing any number of lines of the following:
 *
 * action:terminal:command
 *
 * where action is one of the following:
 * o - start the command and don't wait for it to end
 * r - start the command, don't wait for it to end, and restart if it dies
 * w - start the command and wait for it to end
 *
 * terminal is an absolute path to the terminal to put the command on,
 * and command is the command to run
 *
 * Example:
 * w:/dev/tty0:/bin/fsck
 * r:/dev/tty0:/bin/sh
 * r:/dev/serial0:/bin/sh
 *
 * (runs fsck (outputting on tty0 if errors), then start sh on tty0 and serial0)
 */

#define MAX_NUM_RESPAWN 16
#define MAX_LINE_SIZE 128

#define MAX_DEV_SIZE 32
#define MAX_CMD_SIZE 32

/* buffer for initrc lines */
uint8_t line_buf[MAX_LINE_SIZE];


/* structure representing parsed line in initrc */
struct initrc_cmd {
    /* mode (char) */
    uint8_t mode;
    /* dev file */
    uint8_t dev_file[MAX_DEV_SIZE];
    /* command */
    uint8_t cmd[MAX_CMD_SIZE];
    /* pid of started process */
    uint16_t pid;
};

/* list of respawn initrc_cmds */
struct initrc_cmd respawn[MAX_NUM_RESPAWN];
uint16_t respawn_index;

/* read line into buf. return -1 on error, 0 on eof, and number of bytes read
 * (not including \n). Doesn't write \n into buffer */
uint16_t read_line(uint16_t fd, uint8_t * buf){
    uint16_t bytes = 0;

    while(1) {
        int res = read(fd, buf, 1);
        if(res == -1){
            return -1;
        }
        else if (res == 0){
            return 0;
        }
        if(*buf == '\n'){
            *buf = '\0';
            return bytes;
        }

        buf++;
        bytes++;
    }
}

/* parse a line into the passed initrc_cmd */
void line_to_initrc(struct initrc_cmd * cmd, uint8_t *line, int line_len){
    uint16_t pos = 0;
    if(line_len < 3){
        exit(2);
    }
    cmd->mode = line[pos++];
    if(line[pos++] != ':'){
        exit(2);
    }
    uint8_t * dev = &line[pos];
    /* change : to null */
    while(line_buf[pos++] != ':' && pos < line_len);
    if(pos >= line_len){
        exit(2);
    }
    line_buf[pos-1] = '\0';
    uint8_t * cmd_name = &line[pos];

    strncpy(cmd->dev_file, dev, MAX_DEV_SIZE);
    strncpy(cmd->cmd, cmd_name, MAX_CMD_SIZE);
    return;
}

/* run a command in an initrc_cmd struct. Needs fork beforehand. initrc fd should be
 * already closed
 * return on failure */
uint16_t exec_cmd(struct initrc_cmd * cmd){
    int devfd_o = open(cmd->dev_file, O_RDWR);
    if(devfd_o == -1){
        return 3;
    }
    /* copy devfd_o to fd 4 */
    int devfd = dup2(devfd_o, 4);
    if(devfd == -1)
        return 4;
    /* duplicate to stdin, out, err */
    if(dup2(devfd, STDIN_FILENO) == -1)
        return 4;
    if(dup2(devfd, STDOUT_FILENO) == -1)
        return 4;
    if(dup2(devfd, STDERR_FILENO) == -1)
        return 4;

    /* close dev file (dev_fd_o was closed by dup) */
    if(close(devfd) == -1)
        return 4;

    /* TODO: seperate command on spaces and pass as argv */
    execv(cmd->cmd, NULL);

    return 5;
}

/* handle waiting for / adding to respawn list of command after calling exec_cmd.
 * this should be called in parent init, not forked */
void wait_respawn_cmd(struct initrc_cmd *cmd, uint16_t is_first_run){
    /* if mode was w, wait for proc to finish */
    if(cmd->mode == 'w'){
        if(wait(NULL) == -1)
            exit(6);
    }
    /* if mode was r, add to list to respawn,
     * or, if already existing, don't do anything */
    else if(cmd->mode == 'r'){
        if(is_first_run){
            memcpy(&respawn[respawn_index++], cmd, sizeof(struct initrc_cmd));
        }
    }
    /* don't do anything for mode o */
}

/* run a command */
void run(struct initrc_cmd *cur_cmd, uint16_t is_first_run, uint16_t initrc){
   /* fork and exec */
    int pid;
    if((pid = fork()) == 0){
        close(initrc);
        exec_cmd(cur_cmd);
    }
    cur_cmd->pid = pid;
    wait_respawn_cmd(cur_cmd, is_first_run);
}

struct initrc_cmd cur_cmd;

int main(){
    int len;
    uint16_t file_seek_loc;
    /* open initrc file */
    int initrc = open("/initrc", O_RDONLY);
    /* if we didn't open it, not much we can do (we don't have stderr) */
    if(initrc == -1){
        /* error */
        exit(1);
    }
    /* read lines and run */
    file_seek_loc = lseek(initrc, 0, SEEK_CUR);
    while((len = read_line(initrc, line_buf)) > 0){
        line_to_initrc(&cur_cmd, line_buf, len);
        run(&cur_cmd, 1, initrc);
    }

    /* loop, and respawn children if needed */
    int id;
    while((id = wait(NULL)) != -1){
        for(int i = 0; i < respawn_index; i++){
            if(id == respawn[i].pid){
                run(&respawn[i], 0, initrc);
            }
        }
    }

    /* die (no children left) */
    exit(7);
}
