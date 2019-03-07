#include <stdint.h>
#include <stdio.h>
#include <syscall.h>
#include <inout.h>
#include <stddef.h>

/* TODO: respawned processes are read again from the same offset in initrc. If
initrc is edited while system is running and proc respawns, this will cause problems */

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

#define MAX_NUM_RESPAWN 128
#define MAX_LINE_SIZE 128

/* buffer for initrc lines */
uint8_t line_buf[MAX_LINE_SIZE];
/* list of pids of procs created with mode 'r' */
int respawn_pids[MAX_NUM_RESPAWN];
int respawn_pids_index;
/* location in file to seek to to find line to run */
uint16_t respawn_seek_pos[MAX_NUM_RESPAWN];

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

void run_line(uint8_t * line, int len, int initrc, uint16_t file_seek_loc){
    uint8_t mode;
    uint8_t *dev;
    uint8_t *cmd;
    int pos;

    pos = 0;
    if(len < 3){
        exit(2);
    }
    /* get mode */
    mode = line_buf[pos++];
    /* check colon */
    if(line_buf[pos++] != ':'){
        /* error */
        exit(2);
    }
    /* find : after dev and set to null */
    dev = &line_buf[pos];
    while(line_buf[pos++] != ':' && pos < len);
    if(pos >= len){
        exit(2);
    }
    line_buf[pos-1] = '\0';
    cmd = &line_buf[pos];

    /* fork, setup stdin, out, and err for the proc, and exec */
    int pid;
    if((pid = fork()) == 0){
        close(initrc);
        int devfd_o = open(dev, O_RDWR);
        if(devfd_o == -1){
            exit(3);
        }
        /* copy devfd_o to fd 4 */
        int devfd = dup2(devfd_o, 4);
        if(devfd == -1)
            exit(4);
        /* duplicate to stdin, out, err */
        if(dup2(devfd, stdin) == -1)
            exit(4);
        if(dup2(devfd, stdout) == -1)
            exit(4);
        if(dup2(devfd, stderr) == -1)
            exit(4);

        /* close dev file (dev_fd_o was closed by dup) */
        if(close(devfd) == -1)
            exit(4);

        /* TODO: seperate command on spaces and pass as argv */
        execv(cmd, NULL);

        exit(5);

    }
    /* if mode was w, wait for proc to finish */
    if(mode == 'w'){
        if(wait(NULL) == -1)
            exit(6);
    }
    /* if mode was r, add to list to respawn */
    else if(mode == 'r'){
        respawn_seek_pos[respawn_pids_index] = file_seek_loc;
        respawn_pids[respawn_pids_index++] = pid;
    }
    /* don't keep track of children with mode o */
}

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
        run_line(line_buf, len, initrc, file_seek_loc);
        file_seek_loc = lseek(initrc, 0, SEEK_CUR);
    }
    /* loop, and respawn children if needed */
    int id;
    while((id = wait(NULL)) != -1){
        for(int i = 0; i < respawn_pids_index; i++){
            if(id == respawn_pids[i]){
                /* seek to location, and rerun */
                lseek(initrc, respawn_seek_pos[i], SEEK_SET);
                file_seek_loc = respawn_seek_pos[i];
                len = read_line(initrc, line_buf);
                if(len <= 0){
                    exit(8);
                }
                run_line(line_buf, len, initrc, file_seek_loc);

            }
        }
    }

    /* die (no children left) */
    exit(7);
}
