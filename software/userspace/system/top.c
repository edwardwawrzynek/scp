#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>

/* scp ps dev structures */
#include <sys/_ps_dev.h>

FILE * ps_dev;
/* total system mem (in pages): TODO */
uint16_t sys_total_mem = 128;

void get_term_size(uint16_t * width, uint16_t * height) {
  printf("\x1b[1000;1000H\x1b[6n\n");
  char width_str[10];
  char height_str[10];
  /* response is in for ESC[height;widthR */
  uint8_t mode = 0;
  uint8_t pos = 0;
  while(1) {
    char c = getchar();
    if(c == '\x1b' || c == '[') continue;
    else if(c == ';') {
      height_str[pos++] = '\0';
      mode = 1;
      pos = 0;
    } else if(c == 'R') {
      width_str[pos++] = '\0';
      break;
    } else if(mode == 0) {
      height_str[pos++] = c;
    }
    else if(mode == 1) {
      width_str[pos++] = c;
    }
  }

  *width = strtol(width_str, NULL, 10);
  *height = strtol(height_str, NULL, 10);
}

struct termios old_termios;
struct termios new_termios;

void top_exit(int code) {
  remove("/usr/ps/sys_ps_lock");
  ioctl(STDIN_FILENO, TCSETA, &old_termios);
  exit(code);
}

/**
 * top screen layout:
 * TITLE BAR
 * uptime: ___ 
 * Processes: __ total, __ running, __ zombie
 * CPU Usage: TODO
 * KiB Mem: __ total, __ used, __ free
 * 
 * PID PARENT STATE %MEM MEM_T MEM_D MEM_S CMD
 * ....
 */

/* line offsets */
#define proc_des_line_off 7
#define first_proc_line_off 8

/* colors */
#define title_bar_color 46
#define title_bar_fg 30

#define text_color 37
#define proc_text_color 37
#define proc_mem_color 95
#define proc_cmd_color 32


#define proc_des_color 43
#define proc_des_fg 30

/* run a loop */
void run(uint16_t width, uint16_t height) {
  /* title bar */
  uint16_t x_pos = (width - strlen("SCP TOP"))/2;
  printf("\x1b[H\x1b[%i;%im\x1b[K\x1b[1;%uHSCP TOP", title_bar_color, title_bar_fg, x_pos);
  /* uptime */
  printf("\x1b[2;1H\x1b[%i;49muptime: %i s", text_color, 0);

  /* draw process description bar */
  printf("\x1b[%i;1H\x1b[%i;%im\x1b[%i;1H", proc_des_line_off, proc_des_color, proc_des_fg, proc_des_line_off);
  printf("PID  PAR  S  %%MEM  TEX  DAT  STK  COMMAND\x1b[K\x1b[49m");

  /* go through processes and start gathering info */
  uint16_t proc_t = 0, proc_r = 0, proc_z = 0;
  uint16_t mem_used = 0;
  struct ps_proc_info proc_info;
  uint8_t hit_pid0 = 0;
  uint8_t index = 0;
  do {
    fread(&proc_info, 1, sizeof(struct ps_proc_info), ps_dev);
  } while (proc_info.pid != 0);
  while(1) {
    if(proc_info.pid == 0){
      if(hit_pid0) {
        printf("\x1b[J");
        break;
      }
      hit_pid0 = 1;
    }
    /* clear line */
    int16_t y_pos = first_proc_line_off+index;
    printf("\x1b[%im\x1b[%i;1H", proc_text_color, y_pos, y_pos);
    /* pid */
    printf("\x1b[1m\x1b[%i;1H     \x1b[%i;1H%i\x1b[22m", y_pos, y_pos, proc_info.pid);
    /* parent */
    printf("\x1b[%i;6H     \x1b[%i;6H%i", y_pos, y_pos, proc_info.parent);
    index++;
    /* state */
    proc_t++;
    if(proc_info.state == RUNNING) proc_r++;
    if(proc_info.state == DEAD) proc_z++;
    printf("\x1b[%i;11H   \x1b[%i;11H%c", y_pos, y_pos, proc_info.state == RUNNING ? 'R' : (proc_info.state == KERNEL ? 'K' : 'Z'));
    /* memory */
    printf("\x1b[%im", proc_mem_color);
    int16_t per_mem = (proc_info.mem_total_pages * 100) / sys_total_mem;
    printf("\x1b[%i;14H      \x1b[%i;14H%i%%", y_pos, y_pos, per_mem);
    printf("\x1b[%im", proc_text_color);
    printf("\x1b[%i;20H      \x1b[%i;20H%iK", y_pos, y_pos, proc_info.mem_text_pages*2);
    printf("\x1b[%i;25H      \x1b[%i;25H%iK", y_pos, y_pos, proc_info.mem_data_pages*2);
    printf("\x1b[%i;30H      \x1b[%i;30H%iK", y_pos, y_pos,proc_info.mem_stack_pages*2);
    mem_used += proc_info.mem_total_pages;


    printf("\x1b[%i;35H\x1b[K\x1b[%im%s\x1b[%im", y_pos, proc_cmd_color, proc_info.cmd, proc_text_color);

    fread(&proc_info, 1, sizeof(struct ps_proc_info), ps_dev);
  }

  /* print proc stats */
  printf("\x1b[3;1H\x1b[KProcesses: %u total, %u running, %u zombie, %i kernel\n", proc_t, proc_r, proc_z, 1);
  /* print cpu stats */
  printf("CPU:\n");
  /* print mem stats */
  printf("KiB Mem: %uK total, %uK used, %uK free, %u %%\n", sys_total_mem*2, mem_used * 2, (sys_total_mem - mem_used) * 2, (mem_used * 100)/sys_total_mem);
}

int main(int argc, char ** argv) {
  /* check for lockfile */
  struct stat lock_stat;
  if(stat("/usr/ps/sys_ps_lock", &lock_stat) == 0) {
    perror("ps: lock file /usr/ps/sys_ps_lock exists. Is there another top instance running?");
    exit(1);
  }
  /* create lockfile */
  FILE * lockfile = fopen("/usr/ps/sys_ps_lock", "w");
  /* disable echo, canonical mode, etc */
  ioctl(STDIN_FILENO, TCGETA, &old_termios);
  ioctl(STDIN_FILENO, TCGETA, &new_termios);
  new_termios.c_lflag &= ~(ICANON | ECHO);
  ioctl(STDIN_FILENO, TCSETA, &new_termios);
  /* disable input + output buffering */
  setbuf(stdin, NULL);
  ps_dev = fopen("/sys/ps", "r");
  if(ps_dev == NULL) {
    perror("ps: can't open process device file (/sys/ps): ");
    exit(1);
  }
  /* get terminal size */
  uint16_t width, height;
  /* clear terminal */
  printf("\x1b[m\x1b[2J\x1b[0;0H");
  get_term_size(&width, &height);
  while(1) run(width, height);
  top_exit(0);
}