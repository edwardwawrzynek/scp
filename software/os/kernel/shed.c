#include "include/defs.h"
#include "kernel/proc.h"
#include "kernel/int_handler.h"
#include "kernel/panic.h"
#include <panic.h>

/* sheduling algorithms for processes */

/* run the next waiting process in the process table
 * TODO: actually implement a real sheduling alogorithm
 * for now, this just goes to the next valid process after proc_current_proc and executes it
 * returns (none) - doesn't return (runs next proc instead) */

void shed_shedule(){
  //proc_current_proc's index in process table
  uint16_t proc_index, i;
  proc_index = proc_current_proc->mmu_index;
  for(i = proc_index+1; i < PROC_TABLE_ENTRIES; ++i){
    if(proc_table[i].in_use && proc_table[i].state == PROC_STATE_RUNNABLE){
      int_reset_timer(SHED_MAX_TIME);
      proc_begin_execute(proc_table + i);
    }
  }
  //start from beginning, running the proc again if needed
  for(i = 0; i <= proc_index; ++i){
    if(proc_table[i].in_use && proc_table[i].state == PROC_STATE_RUNNABLE){
      int_reset_timer(SHED_MAX_TIME);
      proc_begin_execute(proc_table + i);
    }
  }
  panic(PANIC_NO_PROC_TO_RUN);

}