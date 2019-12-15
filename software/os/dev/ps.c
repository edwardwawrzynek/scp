/**
 * Device driver for file that provides information for processes
 */

#include "dev.h"

#include <kernel/proc.h>
#include <sys/_ps_dev.h>
#include <kernel/kernel.h>
#include <lib/kmalloc.h>
#include <lib/kstdio_layer.h>

/* fill a ps_proc_info from an entry in the proc_table */static void fill_ps_proc_info(struct ps_proc_info * info, struct proc * entry) {
  info->pid = entry->pid;
  info->parent = entry->parent;

  info->mem_text_pages = entry->mem_struct.instr_pages;
  info->mem_data_pages = entry->mem_struct.data_pages;
  info->mem_stack_pages = entry->mem_struct.stack_pages;
  info->mem_total_pages = info->mem_data_pages + info->mem_text_pages + info->mem_stack_pages;

  if(entry->state == PROC_STATE_DEAD || entry->state == PROC_STATE_ZOMBIE) info->state = DEAD;
  else if(entry->state == PROC_STATE_INIT) info->state = INIT;
  else info->state = RUNNING;

  if(entry->pid == 0) info->state = KERNEL;

  info->cwd_inum = entry->cwd;
  info->croot_inum = entry->croot;


  if(entry->pid == 0) {
    strcpy(info->cmd, "kernel");
  } else if(entry->pid == 2) { 
    strcpy(info->cmd, "init");
  } else {
    /* TODO: get command */
    strcpy(info->cmd, entry->invoke_cmd);
  }
}

/* currently being written proccess */
static struct ps_proc_info cur_proc;
/* position of byte about to be written 
 * >= sizeof(struct ps_proc_info) indicates that new proc needs to be read */
static size_t cur_proc_offset = sizeof(struct ps_proc_info);
/* index in proc table */
static uint16_t proc_table_index = 0;

static int ps_getc() {
  if(cur_proc_offset >= sizeof(struct ps_proc_info)) {
    /* find good entry */
    while(1) {
      if(proc_table_index >= PROC_TABLE_ENTRIES) proc_table_index = 0;
      if(proc_table[proc_table_index++].in_use) {
        proc_table_index--;
        break;
      }
    }
    fill_ps_proc_info(&cur_proc, &proc_table[proc_table_index]);
    cur_proc_offset = 0;
    proc_table_index++;

  }
  return ((uint8_t *)(&cur_proc))[cur_proc_offset++];
}

int _ps_open(int minor, struct inode *ind) {
  cur_proc_offset = sizeof(struct ps_proc_info);
  proc_table_index = 0;
  return 0;
}

gen_read_from_getc(_ps_read, ps_getc)